require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::FileExtension do
  before do
    example_dir '/foo' do
      touch 'bar.txt'
      touch 'bar.txt.zip'
    end
  end

  let(:file) { File.new("/foo/bar.txt").extend(Cleaner::FileExtension) }

  describe "#name" do
    it "should return file name" do
      file.name.should == "bar.txt"
    end
  end

  describe "#path_without_ext" do
    it "should return file path name without file extension" do
      file.path_without_ext.should == "/foo/bar"
    end
  end

  describe "#name_without_ext" do
    it "should return file name without last extension" do
      file.name_without_ext.should == "bar"

      file = File.new("/foo/bar.txt.zip")
      file.extend(Cleaner::FileExtension)
      file.name_without_ext.should == "bar.txt"
    end
  end
end
