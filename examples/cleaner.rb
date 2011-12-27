manage '~/Downloads' do
  # Move avi's and audio files to right places
  #
  # move :avi, :to => '~/Movies/inbox'
  # move %w(mp3 ogg), :to => '~/Music/inbox'
  
  # You've probably installed it already
  #
  # delete :dmg, :after => 10.hours
  
  # Delete everything older than 1 month.
  # Was here for so long? Doesn't deserve to exist!
  #
  # delete :after => 1.month
end
