require "thor"
require "daemons"

module Cleaner
  class CLI < Thor
    desc 'start', 'Start cleaner in background. It cleans directories every 1 hour'
    def start
      daemon_application.start
    end
    
    desc 'stop', 'Stop cleaner in background'
    def stop
      daemon_application.stop
    end
    
    desc 'cleanup', 'Run cleaner ad hoc'
    def cleanup
      run_cleaner
    end
    
    no_tasks do
      def daemon_application
        group = Daemons::ApplicationGroup.new('cleaner', daemon_options)
        group.new_application(daemon_options)
      end
      
      def daemon_options
       {
         :mode     => :proc,
         :proc     => runner_proc,
         :dir_mode => :normal, 
         :dir      => "/tmp"
       }
      end
      
      def runner_proc
        Proc.new do
          loop do
            run_cleaner
            sleep 1.minute
          end
        end
      end
      
      def run_cleaner
        cleaner = Cleaner::Runner.new(load_rules)
        cleaner.start
      end
      
      def load_rules
        File.read(config_file_path)
      rescue Errno::ENOENT
        say "Config file #{config_file_path} doesn't exist", :red
        # FIXME: Add command for generating sample config file
        # say "Generate sample file with `cleaner init`"
        exit 1
      end
      
      def config_file_path
        File.expand_path("~/.cleaner.rb")
      end
    end
  end
end
