
puts "First test"
ret = trap("INT") { puts "Got int" }
p ret
sleep 10
ret = trap("INT", "DEFAULT")
p ret
sleep 10
