module Cleaner
  class FileFilter
    attr_reader :options, :pattern
    
    def initialize(options = {})
      @options = options
      @pattern = options[:pattern]
    end
        
    def filterize
      filter_by_name
    end

    def search_pattern
      pattern = case @pattern
        when String; @pattern
        when Symbol; "*.#{@pattern}"
      end
      File.join(expanded_path, pattern)
    end
    
    def expanded_path
      File.expand_path(options[:path])
    end

    def filter_by_name
      FileList[search_pattern]
    end
  end
end
