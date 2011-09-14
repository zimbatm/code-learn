class Foo
end

module Panda
  module Models
    class Foo
    end
  end
  include Models

  module Bar
    # This resolves to ::Foo
    p Foo.name
  end

  # This resolves to Panda::Models::Foo
  p Foo.name
end
