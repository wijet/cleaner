require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::Directory do
  let(:block) { lambda {} }
  let(:directory) { Cleaner::Directory.new('~/downloads', block)}
  
  describe "being initialize" do
    it "should have path" do
      directory.path.should == '~/downloads'
    end
    
    it "should have block" do
      directory.block.should == block
    end
  end
  
  describe "#clean"
end
