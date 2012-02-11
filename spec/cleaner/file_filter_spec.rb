require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::FileFilter do
  before do
    example_dir '/foo' do
      touch 'b-0.zip', :mtime => 10.days.ago
      touch 'b-1.zip', :ctime => 2.days.ago
      touch 'cc.txt', :ctime => 3.days.ago
      touch 'big.txt', :content => "abc" * 10
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

    it "should return files filtered by :after condition (using change time)" do
      filter(:after => 1.day).filterize.should == %w(/foo/b-1.zip)
    end

    it "should return files filtered by :if option" do
      filter(
        :if => proc { |file| file.name =~ /\w\w\.txt$/ },
        :pattern => nil
      ).filterize.should == %w(/foo/big.txt /foo/cc.txt)
    end

    it "should return files filtered by two conditions :if and :after" do
      filter(
        :after => 1.day,
        :if => proc { |file| file.name =~ /c/ },
        :pattern => nil
      ).filterize.should == %w(/foo/cc.txt)
    end

    it "should return files filtered by :smaller_than condition" do
      filter(
        :smaller_than => 10.bytes,
        :pattern => nil
      ).filterize.should == %w(/foo/b-0.zip /foo/b-1.zip /foo/cc.txt)
    end
  end

  describe "#search_pattern" do
    context "when nil given" do
      it "should use '*' as filename pattern" do
        filter = Cleaner::FileFilter.new(:path => '/some', :pattern => nil)
        filter.search_pattern.should == '/some/*'
      end
    end

    context "when symbol given" do
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

    context "when Array given" do
      it "should use every element as file extension pattern" do
        filter = Cleaner::FileFilter.new(:path => '/some', :pattern => %w(pdf doc))
        filter.search_pattern.should == %w(/some/*.pdf /some/*.doc)
      end
    end
  end
end
