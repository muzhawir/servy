defmodule Servy.BearController do
  @moduledoc """
  Handles HTTP requests to /bears
  """

  alias Servy.Bear
  alias Servy.Conv
  alias Servy.Wildthings

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_ascending_by_name/2)
      |> Enum.map_join(&bear_item/1)

    %Conv{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %Conv{conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>"}
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %Conv{
      conv
      | status: 201,
        resp_body: "Created a #{type} bear named #{name} bear!"
    }
  end
end
