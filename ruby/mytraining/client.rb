#!/usr/bin/ruby
=begin
Author: Amir Haris Ahmad
Email : amir@domainregistry.my
=end

require 'xmlrpc/client'
abort "Invalid arguements" if ARGV.size != 1
domain = ARGV[0]
server = XMLRPC::Client.new("127.0.0.1", "/mytraining", 9090)
re = server.call("create.zone", domain) 
puts re["status"]
