guard 'rspec', :version => 2, :cli => '--color --format documentation' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/cleaner/(.+)\.rb$})  { |m| "spec/cleaner/#{m[1]}_spec.rb" }
  watch(%r{^lib/cleaner/actions/(.+)\.rb$}) { |m| "spec/cleaner/actions/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{spec/helpers/.*\.rb})  { "spec" }
  watch('lib/cleaner.rb') { "rspec" }
end
