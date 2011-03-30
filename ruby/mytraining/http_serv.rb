require 'webrick'

class Simple < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = do_stuff_with(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def redirect
    return 301, "http://www.google.com"
  end

  def do_stuff_with(request)
    return 200, "text/plain", "you got a page"
  end

end

class Configureable < Simple

  def initialize(server, color, size)
    super(server)
    @color = color
    @size = size
  end

  def do_stuff_with(request)
    content = "<p style=\"color: #{@color}; font-size: #{@size}\">some text #{request["HTTP_USER_AGENT"]}"
    return 200, "text/html", content
  end

end

if $0 == __FILE__ then
  server = WEBrick::HTTPServer.new(:Port => 8000, :BindAddress => "127.0.0.1")
  server.mount "/simple", Simple
  server.mount "/configurable", Configureable, "red", "2em"
  trap "INT" do server.shutdown end
  server.start
end

