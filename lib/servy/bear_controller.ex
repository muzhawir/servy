defmodule Servy.BearController do
  @moduledoc """
  Handles HTTP requests to /bears
  """

  import Servy.View, only: [render: 3]

  alias Servy.Bear
  alias Servy.Conv
  alias Servy.Wildthings

  def index(conv) do
    bears = Enum.sort(Wildthings.list_bears(), &Bear.order_ascending_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %Conv{
      conv
      | status: 201,
        resp_body: "Created a #{type} bear named #{name} bear!"
    }
  end

  def delete(conv) do
    %Conv{conv | status: 403, resp_body: "Deleting bear is forbidden"}
  end
end
