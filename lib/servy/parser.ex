defmodule Servy.Parser do
  @moduledoc """
  Handles HTTP parsing.
  """

  alias Servy.Conv

  @doc """
  Parses a request into a struct
  """
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n", parts: 2)

    [request_line | _header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    params = parse_params(params_string)

    %Conv{
      method: method,
      path: path,
      params: params
    }
  end

  defp parse_params(params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end
end
