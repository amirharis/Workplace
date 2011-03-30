class LaunchpadController < ApplicationController
  def jump
   
     shortcode = params[:my_id]
     
     if request.subdomain.empty?
       host_data = request.domain 
     else
       host_data = "#{request.subdomain }.#{request.domain}"
     end
     
     s = Shorturl.where(:host_data => host_data, :shortcode => shortcode).first
     
     if s.nil?
       redirect_to root_path
     else
       redirect_to s.destination
     end
     
     
     #redirect_to root_url
  end
  
  def jump2
    #redirect_to "http://www.google.com"
  end
end
