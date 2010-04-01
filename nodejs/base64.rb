
require 'base64'

js = File.read('base64.js')
js64 = Base64.encode64(js).strip()

js_src = "data:text/javascript;base64,#{js64}"

File.open('base64.html', 'w') do |f|
	f.write <<HTML
<!DOCTYPE html>
<html>
<head>
</head>
<body>
  <script src="#{js_src}"></script>
</body>
</html>
HTML
end
