

def foo
  puts "Before block"
  error = false
  begin
    puts "Block"
    raise
  rescue
    unless error
      retry
    else
      error = true
      raise
    end
  end
end

foo
