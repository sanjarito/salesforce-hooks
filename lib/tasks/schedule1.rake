task :do_work => :environment do
  require 'open-uri'
  file = open('http://hiscore.runescape.com/index_lite.ws?player=zezima')
  
  puts contents



end
