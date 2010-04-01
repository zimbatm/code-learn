#!/usr/bin/env ruby

SIZE = ARGV[0].to_i

if SIZE <= 0
	puts "Please provide a byte count on the first argument"
end

File.open("_data.go", 'w') do |f|
	f.write <<HEAD
package main

func init() {
	vfs = NewVfs()
HEAD
	f.write("vfs.data[\"yo.txt\"]=")
	File.open("files/rand.bin", 'r') do |rnd|
		data = rnd.read(SIZE)

		# Write byte
		#f.write "[]byte{" + data.each_byte.map{|b| "0x%02x" % b }.join(',') + "}\n"
		# Write string
		f.write '"' + data.each_byte.map{|b| '\x%02x' % b}.join + '"' + "\n"
	end
	f.write <<TAIL
}

TAIL

end

