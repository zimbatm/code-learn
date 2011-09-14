
def mem
  result = 4
  (class << self; self; end).send(:define_method, :mem) do
    result
  end
  result
end

def classic_mem
  if !@result
    @result = 4
  end
  @result
end

require 'benchmark'
Benchmark.bm(7) do |x|
  x.report "classic" do
    10_000.times do
      classic_mem
    end
  end
  x.report "new" do
    10_000.times do
      mem
    end
  end
end
