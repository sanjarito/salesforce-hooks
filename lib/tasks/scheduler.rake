require 'uri'
require 'net/http'
require 'rubygems'
require 'json'
require 'time'

desc 'Update sales force database every so often'
task :sf_update do
  start
end

desc 'Update freshdesk tickets in status provisional storefront and send email'
task :fd_update do
  freshdeskupdate
end


  def start


      $i = 0
      uri = URI("https://corporate.pixfizz.com/users.json?page=3")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth("santiago_casar@pixfizz.com", "Habitat28")
      response = http.request(request)
            unless response.nil?
              varusers = response.read_body
              $pixfizzusers = JSON.parse(varusers)
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

                  url = URI("https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9WtWSKUDG.x4G.GRPQb1Yzl8EUkBFVCy5xEnh9dmrv96y8MsYxl6Cz0ZHtJvD9hUBCLTUcPM57_GUfGj.&client_secret=4087144410510429660&username=stephen_thorpe%40sjtsystems.com&password=Aprilla1089ZYrFbpnkflrxciWQIV8dWS5M")

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

                      # unless $pixsalesstage == "Storefront_Registration"
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


                        # end

                    # ///////  Patch API Call /////////////
                    # unless $pixsalesstage == "Email_Registration"
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
                        request.body = "{\n\"Company\" : \"#{$pixusercompany}\" ,\n\"Email\":\"#{$pixfizzusers[$i]["email"]}\", \n\"user_id__c\":\"#{$pixfizzusers[$i]["id"]}\", \n\"country\":\"#{$pixcountry}\", \n\"phone\":\"#{$pixphone}\", \n\"industry\":\"#{$pixsindustry}\", \n\"sales_stage__c\":\"#{$pixsalesstage}\" ,\n\"status\" : \"Trial Storefront\", \n\"LastName\" : \"#{$pixfizzusers[$i]["last_name"]}\",\n\"FirstName\" : \"#{$pixfizzusers[$i]["first_name"]}\"\n}"

                        response = http.request(request)


                      end
                    # end

                      end

                    # /////// END PATCH /////////////

                  end
                    end

                $i +=1
              end

            end
    end

    def freshdeskupdate

      # //////////// API Call to get all the tickets   ///////////////////////////////////////
      url = URI("https://pixfizz.freshdesk.com/api/v2/tickets")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["authorization"] = 'Basic c2FudGlhZ29fY2FzYXJAcGl4Zml6ei5jb206RGV0ZWNoMjgwNCEh'
      request["cache-control"] = 'no-cache'
      request["postman-token"] = 'e71ae918-a171-ff8f-900f-67b4c0ceba18'

      response = http.request(request)
      # puts response.read_body
      tickets = response.read_body
      $fdtickets = JSON.parse(tickets)


      # //////////// END API Call to get all the tickets   //////////////////////////////////////




    # //////////// Oauth token request to SALESFORCE    ///////////////////////////////////////

    url = URI("https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9WtWSKUDG.x4G.GRPQb1Yzl8EUkBFVCy5xEnh9dmrv96y8MsYxl6Cz0ZHtJvD9hUBCLTUcPM57_GUfGj.&client_secret=4087144410510429660&username=stephen_thorpe%40sjtsystems.com&password=Aprilla1089ZYrFbpnkflrxciWQIV8dWS5M")

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




      # ///////////// Get SalesForce Leads ///////////////

url = URI("https://pixfizz.my.salesforce.com/services/data/v20.0/sobjects/Lead/")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["authorization"] = bearertoken
request["content-type"] = 'application/json'
request["cache-control"] = 'no-cache'



response = http.request(request)
sfleadslist = response.read_body
$salesforceleads = JSON.parse(sfleadslist)
$pixsalesforceuser = $salesforceleads["recentItems"]
$n = 0

# puts $pixsalesforceuser.length

while $n <= 10
$pixsalesforceuserid = $salesforceleads["recentItems"][$n]["Id"]
      # ////////   End Get API call SalesForce Leads /////
