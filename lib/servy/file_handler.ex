defmodule Servy.FileHandler do
  @moduledoc """
  Handles static file requests.
  """

  @doc """
  Transforms a file input into a response.
  """
  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File Not Found"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File Error: #{reason}"}
  end
end
