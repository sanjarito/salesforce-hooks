namespace :myrailsapp do
  task start: :environment do
    puts "start heroku app"
    WelcomeController.start
  end
end
