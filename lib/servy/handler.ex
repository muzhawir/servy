defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  import Servy.FileHandler, only: :functions
  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]

  alias Servy.Api.BearController, as: ApiBearController
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
    |> track()
    |> format_response()
  end

  @doc """
  Routes a request.
  """
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %Conv{conv | status: 200, resp_body: "Lions, Tigers, Bears"}
  end

  def route(%Conv{method: "GET", path: "/api/bears/"} = conv) do
    ApiBearController.index(conv)
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
    BearController.delete(conv)
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
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
