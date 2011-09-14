$stdout.sync = true

trap("INT") do
  puts "Trap has been called"
  exit 0
end

begin
  puts "Type Ctrl-C"
  sleep(1000)
rescue Exception => e
  puts "Got a system exception: #{e.class} #{e.inspect}"
  sleep(1000)
end
