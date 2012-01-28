module Cleaner
  class Runner
    attr_reader :rules, :directories

    def initialize(rules)
      @rules = rules
      @directories = []
    end

    def start
      instance_eval(rules)
      directories.each(&:clean)
    end

    protected

    def manage(path, &block)
      @directories << Directory.new(path, block)
    end
  end
end
