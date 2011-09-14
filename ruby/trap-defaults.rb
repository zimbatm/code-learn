
sleep 10000
orig = trap("INT") {
  puts "Custom"
}

p orig

trap("INT", "DEFAULT")
sleep 10000
