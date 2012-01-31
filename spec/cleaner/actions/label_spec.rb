require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Cleaner::Actions::Label do
  before do
    example_dir '/foo' do
      %w(a.zip b.txt).each { |name| touch name }
    end
    Dir.chdir('/foo')
  end

  let(:label) { Cleaner::Actions::Label.new(%w(/foo/a.zip), :color => :red) }

  it "should invoke labeling script for given file with color's code" do
    command = "osascript -e \"tell application \\\"Finder\\\" to set label index of file (POSIX file \\\"/foo/a.zip\\\") to 2\""
    label.should_receive(:`).with(command)
    label.execute
  end
end
