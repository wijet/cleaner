require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::Action do
  let(:files) { %w(file1 file2) }
  let(:options) { {:to => '~/foo'} }
  let(:action) { Cleaner::Action.new(files, options) }
  
  describe "being initialized" do
    it "should have files" do
      action.files.should be(files)
    end
    
    it "should have options" do
      action.options.should be(options)
    end
  end
  
  describe "#execute" do
    it "should raise exception" do
      lambda {
        action.execute
      }.should raise_error(Cleaner::Action::NotImplementedException, 
        "#execute should be implemented in your Action class")
    end
  end
end
