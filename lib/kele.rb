require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap
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

  def get_messages(page_num = nil)
    authenticate
    unless @auth_token.nil?
      puts 'Retrieving user information'
      if page_num.nil?
        response = self.class.get('/message_threads', headers: { "authorization" => @auth_token }, body: {})
      else 
        response = self.class.get('/message_threads', headers: { "authorization" => @auth_token }, body: { "page": page_num })
      end
      JSON.parse(response.body)    
    else
      puts 'Unable to retrieve user messages'
    end
  end

  def create_messages(sender, recipient_id, subject, message)
    authenticate
    unless @auth_token.nil?
      puts 'Creating a message'
      response = self.class.post('/messages', headers: { "authorization" => @auth_token }, body: { "sender": sender, "recipient_id": recipient_id, "subject": subject, "stripped-text": message })
      puts response.response
      response
    else
      puts 'Unable to create a message'
    end
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    authenticate
    unless @auth_token.nil?
      puts 'Creating a submission'
      response = self.class.post('/checkpoint_submissions', headers: { "authorization" => @auth_token }, body: { "assignment_branch": assignment_branch,
    "assignment_commit_link": assignment_commit_link,
    "checkpoint_id": checkpoint_id,
    "comment": comment,
    "enrollment_id": get_me["current_enrollment"]["id"],  })
      puts response.response
      response
    else
      puts 'Unable to create submission'
    end
  end

  def update_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, submission_id)
    authenticate
    unless @auth_token.nil?
      puts 'Updating submission'
      response = self.class.put("/checkpoint_submissions/#{submission_id}", headers: { "authorization" => @auth_token }, body: { "assignment_branch": assignment_branch,
    "assignment_commit_link": assignment_commit_link,
    "checkpoint_id": checkpoint_id,
    "comment": comment,
    "enrollment_id": get_me["current_enrollment"]["id"],  })
      puts response.response
      response
    else
      puts 'Unable to create submission'
    end
  end
end  	