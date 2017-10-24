task :do_work => :environment do
  puts "START"

  start_hour = 7
  start_minute = 0

  until 2 < 1 do
    now = Time.now
    hour = now.hour
    minute = now.min
    if hour == start_hour && minute == start_minute

      puts " do work #{Time.now}"
 
      # execute code here !!!

      if Time.now.hour == start_hour && Time.now.min == start_minute
        sleep(60)
      end
    end
  end
end
