

module MyLib
  module Error; end

  def my_method
    raise ArgumentError, "woot"
  rescue taint(NoMethodError) => ex
    raise
  end

  def taint(*exceptions)
    $!.extend Error
    return *exceptions
  end

  extend self


end

begin
  MyLib.my_method
rescue MyLib::Error
  puts $!
end
