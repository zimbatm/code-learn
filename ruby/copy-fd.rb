#!/usr/bin/env ruby

require 'socket'

Thread.abort_on_exception = true
BasicSocket.do_not_reverse_lookup = true

class ThreadGroup
  def join
    while (t = list.first)
      t.join
    end
  end
end

module CopyFd
  include Socket::Constants

  def run(argv)
    opened_fd = argv[0]
    socket = nil
    @stopping = false

    if opened_fd # is child

      log "Child"
      s2 = UNIXSocket.for_fd(opened_fd.to_i)
      io = s2.recv_io
      socket = Socket.for_fd(io.fileno)
      socket.setsockopt(:SOCKET, :REUSEADDR, 1)

      server_run(socket) do
        s2.puts("Thanks for all the fish")
        s2.close
      end

    else

      log "Master"
      socket = Socket.new(AF_INET, SOCK_STREAM, 0)
      sockaddr = Socket.pack_sockaddr_in( 2000, '0.0.0.0' )
      socket.setsockopt(:SOCKET, :REUSEADDR, 1)
      socket.bind( sockaddr )
      socket.listen( 5 )
      server_run(socket)

    end
  end

  def server_run(socket, &on_ready)
    tg = ThreadGroup.new
    trap("HUP") { swap_dance(socket) }

    # FIXME: it's not totally ready if #accept wasn't called
    yield if block_given?

    while !@stopping do
      log "Waiting for client"

      # FIXME: accept should be non-blocking
      # otherwise the server doesn't die until a client connects
      Thread.new(socket.accept) do |client, addr_info|
        tg.add Thread.current
        Thread.current[:fd] = client.fileno
        client.close_on_exec = true # don't share clients

        log "Connected"
        while line = client.gets
          log line
        end
        log "Disconnected"

      end

    end

    log "Waiting for closing connections"

    tg.join

    log "Dying"
  end

  def swap_dance(socket)
    return if @swap_dance
    @swap_dance = true

    log "Swap dance!"
    # #send_io is only available on UNIXSocket
    s1, s2 = UNIXSocket.pair
    #s1.close_on_exec = true
    #s2.close_on_exec = true
    fork do
      s1.close
      exec($0, s2.fileno.to_s)
    end
    s2.close
    s1.send_io socket

    Thread.new do
      # FIXME: is the child pid dies, the don't stop the master server
      line = s1.gets
      log line
      s1.close
      @stopping = true
      @swap_dance = false
    end
  end

  def log(msg, *args)
    $stderr.puts "[#{Process.pid} #{Thread.current[:fd] || "  "}] #{msg} #{args.map{|a| a.inspect}.join(', ')}"
  end

  extend self
end

if __FILE__ == $0
  CopyFd.run(ARGV)
end
