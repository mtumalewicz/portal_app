defmodule Portal do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def open(left, right) do
    # if reverse link exists
    if Portal.get(right) == left do
      :err
    else
      put(left, right)
      Task.async(fn -> Portal.activate(left) end)
    end
  end

  def activate(left) do
    right = Portal.get(left)
    content = Place.get(left)

    right
    |> Enum.each(fn x -> Place.push(x, content) end)

    Agent.update(Place, fn state ->
      Map.put(state, left, [])
    end)

    :timer.sleep(1000)
    activate(left)
  end

  def put(entry, target) do
    targets = case get(entry) do
      [] -> [target]
      _ -> [target | get(entry)]
    end

    __MODULE__
    |> Agent.update(fn state ->
      Map.put(state, entry, targets)
    end)
  end

  @spec inspect(atom) :: any
  def inspect(left) do
    get(left)
    |> IO.inspect()
  end

  def get_all() do
    __MODULE__
    |> Agent.get(& &1)
  end

  def get(left) do
    get_all()
    |> Map.get(left, [])
  end
end
