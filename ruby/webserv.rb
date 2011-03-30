require 'socket'
webserver =   TCPServer.new('127.0.0.1', 7000)
while (session =   webserver.accept)
     session.print "<H1>Hello   World</H1>"
     session.close
end
