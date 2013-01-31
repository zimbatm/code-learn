module DynamicConfig
  class ConfigurationError < StandardError; end
  Undefined = Object.new.freeze

  class Configuration
    class ValueObject
      def initialize(configuration, keys, &calculation)
        @configuration = configuration
        @calculation = calculation
        @keys = keys
        @value = Undefined
      end

      def reset!
        @value = Undefined
      end

      def value
        @value = @calculation.call(*@keys.map{|k| @configuration.send(k)}) if @value == Undefined
        @value
      end
    end

    attr_reader :schema

    def initialize(schema, data)
      @schema = schema

      @depends = Hash.new { |h,k| h[k] = [] }

      replace!(data)
    end

    def value_from(*keys, &calculation)
      # TODO: here we could check that the keys are indeed in the schema
      obj = ValueObject.new(self, keys, &calculation)

      keys.flatten.each do |key|
        @depends[key] << obj
      end

      obj
    end

    def method_missing(m, *a, &b)
      super unless schema.has_key?(m)

      value = @data[m]
      singleton_class.send(:define_method, m) { value }
      send(m)
    end

    # We could also have an #update method that calls merge + replace
    #
    # can throw a ConfigurationError
    def replace!(data)
      new_data = schema.validate(data)

      @data, old_data = new_data, @data
      if old_data
        # Invalidate old keys
        schema.keys.each do |key|
          invalidate_key!(key) if @data[key] != old_data[key]
        end
      end
    end
    private

    def invalidate_key!(key)
      # Remove local cache
      singleton_class.send(:remove_method, key) if respond_to?(key)
      # And remote caches
      @depends[key].each do |p| p.reset! end
    end
  end

  class Schema
    class DSL
      attr_reader :attributes
      def initialize(&config)
        @attributes = {}
        instance_eval(&config)
      end

      def optional(key, opts={})
        @attributes[key.to_sym] = opts.merge(required: false)
      end

      def required(key, opts={})
        @attributes[key.to_sym] = opts.merge(required: true)
      end
    end

    def self.define(&config)
      dsl = DSL.new(&config)
      new(dsl.attributes)
    end

    attr_reader :attributes
    attr_reader :keys
    attr_reader :required_keys

    def initialize(attributes)
      @attributes = attributes.freeze
      @keys = @attributes.keys
      @required_keys = @attributes.map{|k,v| k if v[:required]}.compact
    end

    def has_key?(key)
      attributes[key]
    end

    def validate(hash)
      # Has all keys and in the right format ?
      remaining_keys = required_keys - hash.keys
      if remaining_keys.any?
        raise ConfigurationError, "#{remaing_keys.inspect} need to be present in the config"
      end
      keys.inject({}) do |data, key|
        if hash.has_key?(key)
          data[key] = hash[key]
        else
          data[key] = attributes[key][:default]
        end
        data
      end
    end
  end
end

if __FILE__ == $0

require 'minitest/unit'
MiniTest::Unit.autorun
class TestDynamicConfig < MiniTest::Unit::TestCase
  ConfigSchema = DynamicConfig::Schema.define do
    required :aws_access_key
    optional :number_of_instances, default: 42
  end

  def setup
    @config = DynamicConfig::Configuration.new(ConfigSchema, {aws_access_key: 1234})
  end

  def test_some_basic_stuff
    assert_equal 1234, @config.aws_access_key
    assert_equal 42, @config.number_of_instances
  end

  def test_some_of_the_promise_ideas
    count =  0
    obj = @config.value_from(:number_of_instances) do |n|
      count += 1
      n / 2
    end
    assert_equal 21, obj.value
    assert_equal 21, obj.value
    assert_equal 1, count
    @config.replace!(aws_access_key: 1234, number_of_instances: 12)
    assert_equal 6, obj.value
    assert_equal 2, count
  end

end

end
