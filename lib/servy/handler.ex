defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  import Servy.FileHandler, only: :functions
  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, emojify: 1, track: 1]

  alias Servy.Conv

  @pages_path Path.expand("pages", File.cwd!())

  @doc """
  Transforms a request into a response.
  """
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> emojify()
    |> track()
    |> format_response()
  end

  @doc """
  Routes a request.
  """
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smoky, Paddington"}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{conv | status: 403, resp_body: "Deleting bear is forbidden"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No Path #{path} here!"}
  end

  @doc """
  Formats the response.
  """
  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

# Wildthings

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

# Bears

request_bears = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_bears = Servy.Handler.handle(request_bears)

IO.puts(response_bears)

# Bears 1

request_bears_1 = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_bears_1 = Servy.Handler.handle(request_bears_1)

IO.puts(response_bears_1)

# Bigfoot

request_bigfoot = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_bigfoot = Servy.Handler.handle(request_bigfoot)

IO.puts(response_bigfoot)

# Excercise DELETE METHOD

request_delete = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_delete = Servy.Handler.handle(request_delete)

IO.puts(response_delete)

# Wildlife

request_wildlife = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_wildlife = Servy.Handler.handle(request_wildlife)

IO.puts(response_wildlife)

# Bears with URL query

request_bears_with_query = """
GET /bears?id=100 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_bears_with_query = Servy.Handler.handle(request_bears_with_query)

IO.puts(response_bears_with_query)

# About Us

request_about = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_about = Servy.Handler.handle(request_about)

IO.puts(response_about)

# Bears New

request_bears_new = """
GET /pages/form HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_bears_new = Servy.Handler.handle(request_bears_new)

IO.puts(response_bears_new)

# Contact Us

request_contact = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_contact = Servy.Handler.handle(request_contact)

IO.puts(response_contact)

# FAQ

request_faq = """
GET /pages/faq HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_faq = Servy.Handler.handle(request_faq)

IO.puts(response_faq)
