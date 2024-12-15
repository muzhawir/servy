defmodule Servy.Plugins do
  @moduledoc """
  Handles HTTP Plugins.
  """
  alias Servy.Conv

  require Logger

  @doc """
  Rewrites the path based on the request path.
  """
  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %Conv{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %Conv{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  @doc """
  Logs and inspects the request.
  """
  def log(%Conv{} = conv) do
    if Mix.env() == :dev do
      IO.inspect(conv)
    end

    conv
  end

  @doc """
  Injects emoji into the response body.
  """
  def emojify(%Conv{status: 200} = conv) do
    emojis = String.duplicate("🎉", 2)

    body = "#{emojis}\n#{conv.resp_body}\n#{emojis}"

    %{conv | resp_body: body}
  end

  def emojify(%Conv{} = conv), do: conv

  @doc """
  Tracks the request based on the status.
  """
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      Logger.warning("Warning #{path} is on the loose!")
    end

    conv
  end

  def track(%Conv{} = conv), do: conv

  def put_content_length(conv) do
    content_length_header = Map.put(conv.resp_headers, "Content-Length", String.length(conv.resp_body))

    %Conv{conv | resp_headers: content_length_header}
  end
end
