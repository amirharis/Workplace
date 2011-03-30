#!/usr/bin/ruby
require 'webrick'
require 'xmlrpc/server.rb'
require "rexml/document"
require "yaml"
#require "/usr/local/bind/engine/rpc/dnssec.rb"
include REXML

# create a servlet to handle XML-RPC requests:
servlet = XMLRPC::WEBrickServlet.new
servlet.add_handler("dig") do |a_string| %x{dig @localhost #{a_string} any} end
servlet.add_handler("dnssec.connect") do |username, password, string|
  config_file = '/usr/local/bind/engine/nsupdate.yml'
  @config = YAML.load_file config_file
  xml_username = @config['xml_username']
  xml_password = @config['xml_password']
  doc = Document.new(string) # do something with doc
  if ["#{xml_username}","#{xml_password}"].eql?(["#{username}","#{password}"])
    host = XPath.match( doc, '//host' ).map{|x| x.text}
    resource_record = XPath.match( doc, '//resource_record' ).map{|x| x.text}
    data = XPath.match( doc, '//data' ).map{|x| x.text}
    flag = XPath.match( doc, '//flag' ).map{|x| x.text}
    flag.each_index do |i| 
       nsupdate = %x{/usr/local/bind/engine/nsupdate.rb #{flag[i]} #{host[i]} #{resource_record[i]} #{data[i]}}
       DNSSEC::Log.new.write("#{Time.new.strftime("%d/%m/%Y %H:%M:%S")}: #{username} /usr/local/bind/engine/nsupdate.rb #{flag[i]} #{host[i]} #{resource_record[i]} #{data[i]}")
       if i == 0
         $msg = "#{Time.new.strftime("%d/%m/%Y %H:%M:%S")}: Successfully #{flag[i]} #{host[i]} #{resource_record[i]} #{data[i]}\n"
       else
         $msg << "#{Time.new.strftime("%d/%m/%Y %H:%M:%S")}: Successfully #{flag[i]} #{host[i]} #{resource_record[i]} #{data[i]}\n"
       end
    end
  elsif
    DNSSEC::Log.new.write("#{Time.new.strftime("%d/%m/%Y %H:%M:%S")}: Wrong Credentials with username #{username} and password #{password}")
    $msg = "Wrong credentials!"
  end
  { "status" => $msg }
end 

# create a WEBrick instance to host this servlet:
server=WEBrick::HTTPServer.new(:Port => 9090)
#server.add_introspection
trap("INT"){ server.shutdown }
server.mount("/signer", servlet)
server.start
