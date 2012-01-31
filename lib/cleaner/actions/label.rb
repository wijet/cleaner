module Cleaner
  module Actions
    class Label < Action
      COLORS = {
        :white  => 0,
        :orange => 1,
        :red    => 2,
        :yellow => 3,
        :blue   => 4,
        :purple => 5,
        :green  => 6,
        :gray   => 7,
      }
      def execute
        code = COLORS[options[:color]]
        files.each do |path|
          script = %Q{tell application \\"Finder\\" to set label index of file (POSIX file \\"#{path}\\") to #{code}}
          `osascript -e "#{script}"`
        end
      end
    end
  end
end
