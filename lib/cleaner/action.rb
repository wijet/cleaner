module Cleaner
  class Action
    attr_reader :files, :options
    
    def initialize(files, options = {})
      @files = files
      @options = options
    end
    
    def execute
      raise NotImplementedException.new("#execute should be implemented in your Action class")
    end
    
    class UnknownActionException < Exception; end
    class NotImplementedException < Exception; end
  end
end
