defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  import Servy.FileHandler, only: :functions
  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, emojify: 1, track: 1]

  alias Servy.BearController
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
    %Conv{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)

    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    params = %{"name" => "Bree", "type" => "Brown"}

    %Conv{
      conv
      | status: 201,
        resp_body: "Created a #{params["type"]} bear named #{params["name"]} bear!"
    }
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %Conv{conv | status: 403, resp_body: "Deleting bear is forbidden"}
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
    %Conv{conv | status: 404, resp_body: "No Path #{path} here!"}
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

wildthings_request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

wildthings_request |> Servy.Handler.handle() |> IO.puts()

# Bears

request_bears = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bears |> Servy.Handler.handle() |> IO.puts()

# Bears 1

request_bears_1 = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bears_1 |> Servy.Handler.handle() |> IO.puts()

# Bigfoot

request_bigfoot = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bigfoot |> Servy.Handler.handle() |> IO.puts()

# Excercise DELETE METHOD

request_delete = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_delete |> Servy.Handler.handle() |> IO.puts()

# Wildlife

request_wildlife = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_wildlife |> Servy.Handler.handle() |> IO.puts()

# Bears with URL query

request_bears_with_query = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bears_with_query |> Servy.Handler.handle() |> IO.puts()

# About Us

request_about = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_about |> Servy.Handler.handle() |> IO.puts()

# Bears New

request_bears_new = """
GET /pages/form HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bears_new |> Servy.Handler.handle() |> IO.puts()

# Contact Us

request_contact = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_contact |> Servy.Handler.handle() |> IO.puts()

# FAQ

request_faq = """
GET /pages/faq HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_faq |> Servy.Handler.handle() |> IO.puts()

# Post request

request_post = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

request_post |> Servy.Handler.handle() |> IO.puts()
