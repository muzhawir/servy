defmodule Servy.Conv do
  @moduledoc false

  defstruct method: "GET", path: "", resp_body: "", status: nil

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    http_response_codes = %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }

    http_response_codes[code]
  end
end
