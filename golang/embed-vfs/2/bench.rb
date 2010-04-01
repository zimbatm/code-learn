
def sh(cmd)
	system cmd
	exit 1 if $?.exitstatus != 0
end

(0..100).each do |i|
  i = 499990 + (i * 1)
  sh "./make-size.rb #{i}"
end

