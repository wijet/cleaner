module Cleaner
  class FileFilter
    attr_reader :options

    def initialize(options = {})
      @options = options
      @pattern = options[:pattern]
    end

    def filterize
      files = filter_by_name
      filter_by_options(files)
    end

    def search_pattern
      case @pattern
        when NilClass; "#{path}/*"
        when String; "#{path}/#{@pattern}"
        when Symbol; "#{path}/*.#{@pattern}"
        when Array; @pattern.map { |ext| "#{path}/*.#{ext}" }
      end
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

    def path
      File.expand_path(options[:path])
    end

    def filter_by_name
      FileList[search_pattern]
    end
  end
end
