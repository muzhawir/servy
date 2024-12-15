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
end
