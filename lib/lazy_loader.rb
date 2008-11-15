class LazyLoader
  instance_methods.each { |m| undef_method m unless m =~ /^__/ }
  
  def initialize(&block)
    @block = block
  end
  
  def method_missing(method, *args, &block)
    @inner_object ||= @block.call
    @inner_object.send method, *args, &block
  end
  
  def is_a?(klass)
    klass == self.class || @inner_object.class
  end
end

module LazyLoaderControllerMethods
  def lazy_load(&block)
    LazyLoader.new(&block)
  end
end