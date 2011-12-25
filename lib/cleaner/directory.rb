module Cleaner
  class Directory
    attr_reader :path, :block
    
    def initialize(path, block)
      @path = path
      @block = block
    end
    
    def clean
      block.call
    end
  end
end
