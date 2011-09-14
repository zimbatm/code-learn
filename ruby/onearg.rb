
def onearg(*args)
  args = *(args.flatten.first)
  p args
  args.flatten.first.to_s
  p args
  args
end

require 'test/unit'
class TestFoo < Test::Unit::TestCase
  def test_args
    assert_equal("foo", onearg("foo"))
    assert_equal("foo", onearg("foo", "bar"))
    assert_equal("foo", onearg("foo", "bar", "baz"))
  end
  def test_ary
    assert_equal("foo", onearg(["foo"]))
    assert_equal("foo", onearg(["foo", "bar"]))
    assert_equal("foo", onearg(["foo", "bar", "baz"]))
  end
  def test_hash
    assert_equal("foo", onearg("foo" => "bar"))
  end

end
