require 'httparty'

class Kele
  include HTTParty	
  base_uri 'https://www.bloc.io/api/v1'
  def initialize(email, password)
  	@email = email
  	@password = password
  end
  
  def authenticate
  	options = { 
  	  body: {
  		email: @email,
  		password: @password
      }
    }
  	response = self.class.post('/sessions', options)
  	@auth_token = response["auth_token"]
  	unless @auth_token.nil?
  	  'Authentication succeeded'
  	else
  	  response["message"]
  	end  
  end	
end  	