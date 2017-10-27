class WelcomeController < ApplicationController

  require 'uri'
  require 'net/http'
  require 'rubygems'
  require 'json'
  require 'time'




def start
#   def notcallPix
#     puts "notcallPix"
#   end
#
#   def callPix
#   # puts @@logdatetruncated
#   puts "notequal"
#   end

    $i = 1
    uri = URI("https://corporate.pixfizz.com/users.json?page=2")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth("santiago_casar@pixfizz.com", "Habitat28")
    response = http.request(request)
          unless response.nil?
            varusers = response.read_body
            $pixfizzusers = JSON.parse(varusers)




            # @pixfizzuser_marketingstage = pixfizzusers[$i]["custom"];


            # puts @pixfizzuser_marketingstage

            puts $pixfizzusers
            puts $pixfizzusers.length

            while $i <= $pixfizzusers.length

              # ///////// GET API CALL TO GET PX:USER:CUSTOMFIELD:SALES_MARKETING //////////


                      uri = URI("https://corporate.pixfizz.com/v1/users/#{$pixfizzusers[$i]["id"]}.json")
                      http = Net::HTTP.new(uri.host, uri.port)
                      http.use_ssl = true
                      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                      request = Net::HTTP::Get.new(uri.request_uri)
                      request.basic_auth("santiago_casar@pixfizz.com", "Habitat28")
                      response = http.request(request)
                            unless response.nil?
                              varuser = response.read_body
                              $pixfizzuser = JSON.parse(varuser)
                              $pixsalesstage = $pixfizzuser["custom"]["sales_stage"]
                              $pixsindustry = $pixfizzuser["custom"]["industry"]
                              $pixphone = $pixfizzuser["custom"]["phone"]
                              $pixcountry = $pixfizzuser["custom"]["country"]
                              $pixusercompany = $pixfizzuser["custom"]["company"]



                # //////////// END GET API CALL    ///////////////////////////////////////


                # //////////// Oauth token request to SALESFORCE    ///////////////////////////////////////

                url = URI("https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9WtWSKUDG.x4G.GRPQb1Yzl8EUkBFVCy5xEnh9dmrv96y8MsYxl6Cz0ZHtJvD9hUBCLTUcPM57_GUfGj.&client_secret=4087144410510429660&username=stephen_thorpe%40sjtsystems.com&password=M3l1ss%4008znx54cGVrKrzkVnyyhkLlGlz")

                http = Net::HTTP.new(url.host, url.port)
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                request = Net::HTTP::Post.new(url)
                request["content-type"] = 'application/x-www-form-urlencoded'
                request["cache-control"] = 'no-cache'
                request["postman-token"] = '082eec75-3838-06ca-49f5-cf417eb67532'

                response = http.request(request)
                  unless response.nil?
                  var1 = response.read_body
                  obj = JSON.parse(var1)
                  token = obj['access_token']
                  puts bearertoken = "Bearer " + token

                  # //////////// END token request to SALESFORCE    ///////////////////////////////////////



                  # ///////  Post API Call /////////////

                    url = URI("https://pixfizz.my.salesforce.com/services/data/v20.0/sobjects/Lead")

                    http = Net::HTTP.new(url.host, url.port)
                    http.use_ssl = true
                    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                    request = Net::HTTP::Post.new(url)
                    request["authorization"] = bearertoken
                    request["content-type"] = 'application/json'
                    request["cache-control"] = 'no-cache'


                    request.body = "{\n\"Company\" : \"TBD\",\n\"Email\":\"#{$pixfizzusers[$i]["email"]}\",\n\"user_id__c\":\"#{$pixfizzusers[$i]["id"]}\",\n\"sales_stage__c\":\"#{$pixsalesstage}\" ,\n\"LastName\" : \"TBD\",\n\"FirstName\" : \"TBD\" \n}"
                    response.body
                    response = http.request(request)
                    duplicationerror = response.read_body

                      # ///////  END POST /////////////

                    var2 = JSON.parse(duplicationerror)
                    conditional_length = var2.length

                    puts "post api call"

                    if conditional_length < 2
                      # puts conditional_length
                      id_exists = var2[0]['message']
                      sfuser_id = id_exists[70..-1]




                  # ///////  Patch API Call /////////////
                      if (sfuser_id != nil && sfuser_id != 0)
                      url = URI("https://pixfizz.my.salesforce.com/services/data/v20.0/sobjects/Lead/#{sfuser_id}")

                      puts "patch api call"

                      http = Net::HTTP.new(url.host, url.port)
                      http.use_ssl = true
                      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                      request = Net::HTTP::Patch.new(url)
                      request["authorization"] = bearertoken
                      request["content-type"] = 'application/json'
                      request["cache-control"] = 'no-cache'
                      request["postman-token"] = '426cf69c-75a9-c12e-1ff5-2b25da0f98fd'
                      request.body = "{\n\"Company\" : \"#{$pixusercompany}\" ,\n\"Email\":\"#{$pixfizzusers[$i]["email"]}\", \n\"user_id__c\":\"#{$pixfizzusers[$i]["id"]}\", \n\"country\":\"#{$pixcountry}\", \n\"phone\":\"#{$pixphone}\", \n\"industry\":\"#{$pixsindustry}\",  \n\"sales_stage__c\":\"#{$pixsalesstage}\" ,\n\"status\" : \"Trial Storefront\", \n\"LastName\" : \"#{$pixfizzusers[$i]["last_name"]}\",\n\"FirstName\" : \"#{$pixfizzusers[$i]["first_name"]}\"\n}"

                      response = http.request(request)


                    end

                    end

                  # /////// END PATCH /////////////


                end


                    # puts duplicationerror

                  end



              $i +=1
            end

            # pixuserslogindate = pixfizzusers['login_date']
            # @@logdatetruncated = pixuserslogindate[0..10]
            # puts logdatetruncated
            # time = Time.now.utc.iso8601
            # currentdatetruncated = time[0..10]
            # puts currentdatetruncated
                  # if @@logdatetruncated == currentdatetruncated
                  #   callPix
                  #   # puts "soniguales"
                  # else
                  #   notcallPix
                  #   # puts "nosoniguales"
                  #
                  # end

          end
  end



