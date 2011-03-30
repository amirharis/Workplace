require 'socket'
require 'net/http'
require 'uri'
require 'simplehttp'

def fetch(uri_str, limit = 10)
   # You should choose better exception.
   raise ArgumentError, 'HTTP redirect too deep' if limit == 0

   response = Net::HTTP.get_response(URI.parse(uri_str))
   case response
   when Net::HTTPSuccess     then response
   when Net::HTTPRedirection then fetch(response['location'], limit - 1)
   else
      response.error!
   end
end

#    print fetch('http://www.ruby-lang.org')

webserver =   TCPServer.new('127.0.0.1', 7000)
while (session =   webserver.accept)
     #session.print fetch('http://www.ruby-lang.org')
     SimpleHttp.get "http://www.google.com"
     session.close
end
