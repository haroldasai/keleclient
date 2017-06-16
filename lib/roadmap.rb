module Roadmap
  def get_roadmap(roadmap_id)
    authenticate
    unless @auth_token.nil?
      puts 'Retrieving roadmap information'
      response = self.class.get("/roadmaps/#{roadmap_id}", headers: { "authorization" => @auth_token }, body: {})
      roadmaps_array = JSON.parse(response.body)
    else
      puts 'Unable to retrieve roadmap information'
    end 
  end

  def get_checkpoint(checkpoint_id)
    authenticate
    unless @auth_token.nil?
      puts 'Retrieving checkpoint information'
      response = self.class.get("/checkpoints/#{checkpoint_id}", headers: { "authorization" => @auth_token })
      checkpoint_array = JSON.parse(response.body)
    else
      puts 'Unable to retrieve roadmap information'
    end 
  end
end