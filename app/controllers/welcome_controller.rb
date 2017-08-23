class WelcomeController < ApplicationController

  require 'uri'
  require 'net/http'

  url = URI("https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9WtWSKUDG.x4G.GRPQb1Yzl8EUkBFVCy5xEnh9dmrv96y8MsYxl6Cz0ZHtJvD9hUBCLTUcPM57_GUfGj.&client_secret=4087144410510429660&username=stephen_thorpe%40sjtsystems.com&password=M3l1ss%4008znx54cGVrKrzkVnyyhkLlGlz")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)
  request["content-type"] = 'application/x-www-form-urlencoded'
  request["cache-control"] = 'no-cache'
  request["postman-token"] = '082eec75-3838-06ca-49f5-cf417eb67532'

  response = http.request(request)
  puts response.read_body
  # USERNAME = "santiago@nowhereprod.com" # needed to access the APi
  #   PASSWORD = "Habitat28" # needed to access the APi
  #   API_BASE_URL = "https://corporate.pixfizz.com/v1/admin/users" # base url of the API

    # user_api = RestClient::Resource.new('https://instantsignup.pixfizz.com', :user => USERNAME , :password => PASSWORD)
    #      result = user_api["/v1/users/15961469.json"].put({:user =>{"first_name":"Floyd"}})

end
