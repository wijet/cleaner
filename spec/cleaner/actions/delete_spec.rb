require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Cleaner::Actions::Delete do
  before do
    example_dir '/foo' do
      %w(a.zip b.txt c.zip).each { |name| touch name }
      example_dir '/foo/bar'
    end
    Dir.chdir('/foo')
  end

  let(:delete) { Cleaner::Actions::Delete.new(%w(a.zip c.zip bar)) }

  it "should delete given files and directories" do
    delete.execute
    File.exists?('a.zip').should be_false
    File.exists?('c.zip').should be_false
    File.exists?('bar').should be_false
  end

  it "should leave other files" do
    delete.execute
    File.exists?('b.txt').should be_true
  end
end
