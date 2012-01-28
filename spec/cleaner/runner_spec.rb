require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Cleaner::Runner do
  let(:rules) do
    "manage '~/Downloads' do
     end"
  end
  let(:runner) { Cleaner::Runner.new(rules) }

  describe "being initialize" do
    it "should have rules" do
      runner.rules.should == rules
    end
  end

  describe "#start" do
    it "should instance eval rules" do
      runner.should_receive(:instance_eval).with(rules)
      runner.start
    end

    it "should run #clean on all directories" do
      directory = mock
      directory.should_receive(:clean)
      runner.stub(:directories).and_return([directory])
      runner.start
    end
  end

  describe "#manage" do
    it "should initialize new directory" do
      runner.start
      directory = runner.directories.first
      directory.path.should == "~/Downloads"
    end
  end
end