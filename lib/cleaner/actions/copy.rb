require 'fileutils'

module Cleaner
  module Actions
    class Copy < Action
      def execute
        dest = File.expand_path(options[:to])
        FileUtils.mkdir_p(dest)
        FileUtils.cp_r(files, dest)
      end
    end
  end
end
