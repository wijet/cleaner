module Cleaner
  class FileFilter
    attr_reader :options, :pattern

    def initialize(options = {})
      @options = options
      @pattern = options[:pattern]
    end

    def filterize
      files = filter_by_name
      filter_by_options(files)
    end

    def search_pattern
      pattern = case @pattern
        when String; @pattern
        when Symbol; "*.#{@pattern}"
      end
      File.join(expanded_path, pattern)
    end

    def filter_by_options(files)
      files.select do |file|
        if options.has_key?(:after)
          next if File.mtime(file) > options[:after].ago
        end

        true
      end
    end

    protected

    def expanded_path
      File.expand_path(options[:path])
    end

    def filter_by_name
      FileList[search_pattern]
    end
  end
end
