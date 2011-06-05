
def foo
  raise ArgumentError
end

def with_bt
  yield
rescue => ex
  p ex.backtrace[0..3]
end

def rescue_raise
  yield
rescue => ex
  raise ex
end

with_bt do
  rescue_raise do
    foo
  end
end
