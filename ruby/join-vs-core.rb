

S = File::SEPARATOR

def file_join(*args)
  args.join(S)
end

require 'benchmark'
N = 100_000
SAMPLE = ['a/', 'b', 'c', 'd', 'e', 'f']

Benchmark.bm do |x|
  x.report("Native") do
    N.times do
      File.join SAMPLE
    end
  end
  x.report("Custom") do
    N.times do
      file_join SAMPLE
    end
  end
end

require 'test/unit'

class TestFileJoin < Test::Unit::TestCase
  def test_behavior
    assert_equal File.join(SAMPLE), file_join(SAMPLE)
    assert_equal "a/b/c/d/e/f", File.join(SAMPLE)
  end
end
