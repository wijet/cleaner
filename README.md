# Cleaner [![Build Status](https://secure.travis-ci.org/wijet/cleaner.png)](http://travis-ci.org/wijet/cleaner)
---

Tool for automatic management of directories on your disk with simple DSL.

## Installation

    $ gem install cleaner

## Example configuration file

```ruby
manage '~/Downloads' do
  # Move avi's and audio files to right places
  move :avi, :to => '~/Movies/inbox'
  move %w(mp3 ogg), :to => '~/Music/inbox'

  # Remove zip files if file without zip extension exists (uncompressed files)
  delete :zip, :if => proc { |file| File.exists?(file.path_without_ext) }

  # Move all VAT invoices to a special place
  move :pdf, :if => proc { |file| file.name =~ /VAT/ }, :to => '~/Documents/invoices'

  # You've probably installed it already
  delete :dmg, :after => 10.hours

  # Delete everything older than 1 month.
  # Was here for so long? Doesn't deserve to exist!
  delete :after => 1.month
end
```

## Usage

Generate sample configuration file (~/.cleaner.rb)

    $ cleaner init

Run cleaner in the background. By default it will run every 1 hour.

	$ cleaner start

You can specify cleaning interval with "rails like" syntax: 20.minutes, 4.hours, 1.day

	$ cleaner start 4.hours

Stop cleaner daemon

	$ cleaner stop


## Available actions

  - Deleting files
    ```
    delete :zip
    ```
  - Moving files
    ```
    move :pdf, :to => '~/Documents/pdfs'
    ```
  - Copying files
    ```
    copy :mp3, :to => '~/Documents/audio'
    ```


## Writing own actions

New actions can be added easily. All you need to do is implement #execute method.
Useful methods when implementing own actions

  - #files - array of filtered file paths
  - #options - hash of options passed to action

```ruby
# Sample action which sets color label on files in OS X
module Cleaner
  module Actions
    class Label < Action
      COLORS = {
      	:red 	=> 2,
      	:yellow => 3,
      	:green  => 6
      }
      def execute
      	code = COLORS[options[:color]]
        files.each do |path|  
          script = %Q{
            tell application \\"Finder\\" to set label index of file (POSIX file \\"#{path}\\") to #{code}
          }
          `osascript -e "#{script}"`
        end
      end
    end
  end
end
```

### Using custom action
Require action file, and use it as any other action, you can pass any condition to it.

```ruby
require 'label.rb'
manage '/add-more-colors-to-your-files' do
  # all avi files are labeled with green color
  label :avi, :color => :green
  # all files bigger than 100 megabytes are labeled with red color
  label :color => :red, :if => proc { |file| file.size > 100.megabytes }
end
```

## Contributions

To fetch & test the library for development, do:

    $ git clone https://github.com/wijet/cleaner
    $ cd cleaner
    $ bundle
    $ bundle exec rspec

If you wont to contribute, please:

  * Fork the project.
  * Make your feature addition or bug fix.
  * Add tests for it. This is important so I don't break it in a future version unintentionally.
  * Send me a pull request on Github.
