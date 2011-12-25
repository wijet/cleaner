module Cleaner
  module Actions
    class Delete < Action
      def execute
        FileUtils.rm(files)
      end
    end
  end
end
