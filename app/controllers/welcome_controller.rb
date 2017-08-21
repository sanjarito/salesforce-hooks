class WelcomeController < ApplicationController

  require 'rest_client'
  require 'json'
  require 'open-uri'

    # def index
      USERNAME = "santiago@nowhereprod.com" # needed to access the APi
        PASSWORD = "Habitat28" # needed to access the APi
        API_BASE_URL = "https://corporate.pixfizz.com/v1/admin/users" # base url of the API

    uri = "#{API_BASE_URL}#.json"

        # user_api = RestClient::Resource.new('https://instantsignup.pixfizz.com', :user => USERNAME , :password => PASSWORD)

        # RestClient::Request.execute method: :get, url: uri, user: USERNAME, password: PASSWORD
        # rest_resource = RestClient::Resource.new(uri, USERNAME, PASSWORD)
        # users = rest_resource.get

    # end

end
