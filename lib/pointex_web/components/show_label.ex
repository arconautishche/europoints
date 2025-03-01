defmodule PointexWeb.Components.ShowLabel do
  use PointexWeb, :html

  attr :year, :integer, required: true
  attr :show_name, :atom, required: true

  def show_label(assigns) do
    ~H"""
    <div class="flex gap-2 text-amber-800 text-sm px-2 py-1 bg-amber-100/50 rounded">
      <span class="opacity-50">{@year}</span>
      <span>{display_name(@show_name)}</span>
    </div>
    """
  end

  defp display_name(:semi_final_1), do: "Semi-final 1"
  defp display_name(:semi_final_2), do: "Semi-final 2"
  defp display_name(:final), do: "Final"
end
