module ExampleDirHelper
  def example_dir(name, &block)
    path = File.expand_path(name)
    FileUtils.mkdir_p(path)
    Dir.chdir(path) { block.call }
  end
  
  def touch(name, options = {})
    options[:at] ||= Time.now
    FileUtils.touch(name)
    File.utime(options[:at], options[:at], name)
  end
end
