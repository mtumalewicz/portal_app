defmodule Portal do
  @moduledoc """
  Documentation for `Portal`.
  """

  defstruct [:left, :right]

  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  def transfer(left, right, data) do
    # First add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left, item)
    end

    # Returns a portal struct we will use next
    %Portal{left: left, right: right}
  end

  @doc """
  Sets left_data on left portal and right_data on right portal.
  """
  def transfer(left, right, left_data, right_data) do
    # First add all data to the portal on the left
    for item <- left_data do
      Portal.Door.push(left, item)
    end

    # And on the right
    for item <- right_data do
      Portal.Door.push(right, item)
    end

    # Returns a portal struct we will use next
    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the specified `direction` in the given `portal`.
  """
  def push(portal, direction) do
    # Define which portal provides data and which takes.
    {from, to} =
      case direction do
        :right ->
          {portal.left, portal.right}

        :left ->
          {portal.right, portal.left}
      end

    # See if we can pop data from right. If so, push the
    # popped data to the left. Otherwise, do nothing.
    case Portal.Door.pop(from) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(to, h)
    end
  end

  @doc """
  Pushes given data from left to right. If data is a direction then already
  exisiting data on portal is used.
  """
  def push(portal, data) do
    {from, to} = {portal.left, portal.right}

    # Push and pop are used to simulate data "travel" through portals.
    Portal.Door.push(from, data)

    case Portal.Door.pop(from) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(to, h)
    end

    # Let's return the portal itself
    portal
  end

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    DynamicSupervisor.start_child(Portal.DoorSupervisor, {Portal.Door, color})
  end

  @doc """
  Shoots pair of doors with dynamic names.
  """
  def open() do
    {_, left} = DynamicSupervisor.start_child(Portal.DoorSupervisor, {Portal.Door, nil})
    {_, right} = DynamicSupervisor.start_child(Portal.DoorSupervisor, {Portal.Door, nil})

    %Portal{left: left, right: right}
  end

  @doc """
  Shoots pair of doors with given names.
  """
  def open(left_name, right_name) do
    {_, left} = DynamicSupervisor.start_child(Portal.DoorSupervisor, {Portal.Door, left_name})
    {_, right} = DynamicSupervisor.start_child(Portal.DoorSupervisor, {Portal.Door, right_name})

    %Portal{left: left, right: right}
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.pad_leading(left_door, max)} <=> #{right_door}
      #{String.pad_leading(left_data, max)} <=> #{right_data}
    >
    """
  end
end
