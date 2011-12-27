module Cleaner
  module Actions
    class Move < Action
      def execute
        dest = File.expand_path(options[:to])
        FileUtils.mkdir_p(dest)
        files.each { |src| FileUtils.mv(src, dest) }
      end
    end
  end
end
