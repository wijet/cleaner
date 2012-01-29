manage '~/Downloads' do
  # Move avi's and audio files to right places
  # move :avi, :to => '~/Movies/inbox'
  # move %w(mp3 ogg), :to => '~/Music/inbox'

  # Remove zip files if file without zip extension exists (uncompressed files)
  # delete :zip, :if => proc { |file| File.exists?(file.path_without_ext) }

  # Move all VAT invoices to a special place
  # move :pdf, :if => proc { |file| file.name =~ /VAT/ }, :to => '~/Documents/invoices'

  # You've probably installed it already
  # delete :dmg, :after => 10.hours

  # Delete everything older than 1 month.
  # Was here for so long? Doesn't deserve to exist!
  # delete :after => 1.month
end
