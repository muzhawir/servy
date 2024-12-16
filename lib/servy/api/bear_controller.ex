defmodule Servy.Api.BearController do
  alias Servy.Conv

  def index(conv) do
    json = Poison.encode!(Servy.Wildthings.list_bears())

    %Conv{
      conv
      | status: 200,
        resp_headers: Map.put(conv.resp_headers, "Content-Type", "application/json"),
        resp_body: json
    }
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %Conv{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end
end
