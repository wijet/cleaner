module Cleaner
  class Action
    def initialize(files, options = {})
    end
    
    def execute
    end
    
    class UnknownActionException < Exception; end
  end
end
