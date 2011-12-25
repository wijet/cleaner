How DSL can look like

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
