# Cleaner [![Build Status](https://secure.travis-ci.org/wijet/cleaner.png)](http://travis-ci.org/wijet/cleaner)
---

Tool for automatic management of directories on your disk with simple DSL. Inspired by [Hazel](http://www.noodlesoft.com/hazel.php) app.

## Installation

    $ gem install cleaner

## Example configuration file

```ruby
manage '~/Downloads' do
  # Move avi's and audio files to right places
  move :avi, :to => '~/Movies/inbox'
  move %w(mp3 ogg), :to => '~/Music/inbox'

  # label all files bigger than 100MB with red color (OS X only)
  label :color => :red, :bigger_than => 100.megabytes

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

    ```ruby
    delete :zip
    ```

  - Moving files

    ```ruby
    move :pdf, :to => '~/Documents/pdfs'
    ```

  - Copying files

    ```ruby
    copy :mp3, :to => '~/Documents/audio'
    ```

  - Labeling files with colors (OS X only). Available colors: :white, :orange, :red, :yellow, :blue, :purple, :green, :gray

    ```ruby
    label :txt, :color => :blue
    ```

## Available conditions

  Conditions are used for more accurate files matching.

  - :after - Matches files created given period time ago

    ```ruby
    :after => 2.days
    ```

  - :if - Matches file for which block returns true. File object is passed to the block.

    ```ruby
    :if => proc { |file| file.name =~ /foo/ }
    ```

  - :smaller_than - Matches files which are smaller than the given value

    ```ruby
    :smaller_than => 10.megabytes
    ```

  - :bigger_than - Matches files which are bigger than the given value

    ```ruby
    :bigger_than => 1.megabyte
    ```

## Third party actions

  * [Subtitles](https://gist.github.com/1859117) - Fetching polish subtitles for movies 

## Writing own actions

New actions can be added easily. All you need to do is implement #execute method.

Useful methods when implementing own actions:

  - #files - array of filtered file paths
  - #options - hash of options passed to action

```ruby
# Here as example is label action which sets color label on files on OS X
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
```

### Using custom action
Require action in your config file and use it as any other action.

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

If you want to contribute, please:

  * Fork the project.
  * Make your feature addition or bug fix.
  * Add tests for it. This is important so I don't break it in a future version unintentionally.
  * Send me a pull request on Github.
