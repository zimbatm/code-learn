require 'socket'

server = TCPServer.open(8080)
puts "Open on 8080"

RN = "\r\n"

loop do
	socket = server.accept
	puts "Got conn"

	Thread.start do
		s = socket
		req = ""

		while line = s.gets
			break if line == RN
			req += line
		end
		puts "Req done"

		head = ""
		head += "HTTP/1.1 200 OK" + RN
		head += "Content-Type: text/html" + RN
		head += "Content-Length: ${PAGE_SIZE}" + RN
		head += "Set-Cookie: s33kret=42; path=/; HttpOnly" + RN
		head += "Set-Cookie: pub=66; path=/" + RN
		head += RN

		page = <<-HTML
<!DOCTYPE html>
<html>
<head>
<script>

function setS33kret() {
  document.cookie='s33kret=override; path=/';
  showCookie()
}

function showCookie() {
  var pre=document.getElementById('cooky');
  pre.innerHTML = document.cookie;
}
</script>
</head>
<body onload="showCookie()">

What I got from the browser:
<pre>#{req}</pre>

What I responded:
<pre>#{head}</pre>

What I see from javascript land:
<pre id=cooky></pre>

<input type=button onclick="setS33kret()" value="override s33kret">
</body>
</html>
HTML
		head2 = ""
                head2 += "HTTP/1.1 200 OK" + RN
                head2 += "Content-Type: text/html" + RN
                head2 += "Content-Length: #{page.size}" + RN
                head2 += "Set-Cookie: s33kret=42; path=/; HttpOnly" + RN
                head2 += "Set-Cookie: pub=66; path=/" + RN
                head2 += RN

		s.write head2
		s.write page
		s.close
	end
end
