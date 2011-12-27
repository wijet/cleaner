require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fakefs/spec_helpers'
require 'helpers/example_dir_helper'
require 'cleaner'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
  config.include ExampleDirHelper
end
