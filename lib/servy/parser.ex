defmodule Servy.Parser do
  @moduledoc """
  Handles HTTP parsing.
  """

  alias Servy.Conv

  @doc """
  Parses a request into a struct
  """
  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n", parts: 2)

    [request_line | header_lines] = String.split(top, "\r\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["content-type"], params_string)

    IO.inspect(header_lines)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  @doc """
  Parses header lines into a map

  ## Examples

      iex> Servy.Parser.parse_headers(["Host: example.com", "User-Agent: ExampleBrowser/1.0"])
      %{"Host" => "example.com", "User-Agent" => "ExampleBrowser/1.0"}

  """
  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn line, header_so_far ->
      [key, value] = String.split(line, ": ")
      Map.put(header_so_far, key, value)
    end)
  end

  @doc """
  Parses a form URL encoded string into a map

  ## Examples

      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", "name=Dave&type=Fish")
      %{"name" => "Dave", "type" => "Fish"}

      iex> Servy.Parser.parse_params("multipart/form-data", "name=Dave&type=Fish")
      %{}

  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}
end
