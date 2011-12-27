# Cleaner #

Tool for automatic management of directories on your disk with simple DSL.

---


## Installation ##

    gem install cleaner


## Usage ##

Generate sample configuration file (~/.cleaner.rb)

    cleaner init
	
Run cleaner in the background. By default it will run every 1 hour.

	cleaner start
	
You can specify how cleaning interval with "rails like" syntax: 20.minutes, 4.hours, 1.day

	cleaner start 4.hours
	
Stop cleaner daemon

	cleaner stop
	
## Example configuration file ##

```ruby
manage '~/Downloads' do
  delete :zip, :after => 2.days

  delete :dmg, :after => 10.hours
  delete %w(dmg mpkg torrent), :after => 10.hours

  delete '*.download', :after => 5.hours

  # remove zip files if unzipped version exists
  delete :zip, :if => lambda { |file| exists?(file) }
	
  move :doc, :to => '~/Documents'

  # 
  # move :pdf, :to => 'pdfs' do
  #   colour :red
  #   keywords %(presentation pdf)
  # end
  # 
  # colour :pdf, :with => :red
  # 
  # copy :pdf, :to => 'somewhere' do |file|
  #   notify "#{file} has been copied!"
  # end
  # 
  # archive :pdf, :with => :zip, :to => 'pdfs'
end
```