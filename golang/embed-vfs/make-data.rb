#!/usr/bin/env ruby

PATH = ARGV[0] || "./files"

File.open("_data.go", 'w') do |f|
	f.write <<HEAD
package main

func init() {
	vfs = NewVfs()
HEAD
	Dir.chdir(PATH) do
		Dir["**/**"].each do |fpath|
			if File.file?(fpath)
			data = File.read(fpath)
			f.write("vfs.data[\"#{fpath}\"]=")
			# Write byte
			#f.write "[]byte{" + data.each_byte.map{|b| "0x%02x" % b }.join(',') + "}\n"
			# Write string
			f.write '"' + data.each_byte.map{|b| '\x%02x' % b}.join + '"' + "\n"
			end
		end
	end
	f.write <<TAIL
}

TAIL

end

