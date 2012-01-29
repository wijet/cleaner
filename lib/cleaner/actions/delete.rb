module Cleaner
  module Actions
    class Delete < Action
      def execute
        FileUtils.rm_rf(files)
      end
    end
  end
end
