require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::Action do
  let(:files) { %w(file1 file2) }
  let(:action) { Cleaner::Action.new(files) }
  
  describe "being initialized" do
    it "should have files" do
      action.files.should be(files)
    end
  end
end
