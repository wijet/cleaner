require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Cleaner::Actions::Copy do
  before do
    example_dir '/foo' do
      %w(a.zip c.zip).each { |name| touch name }
      touch 'b.txt', :content => 'btext'
    end

    example_dir '/foo/bar' do
      touch 'barfile', :content => 'bartext'
    end

    Dir.chdir('/foo')
  end

  let(:copy) { Cleaner::Actions::Copy.new(%w(b.txt bar), :to => "/somewhere/dest") }

  context "destination doesn't exist" do
    it "should create it" do
      File.exists?("/somewhere/dest").should be_false
      copy.execute
      File.exists?("/somewhere/dest").should be_true
    end
  end

  it "should copy files to destination" do
    copy.execute
    File.read("/somewhere/dest/b.txt").should == "btext"
  end

  it "should copy directories to destination" do
    copy.execute
    File.read("/somewhere/dest/bar/barfile").should == "bartext"
  end

  it "should leave source files" do
    copy.execute
    File.read("/foo/b.txt").should == "btext"
    File.read("/foo/bar/barfile").should == "bartext"
  end
end
