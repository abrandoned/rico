require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

shared_examples_for "a Hot Rod Client" do 
  before(:each) do 
    subject.remove("hello")
  end

  # :ping
  it "allows cache server ping" do
    subject.ping.should equal(true)
  end

  # :clear
  it "supports clear when data is present" do
    subject.put("hello", "world").should equal(true)  
    subject.put("hello1", "world").should equal(true)  
    subject.put("hello2", "world").should equal(true)  
    subject.clear.should equal(true)
    subject.contains_key("hello").should equal(false)  
    subject.contains_key("hello1").should equal(false)  
    subject.contains_key("hello2").should equal(false)
  end

  # :clear
  it "supports clear when data is not present" do
    subject.contains_key("hello").should equal(false)  
    subject.contains_key("hello1").should equal(false)  
    subject.contains_key("hello2").should equal(false)
    subject.clear.should equal(true)
    subject.contains_key("hello").should equal(false)  
    subject.contains_key("hello1").should equal(false)  
    subject.contains_key("hello2").should equal(false)
  end
    
  # :put
  it "supports String put" do 
    subject.put("hello", "world").should equal(true)  
  end
  
  # :get
  it "supports get of previously put String" do 
    subject.contains_key("hello").should equal(false)
    subject.put("hello", "world").should equal(true)
    subject.get("hello").should == "world"
  end

  # :get
  it "fails get when key is not present (does not get and returns false)" do 
    subject.contains_key("hello").should equal(false)
    subject.get("hello").should equal(false)
    subject.contains_key("hello").should equal(false)
  end

  # :get_with_version
  context "supports get_with_version" do 
    it "returns a version and the data" do 
      subject.contains_key("hello").should equal(false)
      subject.put("hello", "world").should equal(true)
      @gwv = subject.get_with_version("hello")
      @gwv[:version].should_not be_empty
      @gwv[:data].should == "world"
    end

    it "returns a different version after update" do 
      subject.contains_key("hello").should equal(false)
      subject.put("hello", "world").should equal(true)
      @gwv = subject.get_with_version("hello")
      @gwv[:version].should_not be_empty
      @gwv[:data].should == "world"

      subject.put("hello", "world2").should equal(true)
      @gwv2 = subject.get_with_version("hello")
      @gwv2[:version].should_not be_empty
      @gwv2[:data].should == "world2" 

      @gwv2[:version].should_not == @gwv[:version]
    end

    it "returns a different version after update with the same value" do 
      subject.contains_key("hello").should equal(false)
      subject.put("hello", "world").should equal(true)
      @gwv = subject.get_with_version("hello")
      @gwv[:version].should_not be_empty
      @gwv[:data].should == "world"

      subject.put("hello", "world").should equal(true)
      @gwv2 = subject.get_with_version("hello")
      @gwv2[:version].should_not be_empty
      @gwv2[:data].should == "world" 

      @gwv2[:version].should_not == @gwv[:version]
    end
  end
  
  # :replace
  it "supports replace of previously put String" do
    subject.put("hello", "world").should equal(true) 
    subject.replace("hello", "what").should equal(true)
    subject.get("hello").should == "what"
  end

  # :replace
  it "supports replace when key is not present (does not put and returns false)" do
    subject.contains_key("hello").should equal(false)
    subject.replace("hello", "what").should equal(false)
    subject.contains_key("hello").should equal(false)
  end

  # :remove
  it "supports remove of previously put String" do 
    subject.put("hello", "world").should equal(true)
    subject.remove("hello").should equal(true)
    subject.get("hello").should equal(false)
  end

  # :remove
  it "supports remove when key is not present (returns false on remove)" do 
    subject.contains_key("hello").should equal(false)
    subject.remove("hello").should equal(false)
    subject.contains_key("hello").should equal(false)
  end

  # :contains_key
  it "supports contains_key" do 
    subject.contains_key("hello").should equal(false)
    subject.put("hello", "world").should equal(true)
    subject.contains_key("hello").should equal(true)
  end 
  
  # :put_if_absent
  it "supports put_if_absent when key is absent" do 
    subject.contains_key("hello").should equal(false)
    subject.put_if_absent("hello", "world").should equal(true)
    subject.get("hello").should == "world"
  end 

  # :put_if_absent
  it "supports put_if_absent when key is present (does not change value and returns false on call)" do 
    subject.contains_key("hello").should equal(false)
    subject.put("hello", "world").should equal(true)
    subject.put_if_absent("hello", "what").should equal(false)
    subject.get("hello").should == "world"
  end

  # :replace_if_unmodified
  it "supports replace_if_unmodified when key has not been modified" do 
    subject.contains_key("hello").should equal(false)
    subject.put("hello", "world").should equal(true)
    @version = subject.get_with_version("hello")[:version]
    subject.replace_if_unmodified("hello", "what", :version => @version).should equal(true)
    subject.get("hello").should == "what"
  end

  # :replace_if_unmodified
  it "fails replace_if_unmodified when key has been modified" do 
    subject.contains_key("hello").should equal(false)
    subject.put("hello", "world").should equal(true)
    @version = subject.get_with_version("hello")[:version]
    subject.put("hello", "forld").should equal(true)
    subject.replace_if_unmodified("hello", "what", :version => @version).should equal(false)
    subject.get("hello").should == "forld"
  end

  # :remove_if_unmodified
  it "supports remove_if_unmodified when key has not been modified" do 
    subject.contains_key("hello").should equal(false)
    subject.put("hello", "world").should equal(true)
    @version = subject.get_with_version("hello")[:version]
    subject.remove_if_unmodified("hello", :version => @version).should equal(true)
    subject.contains_key("hello").should equal(false)
  end

  # :remove_if_unmodified
  it "fails remove_if_unmodified when key has been modified" do 
    subject.contains_key("hello").should equal(false)
    subject.put("hello", "world").should equal(true)
    @version = subject.get_with_version("hello")[:version]
    subject.put("hello", "what").should equal(true)
    subject.remove_if_unmodified("hello", :version => @version).should equal(false)
    subject.get("hello").should == "what"
  end
end

describe Rico::Basic do
  context "vanilla client" do 
    it_should_behave_like "a Hot Rod Client"
  end
  
  context "ping protected client" do 
    subject { Rico::Basic.new({:ping_protect => true})}
    it_should_behave_like "a Hot Rod Client"
  end
end