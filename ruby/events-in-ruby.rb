class Event; end

module ClassicEventHandler
  def on(name, &callback)
    events[name] ||= []
    events[name].push callback
  end

  def dispatch(name, event)
    (events[name] || []).each do |callback|
      callback.call(event)
    end
  end

  protected
  def events; @events ||= {}; end
end

class Foo
  include ClassicEventHandler
end

f = Foo.new
f.on("foo") do
  p "Got an event"
end
f.dispatch("foo", Event.new)

=begin
Event handling is like ruby's method dispatch except that it:
 * doesn't raise if no handler is given
 * all arguments are merged in a single event object
 * calls all the definitions (unless a cancel is called)
 * the return value is not determined by the callback's return value
=end

class RubyEventHandler
  def method_missing(m, *a, &b)
    return if a.size <= 1
    super
  end
end

class Bar
  attr_reader :events
  def initialize
    @events = RubyEventHandler.new
  end
end

module FooHandler
  def foo(event=nil)
    p ["Got an event", event]
    super
  end
end

b = Bar.new
b.events.extend FooHandler
b.events.foo(Event.new)


=begin
Another approach would be to add objects as event listeners. This could also work in JavaScript
=end

class EventObject < Object
end

require 'set'
class EventDispatcher
  def initialize
    @objects = Set.new
  end

  def bind(object)
    @objects.add(object)
  end

  def method_missing(m, *a, &b)
    super if a.size > 1
    @objects.each do |o|
      o.respond_to?(m) && o.public_send(m, a.first)
    end
    nil
  end
end


class FooObjectHandler < EventObject
  def foo(event=nil)
    p ["Got an event 3", event]
  end
end

b = EventDispatcher.new
b.bind(FooObjectHandler.new)
b.bind(FooObjectHandler.new)
b.foo
