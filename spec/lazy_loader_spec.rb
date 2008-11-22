Dir.glob(File.dirname(__FILE__) + '/../lib/*.rb').each {|rb| require rb}

describe LazyLoader do
  before :each do
    @object = LazyLoader.new { @test_object = 'John Rules' }
  end
  
  describe 'never calling the object' do
    it "shouldn't instantiate the test object" do
      @test_object.should == nil
    end
  end
  
  describe 'calling the object' do
    it 'should pass the method calls through' do
      @test_object.should == nil
      
      @object.should == 'John Rules'
      
      @test_object.should_not == nil
    end
  end
  
  it 'should pretend to be the original object' do
    @object.is_a?(String).should == true
  end
  
  it "should respond_to the original object's methods" do
    @object.should respond_to(:chomp)
  end
end

describe "include Lazy" do
  include Lazy
  
  it "lazy { 2 + 2 }.should == 4, damn that's lazy!" do
    lazy { 2 + 2 }.should == 4
  end
end