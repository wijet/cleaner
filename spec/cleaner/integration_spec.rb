require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Cleaner: integration spec" do
  let(:config) do
    <<-EOS
manage '~/Downloads' do
  delete :dmg, :after => 5.days
  delete :after => 1.month
end

manage '/foo/bar' do
  delete "abc.*"
end

EOS
  end

  let(:runner) { Cleaner::Runner.new(config) }

  before do
    example_dir '~/Downloads' do
      touch 'Firefox99.dmg', :at => 7.days.ago
      touch 'growl.dmg', :at => 2.days.ago
      touch 'something-old', :at => 2.months.ago
      2.times { |i| touch "important-#{i}.doc" }
    end
    
    example_dir '/foo/bar' do
      %w(abc.txt abc.mp3 ddd.doc).each { |name| touch name }
    end    
    
    runner.start
  end
  
  context "~/Downloads directory" do
    before { Dir.chdir("~/Downloads") }

    it "should delete :dmg files older than 5 days" do
      File.exists?("Firefox99.dmg").should be_false
    end
  
    it "should leave :dmg files younger than 5 days" do
      File.exists?("growl.dmg").should be_true
    end
  
    it "should leave :doc files" do
      File.exists?("important-0.doc").should be_true
      File.exists?("important-1.doc").should be_true
    end
    
    it "should delete everything that is older than 1 month" do
      
    end
  end
  
  context "/foo/bar directory" do
    before { Dir.chdir("/foo/bar") }
    
    it "should delete all files maching abc.*" do
      File.exists?("abc.txt").should be_false
      File.exists?("abc.mp3").should be_false
    end
    
    it "should leave not matching abc.*" do
      File.exists?("ddd.doc").should be_true      
    end
  end
end
