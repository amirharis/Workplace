require 'drb/drb'
require 'drb/acl'

URI="druby://localhost:8888"

class GenerateToken
  #@@count = 1
  def initialize(domain = "google.com")
    @mutex = Mutex.new
    @domain = domain
  end
  
  def get_token
    @mutex.synchronize {
      alphanumerics = [('0'..'9'),('A'..'Z'),('a'..'z')].map {|range| range.to_a}.flatten
      random = (0...7).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
      #search and compare hash from hash table generate hash base on domain :)
      puts "Token generated: #{random}"
      return random
    }
    #@@count = @@count + 1
  end
end

FRONT_OBJECT = GenerateToken.new

$SAFE = 1

#deny all 
#acl = ACL.new %w{
#  allow 192.168.1.50
#  allow 127.0.0.1
#}

#DRb.install_acl(acl)

DRb.start_service(URI, FRONT_OBJECT)
#trap("INT") { DRb.stop_service }
DRb.thread.join