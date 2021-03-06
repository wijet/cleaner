module Cleaner
  class FileFilter
    CONDITIONS = [:after, :if, :smaller_than, :bigger_than]

    attr_reader :options

    def initialize(options = {})
      @options = options
      @pattern = options[:pattern]
    end

    def filterize
      paths = filter_by_name
      conditions_provided? ? filter_by_conditions(paths) : paths
    end

    def search_pattern
      case @pattern
        when NilClass; "#{path}/*"
        when String; "#{path}/#{@pattern}"
        when Symbol; "#{path}/*.#{@pattern}"
        when Array; @pattern.map { |ext| "#{path}/*.#{ext}" }
      end
    end

    protected

    def filter_by_conditions(paths)
      paths.select do |path|
        [
          after_condition?(path),
          if_condition?(path),
          smaller_than_condition?(path),
          bigger_than_condition?(path)
        ].all?
      end
    end

    def conditions_provided?
      options.keys.any? { |c| CONDITIONS.include?(c) }
    end

    def after_condition?(path)
      return true unless options.has_key?(:after)
      File.ctime(path) < options[:after].ago
    end

    def if_condition?(path)
      return true unless options.has_key?(:if)
      file = File.new(path)
      file.extend(FileExtension)
      options[:if].call(file)
    end

    def smaller_than_condition?(path)
      return true unless options.has_key?(:smaller_than)
      File.size(path) < options[:smaller_than]
    end

    def bigger_than_condition?(path)
      return true unless options.has_key?(:bigger_than)
      File.size(path) > options[:bigger_than]
    end

    def path
      File.expand_path(options[:path])
    end

    def filter_by_name
      FileList[search_pattern]
    end
  end
end
