require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::Directory do
  let(:block) do
    Proc.new do
      delete :dmg, :after => 10.days
      delete :download
      delete :after => 100.days
    end
  end

  let(:directory) { Cleaner::Directory.new('~/downloads', block)}

  describe "being initialize" do
    it "should have path" do
      directory.path.should == '~/downloads'
    end

    it "should have block" do
      directory.block.should == block
    end
  end

  describe "#clean" do
    it "should eval block in its own context" do
      block = Proc.new {}
      directory = Cleaner::Directory.new('~/downloads', block)
      directory.should_receive(:instance_eval).with(&block)
      directory.clean
    end
  end

  describe "#method_missing" do
    before do
      @filter = mock(:filterize => %w(file1))
      Cleaner::FileFilter.stub(:new).and_return(@filter)
      @action = mock(:execute => true)
      Cleaner::Actions::Delete.stub(:new).and_return(@action)
    end

    context "on unknown action" do
      it "should raise Action::UnknownActionException" do
        lambda {
          block = Proc.new { fooooo :txt }
          directory = Cleaner::Directory.new('~/downloads', block)
          directory.clean
        }.should raise_error(Cleaner::Action::UnknownActionException, "Action 'fooooo' is unknown")
      end
    end

    it "should initialize FileFilter object" do
      Cleaner::FileFilter.should_receive(:new).with(
        :pattern => :dmg,
        :path => '~/downloads',
        :after => 10.days
      )
      directory.clean
    end

    it "should initialize action class with files and options" do
      Cleaner::Actions::Delete.should_receive(:new).with(%w(file1),
        :pattern => :dmg,
        :path => '~/downloads',
        :after => 10.days
      )
      directory.clean
    end

    context "when no pattern is given" do
      it "should initialize action with nil as pattern" do
        Cleaner::Actions::Delete.should_receive(:new).with(%w(file1),
          :pattern => nil,
          :path => '~/downloads',
          :after => 100.days
        )
        directory.clean
      end
    end

    it "should execute action" do
      @action.should_receive(:execute)
      directory.clean
    end
  end
end
