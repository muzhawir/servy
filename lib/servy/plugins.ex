defmodule Servy.Plugins do
  @moduledoc """
  Handles HTTP Plugins.
  """

  require Logger

  @doc """
  Rewrites the path based on the request path.
  """
  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(conv), do: conv

  @doc """
  Logs and inspects the request.
  """
  def log(conv), do: IO.inspect(conv)

  @doc """
  Injects emoji into the response body.
  """
  def emojify(%{status: 200} = conv) do
    emojis = String.duplicate("🎉", 2)

    body = "#{emojis}\n#{conv.resp_body}\n#{emojis}"

    %{conv | resp_body: body}
  end

  def emojify(conv), do: conv

  @doc """
  Tracks the request based on the status.
  """
  def track(%{status: 404, path: path} = conv) do
    Logger.warning("Warning #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv
end
