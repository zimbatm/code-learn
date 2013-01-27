

class Value
  @attributes = {}
  class << self
    attr_accessor :attributes

    def new(args={})
      obj = allocate
      attributes.each_pair do |key, opts|
        value = args.fetch(key, opts.default)
        raise ArgumentError, "Missing argument: #{key}" if value === Opts::MissingValue
        obj.instance_variable_set("@#{key}", value)
      end
      obj.send(:initialize)
      obj
    end

    def attr(name, opts={})
      name = name.to_sym
      opts = Opts.new(opts)

      attributes[name] = opts

      attr_reader name if opts.read?
      attr_writer name if opts.write?

      nil
    end

    def inherited(klass)
      klass.attributes = self.attributes.dup
    end
  end

  def to_hash
    self.class.attributes.inject({}) do |hash, (key, _)|
      hash[key] = instance_variable_get("@#{key}")
      hash
    end
  end

  def update(args={})
    self.class.new(to_hash.merge(args))
  end

  class Opts
    MissingValue = Object.new
    def read?; @read; end
    def write?; @write; end
    def has_default?; @default != MissingValue end
    attr_reader :default

    def initialize(opts={})
      @read = opts.fetch(:read, true)
      @write = opts.fetch(:write, true)
      @default = opts.fetch(:default, MissingValue)
    end
  end
end

if __FILE__ == $0
  require 'test/unit'

  class Gear < Value
    attr :wheel
    attr :diameter, default: 4

    attr_accessor :did_initialize
    def initialize
      @did_initialize = true
    end
  end

  class ValueTests < Test::Unit::TestCase
    def test_the_value_creation
      g = Gear.new(wheel: "wheel", diameter: 3)

      assert_equal "wheel", g.wheel
      assert_equal 3, g.diameter
      assert g.did_initialize
    end

    def test_the_default
      g = Gear.new(wheel: "Wheel")

      assert_equal 4, g.diameter
    end

    def test_argument_error
      assert_raises ArgumentError do
        Gear.new
      end
    end

    def test_the_to_hash_method
      g = Gear.new(wheel: "wheel", diameter: 3)
      assert_equal({wheel: "wheel", diameter: 3}, g.to_hash)
    end

    def test_the_update_method
      g = Gear.new(wheel: "wheel", diameter: 3)

      g2 = g.update(diameter: 5)

      assert_equal 3, g.diameter
      assert_equal 5, g2.diameter
    end
  end
end
