require 'drb/drb'

SERVER_URI="druby://localhost:8888"
  # The URI to connect to
x = 1
1.upto(500) do
  # Start a local DRbServer to handle callbacks.
  #
  # Not necessary for this small example, but will be required
  # as soon as we pass a non-marshallable object as an argument
  # to a dRuby call.
  DRb.start_service

  token = DRbObject.new_with_uri(SERVER_URI)
  token2 = DRbObject.new_with_uri(SERVER_URI)
  puts "#{x}. #{token.get_token} #{token2.get_token}"
  x = 1+x
  sleep 1 
end
