defmodule Servy.Bear do
  @moduledoc false
  defstruct id: nil, name: "", type: "", hibernating: false

  def grizzly?(bear), do: bear.type == "Grizzly"

  def order_ascending_by_name(bear1, bear2), do: bear1.name <= bear2.name
end
