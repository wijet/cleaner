require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::FileFilter do
  before do
    example_dir '/foo' do
      2.times { |i| touch "b-#{i}.zip" }
      touch 'cc.txt'
    end
  end
  
  let(:options) { {:path => '/foo', :pattern => :zip} }
  let(:filter) { Cleaner::FileFilter.new(options) }
  
  describe "being initialize" do
    it "should have options" do
      filter.options.should == options
    end
  end
  
  describe "#filterize" do    
    it "should return filtered files" do
      filter.filterize.should == %w(/foo/b-0.zip /foo/b-1.zip)
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
