require 'net/http'  
  def fetch_url(url)
    r = Net::HTTP.get_response( URI.parse( url ) )
    if r.is_a? Net::HTTPSuccess
      r.body
    else
      nil
    end
  end

  # use like this from your controller
  @snippet = fetch_url "http://www.localhost.my/"

  puts @snippet
