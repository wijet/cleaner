require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::FileFilter do
  before do
    example_dir '/foo' do
      touch 'b-0.zip' 
      touch 'b-1.zip', :at => 2.days.ago
      touch 'cc.txt'
    end
  end
  
  def filter(options = {})
    options = {:path => '/foo', :pattern => :zip}.merge(options)
    Cleaner::FileFilter.new(options)
  end
  
  describe "being initialize" do
    it "should have options" do
      filter.options.should == {:path => '/foo', :pattern => :zip}
    end
  end
  
  describe "#filterize" do    
    it "should return files filtered by name" do
      filter.filterize.should == %w(/foo/b-0.zip /foo/b-1.zip)
    end
    
    it "should return files filtered by :after option" do
      filter(:after => 1.day).filterize.should == %w(/foo/b-1.zip)
    end
  end
  
  describe "#search_pattern" do
    context "when symbol is given" do
      it "should be used as file extension" do
        filter.search_pattern.should == '/foo/*.zip'
      end
    end
    
    context "when string given" do
      it "should be used as filename pattern" do
        filter = Cleaner::FileFilter.new(:path => '/some', :pattern => 'foo.*')
        filter.search_pattern.should == '/some/foo.*'
      end
    end
  end
end
