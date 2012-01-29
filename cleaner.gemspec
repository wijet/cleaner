# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cleaner/version"

Gem::Specification.new do |s|
  s.name        = "cleaner"
  s.version     = Cleaner::VERSION
  s.authors     = ["Mariusz Pietrzyk"]
  s.email       = ["wijet@wijet.pl"]
  s.homepage    = "http://github.com/wijet/cleaner"
  s.summary     = %q{Tool for cleaning up your directories with friendly DSL}
  s.description = <<desc
  Cleaner is a small tool which helps you keep your directories clean.
  With simple DSL you define set of rules, which are then periodically executed against specified directory.
desc

  s.rubyforge_project = "cleaner"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activesupport", "2.3.14"
  s.add_dependency "filelist"
  s.add_dependency "thor"
  s.add_dependency "daemons"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "timecop"
  if RUBY_PLATFORM =~ /darwin/
    s.add_development_dependency "rb-fsevent"
    s.add_development_dependency "ruby_gntp"
  end
end
