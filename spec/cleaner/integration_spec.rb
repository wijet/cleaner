require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Cleaner: integration spec" do
  let(:config) do
    <<-EOS
manage '~/Downloads' do
  delete :dmg, :after => 5.days
end
EOS
  end
  
  before do
    example_dir '~/Downloads' do
      touch 'Firefox99.dmg', :at => 7.days.ago
      touch 'growl.dmg', :at => 2.days.ago
      2.times { |i| touch "important-#{i}.doc" }
    end
    Dir.chdir("~/Downloads")
  end

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
end
