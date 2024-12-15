defmodule ParserTest do
  use ExUnit.Case, async: true

  alias Servy.Parser

  doctest Servy.Parser

  test "parses a list of header fields into map" do
    header_lines = ["Host: example.com", "User-Agent: ExampleBrowser/1.0", "Accept: */*"]

    parsed_headers = Parser.parse_headers(header_lines)

    expected_headers = %{
      "Host" => "example.com",
      "User-Agent" => "ExampleBrowser/1.0",
      "Accept" => "*/*"
    }

    assert parsed_headers == expected_headers
  end
end
