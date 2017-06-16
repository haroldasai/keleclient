require 'httparty'
require 'json'

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
  	  puts 'Authentication succeeded'
  	else
  	  puts response["message"]
  	end  
  end

  def get_me
  	authenticate
  	unless @auth_token.nil?
  	  puts 'Retrieving user information'
  	  response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
      JSON.parse(response.body)
  	else
  	  puts 'Unable to retrieve user information'
  	end
  end
  
  def get_mentor_availability(mentor_id)
    authenticate
  	unless @auth_token.nil?
  	  puts 'Retrieving user information'
  	  response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token }, body: {})
      schedule_array = JSON.parse(response.body)
      schedule_array.map! {
        |n| next if n["booked"] == true
        n
      }
  	else
  	  puts 'Unable to retrieve mentor schedule'
  	end  
  end	
end  	