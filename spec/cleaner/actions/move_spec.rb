require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Cleaner::Actions::Move do
  before do
    example_dir '/foo' do
      %w(a.zip b.txt).each { |name| touch name }
    end
    Dir.chdir('/foo')
  end
  
  let(:move) { Cleaner::Actions::Move.new(%w(a.zip), :to => "~/zip-files") }
  
  context "destination dir doesn't exist" do
    it "should create it" do
      move.execute
      File.exists?(File.expand_path("~/zip-files")).should be_true
    end
  end
  
  it "should move files" do
    move.execute
    File.exists?("a.zip").should be_false
    File.exists?(File.expand_path("~/zip-files/a.zip")).should be_true
  end
  
  it "should leave other files" do
    move.execute
    File.exists?("b.txt").should be_true
  end
end
