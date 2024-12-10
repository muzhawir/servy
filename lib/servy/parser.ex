defmodule Servy.Parser do
  @moduledoc """
  Handles HTTP parsing.
  """

  alias Servy.Conv

  @doc """
  Parses a request into a map.
  """
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{method: method, path: path}
  end
end
