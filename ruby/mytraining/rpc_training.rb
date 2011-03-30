#!/usr/bin/ruby
require 'webrick'
require 'xmlrpc/server.rb'
require "rexml/document"
require "yaml"
require "dnssec"
include REXML

# create a servlet to handle XML-RPC requests:
servlet = XMLRPC::WEBrickServlet.new
servlet.add_handler("dig") do |a_string| %x{dig @localhost #{a_string} any} end
servlet.add_handler("create.zone") do |domain|
   #Check for the Domain Format
   #Prepare the template
   regex_dom = /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/

   if domain =~ regex_dom
     unless File.exists? "zones/#{domain}"
       require 'fileutils'
       FileUtils.cp_r('templates', "zones/#{domain}")
       Dir.chdir("/usr/local/bind/mytraining/zones/#{domain}")
       %x{dnssec-signer -o "#{domain}"}
       Dir.chdir("/usr/local/bind/mytraining")
       DNSSEC::Config.new.write("zone \"#{domain}\" {\n type master;\n file \"zones/#{domain}/zone.db.signed\";\n};")
       %x{rndc reload}
       %x{rndc flush}
       $msg = "Your zone has been created!"
     else
       $msg = "The zone is already exist"
     end
   else
     $msg = "Invalid domain name"
   end

{ "status" => $msg }
end

servlet.add_handler("mytraining") do |option, domain|
 #remoteip = request.env['REMOTE_ADDR']
if option == "create"
   regex_dom = /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/
   if domain =~ regex_dom
     unless File.exists? "zones/#{domain}"
       require 'fileutils'
       FileUtils.cp_r('templates', "zones/#{domain}")
       Dir.chdir("/usr/local/bind/mytraining/zones/#{domain}")
       %x{dnssec-signer -o "#{domain}"}
       Dir.chdir("/usr/local/bind/mytraining")
       DNSSEC::Config.new.write("zone \"#{domain}\" {\n type master;\n file \"zones/#{domain}/zone.db.signed\";\n};")
       %x{rndc reload}
       %x{rndc flush}
       $msg = "Your zone has been created!"
     else
       $msg = "The zone is already exist"
     end
   else
     $msg = "Invalid domain name"
   end
elsif option == "keyset" || option == "dsset"
   if File.exists? "zones/#{domain}"
      if option == "keyset"
        $msg = %x{cat zones/#{domain}/keyset*}
      else
        $msg = %x{cat zones/#{domain}/dsset*}.split("\n")[1]
      end
   else
      $msg = "Zone does not exist"
   end
else
    $msg ="Invalid option. Available options are: create | keyset | dsset"
end
{ "status" => $msg }
end

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
server.mount("/mytraining", servlet)
server.start
