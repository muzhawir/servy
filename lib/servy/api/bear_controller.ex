defmodule Servy.Api.BearController do
  alias Servy.Conv

  def index(conv) do
    json = Poison.encode!(Servy.Wildthings.list_bears())

    %Conv{conv | status: 200, resp_content_type: "application/json", resp_body: json}
  end
end
