#!/usr/bin/ruby
=begin
Author: Amir Haris Ahmad
Email : amir@domainregistry.my
=end

require 'xmlrpc/client'

abort "Invalid arguement(s), available: create | dsset | keyset" if ARGV.size != 2 

option = ARGV[0]
domain = ARGV[1]
server = XMLRPC::Client.new("127.0.0.1", "/mytraining", 9090)
re = server.call("mytraining", option, domain) 
puts re["status"]
