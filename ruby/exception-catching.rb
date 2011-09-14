
def want_rescue
  $!.class
end

begin
  raise "foo"
rescue want_rescue => ex
  puts ex
end

