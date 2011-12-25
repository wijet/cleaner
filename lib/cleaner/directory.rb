module Cleaner
  class Directory
    attr_reader :path, :block
    
    def initialize(path, block)
      @path = path
      @block = block
    end
    
    def clean
      instance_eval(&block)
    end

    protected

    def method_missing(method, *args, &block)
      action_class = construct_action_class(method)
      options = {:pattern => args.first, :path => path}
      filter = FileFilter.new(options)
      action = action_class.new(filter.filterize, options)
      action.execute
    end

    def construct_action_class(method)
      Cleaner::Actions::const_get(method.to_s.capitalize)
    rescue NameError => e
      raise Action::UnknownActionException.new("Action '#{method}' is unknown")
    end
  end
end
