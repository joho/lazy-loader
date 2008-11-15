
# if in your controller you previously had
#   
#   def index
#     @posts = Post.find_all_by_a_painfully_slow_method
#   end
# 
# you would now write
# 
#   def index
#     @posts = lazy_load { Post.find_all_by_a_painfully_slow_method }
#   end
# 
# and your painfully slow finder methods will only be called if @posts is actually referred to in the view.
# 
# This works by created a LazyLoader proxy object that takes the place of your collection (or whatever it is) and will instantiate your object the first time any method is called on it. It then caches your original object and routes all methods calls through. 
# 
# You will get a performance hit if you are calling many methods on your object, but the common case for these is returning a collection of ActiveRecord::Base and once you've called each you're done with the proxy.

class LazyLoader
  instance_methods.each { |m| undef_method m unless m =~ /^__/ }
  
  def initialize(&block)
    @block = block
  end
  
  # Catches any method calls intended for the inner object. On the first call it will
  # invoke the block given when the LazyLoader was created and cache the result. From then on
  # all method calls are routed directly into the inner object
  def method_missing(method, *args, &block)
    @inner_object ||= @block.call
    @inner_object.send method, *args, &block
  end
  
  #   
  # Allows the LazyLoader class to both be identified on it's own but also pretend to be
  # the inner class.
  # 
  #       @posts = lazy_load { Post.all }
  #       @posts.is_a? LazyLoader # => true
  #       @posts.is_a? Array      # => true
  def is_a?(klass)
    klass == self.class || @inner_object.class
  end
end

module LazyLoaderControllerMethods
  # controller helper method to create your lazy loading proxy. usage would be something like:
  # @posts = lazy_load { Post.all :order => 'created_at DESC' }
  # 
  # the code in that block will not be invoked until the instance variable is actually used in the view.
  # very handy for fragment caching, makes it behave a little more like partial action caching
  def lazy_load(&block)
    LazyLoader.new(&block)
  end
end