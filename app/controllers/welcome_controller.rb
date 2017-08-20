class WelcomeController < ApplicationController

  require 'rest_client'
  require 'json'
  require 'open-uri'

  # USERNAME = "santiago@nowhereprod.com" # needed to access the APi
  #   PASSWORD = "Habitat28" # needed to access the APi
  #   API_BASE_URL = "https://corporate.pixfizz.com/v1/admin/users" # base url of the API

    # user_api = RestClient::Resource.new('https://instantsignup.pixfizz.com', :user => USERNAME , :password => PASSWORD)
    #      result = user_api["/v1/users/15961469.json"].put({:user =>{"first_name":"Floyd"}})

end