$i = 0
puts $n
# ////  Get email for every single user id //
url = URI("https://pixfizz.my.salesforce.com/services/data/v20.0/sobjects/Lead/"+ $pixsalesforceuserid)

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["authorization"] = bearertoken
request["content-type"] = 'application/json'
request["cache-control"] = 'no-cache'
response = http.request(request)
sfuseremail = response.read_body
$salesforceleadlist = JSON.parse(sfuseremail)
$salesforceleademail = $salesforceleadlist["Email"]
puts $salesforceleademail




while $i <= 10

if $fdtickets[$i]["type"] == "Instant Signup" && $fdtickets[$i]["custom_fields"]["username"] == $salesforceleademail && $fdtickets[$i]["status"] == 9
  puts "Rejected"

  # ///////  Patch API Call /////////////
  # unless $pixsalesstage == "Email_Registration"
      url = URI("https://pixfizz.my.salesforce.com/services/data/v20.0/sobjects/Lead/" + $pixsalesforceuserid)

      puts "patch api call"

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Patch.new(url)
      request["authorization"] = bearertoken
      request["content-type"] = 'application/json'
      request["cache-control"] = 'no-cache'
      request["postman-token"] = '426cf69c-75a9-c12e-1ff5-2b25da0f98fd'
      # request.body = "{\n\"sales_stage\" : \"14daytrial\",\n\"subdomain\" : \"#{$fdtickets[$i]["custom_fields"]["subdomain"]}\"\n}"
      # request.body = "{\n\"sales_stage\" : \"14daytrial\"\n}"
      request.body = "{\n\"status\" : \"unqualified\"\n}"

      response = http.request(request)


  # end

elsif $fdtickets[$i]["type"] == "Instant Signup" && $fdtickets[$i]["custom_fields"]["username"] == $salesforceleademail && $fdtickets[$i]["status"] == 5
  puts "success"

  # ///////  Patch API Call /////////////
  # unless $pixsalesstage == "Email_Registration"
      url = URI("https://pixfizz.my.salesforce.com/services/data/v20.0/sobjects/Lead/" + $pixsalesforceuserid)

      puts "patch api call"

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Patch.new(url)
      request["authorization"] = bearertoken
      request["content-type"] = 'application/json'
      request["cache-control"] = 'no-cache'
      request["postman-token"] = '426cf69c-75a9-c12e-1ff5-2b25da0f98fd'
      # request.body = "{\n\"sales_stage\" : \"14daytrial\",\n\"subdomain\" : \"#{$fdtickets[$i]["custom_fields"]["subdomain"]}\"\n}"
      # request.body = "{\n\"sales_stage\" : \"14daytrial\"\n}"
      request.body = "{\n\"sales_stage__c\":\"14daytrial\" , \n\"pwd__c\":\"#{$fdtickets[$i]["custom_fields"]["password"]}\" , \n\"subdomain__c\" : \"#{$fdtickets[$i]["custom_fields"]["subdomain"]}\"\n}"

      response = http.request(request)


  # end

else
  puts "failure"
end
  # puts $tickettype
  # puts $fdtickets[$i]["type"]
# if $fdtickets[$i]["type"] == nil
#   puts "nil"
# else
#   $fdtickets[$i]["type"]
# end
#   return
# elsif $fdtickets[$i]["custom_fields"]["username"] == nil
#   return
# elsif $fdtickets[$i]["type"] == "Instant Signup"
#   puts $fdtickets[$i]["custom_fields"]["username"]

# end
$i += 1
end

$n += 1
    end #END of while loop $n ///
# while $i <= $fdtickets.length

# --------------------------------------- CONDITIONALS ----------------------------------------------------------------

# unless $fdtickets[$i]["type"] == "Instant Signup".nil?
#   # if $fdtickets[$i]["type"] == "Instant Signup"
#   #  && $salesforceleademail == $fdtickets[$i]["custom_fields"]["username"]
#
#
# else
# "no match"
# #
# end # if conditional end


# --------------------------------------- CONDITIONALS ----------------------------------------------------------------


# end  # while conditional end


      # //////////// END token request to SALESFORCE    ///////////////////////////////////////



  end #END of unless statement ///

end
