defmodule Servy.Parser do
  @moduledoc """
  Handles HTTP parsing.
  """

  @doc """
  Parses a request into a map.
  """
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "", status: nil}
  end
end
