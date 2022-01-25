defmodule Servy.Handler do
  import Servy.Plugins
  import Servy.Parser
  import Servy.FileHandler
  import Servy.BearController
  alias Servy.Conv

  @pages_path Path.expand("../../pages", __DIR__)

  def handle_request(request) do
    request
    |> parse
    |> rewrite_path()
    |> route
    |> log()
    |> track()
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Smokey, Pooh, Paddington"}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears" <> _id} = conv) do
    delete(conv, conv.params)
    # %{conv | status: 403, resp_body: "Bears must never be deleted"}
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    create(conv, conv.params)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} found!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request1 = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request2 = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request3 = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request4 = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request5 = """
GET /dogs HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request6 = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request7 = """
GET /bears?id=2 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request8 = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request9 = """
GET /pages/about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request10 = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

IO.puts(Servy.Handler.handle_request(request1))
IO.puts(Servy.Handler.handle_request(request2))
IO.puts(Servy.Handler.handle_request(request3))
IO.puts(Servy.Handler.handle_request(request4))
IO.puts(Servy.Handler.handle_request(request5))
IO.puts(Servy.Handler.handle_request(request6))
IO.puts(Servy.Handler.handle_request(request7))
IO.puts(Servy.Handler.handle_request(request8))
IO.puts(Servy.Handler.handle_request(request9))
IO.puts(Servy.Handler.handle_request(request10))
