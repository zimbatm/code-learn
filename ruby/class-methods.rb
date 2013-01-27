
class Object
  # Creates a namespace that is not meant to be initialized
  def class_methods(&definition)
    m = Module.new(&definition)
    m.extend(m)
    m
  end
end

if __FILE__ == $0
  require 'test/unit'

  class TestClassMethods < Test::Unit::TestCase
    Mathz = class_methods do
      self::PI = 3.14
      def exp(x)
        x * x
      end
    end

    def test_methods_are_accessible
      assert_equal 4, Mathz.exp(2)
    end

    def test_constant_is_accessible
      assert_equal 3.14, Mathz::PI
    end

  end
end
