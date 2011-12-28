require 'timecop'

module ExampleDirHelper
  def example_dir(name, &block)
    path = File.expand_path(name)
    FileUtils.mkdir_p(path)
    Dir.chdir(path) { block.call }
  end

  def touch(name, options = {})
    options[:mtime] ||= Time.now
    options[:atime] ||= Time.now
    options[:ctime] ||= Time.now
    Timecop.freeze(options[:ctime]) do
      FileUtils.touch(name)
    end
    File.utime(options[:atime], options[:mtime], name)
  end
end
