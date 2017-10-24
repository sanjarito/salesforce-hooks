task :do_work => :environment do
  require 'open-uri'
  file = open('https://obscure-beach-12891.herokuapp.com/')
  contents = file.read
  puts contents



end
