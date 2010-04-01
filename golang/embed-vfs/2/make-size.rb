#!/usr/bin/env ruby

SIZE = ARGV[0].to_i

if SIZE <= 0
	puts "Please provide a byte count on the first argument"
end

def sh(cmd)
	system cmd
	exit 1 if $?.exitstatus != 0
end

def to_hex(data)
	data.each_byte.map{|b| '\x%02x' % b}.join
end

def write_data(io, key, size)
	s = 0
	io.write "const #{key}= \""

	File.open("/dev/random", 'r') do |rnd|
		while s + 1024 < size
			s += 1024
			io.write to_hex(rnd.read(1024))
		end
		if (size-s) > 0
			data = rnd.read(size-s)
			io.write to_hex(data)
		end
	end
	io.write "\"\n"
end

File.open("main.go", 'w') do |f|
	f.write "package main\n"
	f.write "import \"fmt\"\n"

	write_data(f, "data", SIZE)
	write_data(f, "data1", SIZE)
	write_data(f, "data2", SIZE)
	write_data(f, "data3", SIZE)
	#write_data(f, "data2", SIZE)

	f.write <<TAIL
func main() {
  fmt.Printf("Got %d bytes of data\\n", len(data))
  fmt.Printf("Got %d bytes of data\\n", len(data1))
  fmt.Printf("Got %d bytes of data\\n", len(data2))
  fmt.Printf("Got %d bytes of data\\n", len(data3))
  fmt.Printf("%s%s%s%s", data, data1, data2, data3)
}

TAIL

end

# main.go written
$stdout.write "#{SIZE} - "

# compile time
t = Time.now
sh "6g -o _go_.6 main.go"
$stdout.write "%03.3f - " % (Time.now - t)

# linkage time
t = Time.now
sh "6l -d -o embed _go_.6"
$stdout.write "%03.3f\n" % (Time.now - t)

