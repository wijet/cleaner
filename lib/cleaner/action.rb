module Cleaner
  class Action
    attr_reader :files
    
    def initialize(files, options = {})
      @files = files
    end
    
    def execute
    end
    
    class UnknownActionException < Exception; end
  end
end
