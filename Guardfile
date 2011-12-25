guard 'rspec', :version => 2, :cli => '--color --format documentation' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/cleaner/(.+)\.rb$})     { |m| "spec/cleaner/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
