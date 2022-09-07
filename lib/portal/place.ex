defmodule Place do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def inspect(name) do
    get(name)
    |> IO.inspect()
  end

  def get_all() do
    __MODULE__
    |> Agent.get(& &1)
  end

  def get(name) do
    get_all()
    |> Map.get(name, [])
  end

  def push(place, val) do
    if is_list(val) do
      Enum.each(val, fn x -> push(place, x) end)
    else
      value = [val | get(place)]
      __MODULE__
      |> Agent.update(fn state ->
        Map.put(state, place, value)
      end)
    end
    # Task.async(fn -> Portal.activate(place) end)
  end

  def pop(place) do
    value = get(place) |> Enum.reverse |> tl |> Enum.reverse
    __MODULE__
    |> Agent.update(fn state ->
      Map.put(state, place, value)
    end)
  end
end
