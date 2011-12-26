require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "cleaner/cli"

describe Cleaner::CLI do
  let(:rules) { "manage('~/Downloads') {}" }
  let(:cli) { Cleaner::CLI.new }
  before do
    @home_path = File.expand_path("~")
    @config_path = File.join(@home_path, ".cleaner.rb") 
    FileUtils.mkdir_p(@home_path)
    File.open(@config_path, "w") do |file|
      file << "manage('~/Downloads') {}"
    end
    @app = mock
  end
  
  describe "#start" do
    it "should invoke start on daemon application" do
      @app.should_receive(:start)
      cli.should_receive(:daemon_application).and_return(@app)
      cli.start
    end
  end
  
  describe "#stop" do
    it "should invoke stop on daemon application" do
      @app.should_receive(:stop)
      cli.should_receive(:daemon_application).and_return(@app)
      cli.stop
    end  
  end
  
  describe "#cleanup" do
    it "should invoke run_cleaner" do
      cli.should_receive(:run_cleaner)
      cli.cleanup
    end      
  end

  describe "#run_cleaner" do
    before do
      @runner = mock(:start => nil)
      Cleaner::Runner.stub(:new).and_return(@runner)
    end
    
    it "should initialize runner with rules" do
      Cleaner::Runner.should_receive(:new).with(rules)
      cli.run_cleaner
    end
    
    it "should start the runner" do
      @runner.should_receive(:start)
      cli.run_cleaner
    end
  end
  
  describe "#daemon_application" do
    it "should construct daemon application" do
      proc = Proc.new {}
      cli.stub(:runner_proc).and_return(proc)
      group = mock
      options = {:mode => :proc, :proc => proc, :dir_mode => :normal, :dir => "/tmp"}
      group.should_receive(:new_application).with(options)
      Daemons::ApplicationGroup.should_receive(:new).with('cleaner', options).and_return(group)
      cli.daemon_application
    end
  end
  
  describe "#load_rules" do
    it "should load config file" do
      cli.load_rules.should == rules
    end
    
    context "on missing file" do
      before do
        FileUtils.rm_rf(@config_path)
        $stdout.stub(:puts)
      end
      
      it "should display error message" do
        $stdout.should_receive(:puts).with("\e[31mConfig file #{@config_path} doesn't exist\e[0m")
        lambda {
          cli.load_rules
        }.should raise_error(SystemExit)
      end
      
      it "should exit with 1" do
        lambda {
          cli.load_rules
        }.should raise_error { |error| error.status.should be(1) }
      end
    end
  end
end
