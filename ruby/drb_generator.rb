require 'drb/drb'
require 'drb/acl'
require 'logger'
require 'digest/sha1'
require 'active_record'

URI="druby://localhost:8888"

module DB
   ActiveRecord::Base.establish_connection(
         :adapter => "mysql2",
         :database  => "dnscellnew_development",
         :reconnect => false,
         :encoding => "utf8",
         :username => "root",
         :password => "me6699k2"
    )
  
   class User < ActiveRecord::Base
      has_many :zones
      has_many :labels
      has_many :hosts
   end
  
   class Zone < ActiveRecord::Base
      #has_many :records, :dependent => :destroy
      #belongs_to :view
      belongs_to :user
      belongs_to :label
      #has_many :records
      has_many :hosts
      has_many :records
      has_one :tmp_zone
   end
end


class GenerateToken
  include DB
  #@@count = 1
  def initialize(domain = "google.com")
    @mutex = Mutex.new
    @domain = domain
    @logger = Logger.new("token.log", 10, 1024000)
  end
  
  def get_token
    @mutex.synchronize {
      alphanumerics = [('0'..'9'),('A'..'Z'),('a'..'z')].map {|range| range.to_a}.flatten
      random = (0...6).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
      #search and compare hash from hash table generate hash base on domain :)
      #puts "Token generated: #{random}"
      #Also warn if duplicate key found :)
      #Generate token must be immediately stored in DB token info with hashes
      sha1 = Digest::SHA1.hexdigest(random)
      @logger.info "Token generated: #{random}, SHA1: #{sha1}"
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