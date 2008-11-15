Dir.glob(File.dirname(__FILE__) + '/../lib/*.rb').each {|rb| require rb}

describe LazyLoader do
  before :each do
    @object = LazyLoader.new { @test_object = ['John Rules'] }
  end
  
  describe 'never calling the object' do
    it "shouldn't instantiate the test object" do
      @test_object.should == nil
    end
  end
  
  describe 'calling the object' do
    it 'should pass the method calls through' do
      @object.size.should == 1
      
      @test_object.should_not == nil
    end
  end
  
  it 'should pretend to be the original object' do
    @object.is_a?(Array).should == true
  end
end