#   url = URI("https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9WtWSKUDG.x4G.GRPQb1Yzl8EUkBFVCy5xEnh9dmrv96y8MsYxl6Cz0ZHtJvD9hUBCLTUcPM57_GUfGj.&client_secret=4087144410510429660&username=stephen_thorpe%40sjtsystems.com&password=M3l1ss%4008znx54cGVrKrzkVnyyhkLlGlz")
#
#   http = Net::HTTP.new(url.host, url.port)
#   http.use_ssl = true
#   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#
#   request = Net::HTTP::Post.new(url)
#   request["content-type"] = 'application/x-www-form-urlencoded'
#   request["cache-control"] = 'no-cache'
#   request["postman-token"] = '082eec75-3838-06ca-49f5-cf417eb67532'
#
#   response = http.request(request)
#   unless response.nil?
#   var1 = response.read_body
#   obj = JSON.parse(var1)
#   token = obj['access_token']
#   puts bearertoken = "Bearer " + token
#
#   url = URI("https://pixfizz.my.salesforce.com/services/data/v20.0/sobjects/Lead")
#
# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true
# http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#
# request = Net::HTTP::Post.new(url)
# request["authorization"] = bearertoken
# request["content-type"] = 'application/json'
# request["cache-control"] = 'no-cache'
# request.body = "{\n\"Company\" : \"Express Logistics and Transport\",\n\"Email\":\"heroku@gmail.com\",\n\"LastName\" : \"heroku\",\n\"FirstName\" : \"Santiagoheroku\"\n}"
#
# response = http.request(request)
# puts response.read_body

  # end



end
