defmodule PortalTest do
  use ExUnit.Case, async: true
  doctest Portal

  setup do
    Portal.Door.clear_state(:blue)
    Portal.Door.clear_state(:orange)
    :ok
  end

  test "push left <- while right portal is empty" do
    Portal.transfer(:blue, :orange, [], [])
    |> Portal.push(:left)

    assert Portal.Door.get(:blue) == []
    assert Portal.Door.get(:orange) == []
  end

  test "push right -> while left portal is empty" do
    Portal.transfer(:blue, :orange, [], [])
    |> Portal.push(:right)

    assert Portal.Door.get(:blue) == []
    assert Portal.Door.get(:orange) == []
  end

  test "push left <- while right portal has data" do
    Portal.transfer(:blue, :orange, [], [1, 2, 3])
    |> Portal.push(:left)

    assert Portal.Door.get(:blue) == [3]
    assert Portal.Door.get(:orange) == [2, 1]
  end

  test "push right -> while left portal has data" do
    Portal.transfer(:blue, :orange, [1, 2, 3], [])
    |> Portal.push(:right)

    assert Portal.Door.get(:blue) == [2, 1]
    assert Portal.Door.get(:orange) == [3]
  end
end
