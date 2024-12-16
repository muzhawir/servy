defmodule Servy.Wildthings do
  @moduledoc false

  alias Servy.Bear

  @db_path Path.expand("db", File.cwd!())

  def list_bears do
    @db_path
    |> Path.join("bears.json")
    |> read_json()
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def read_json(json_file) do
    case File.read(json_file) do
      {:ok, content} -> content
      {_, reason} -> raise "Could not read #{json_file}: #{reason}"
    end
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer() |> get_bear()
  end
end
