defmodule Portal.Amqp do
  @moduledoc """
  Documentation for `Portal.Amqp`.
  """

  @doc """
  Shoots pair of doors with dynamic names linked via rabbitmq channel.
  """
  def open() do
    portal = Portal.open()

    try do
      {:ok, connection} = AMQP.Connection.open(Application.get_env(Portal, :amqp))
      {:ok, channel} = AMQP.Channel.open(connection)
      routing_key = Enum.take_random(?a..?z, 10)
      AMQP.Queue.declare(channel, "", auto_delete: true, durable: true)
      opts = %{connection: connection, channel: channel, routing_key: routing_key}
      portal |> Map.put(:opts, opts)
    rescue
      MatchError ->
        IO.puts("Rabbitmq connection problem!")
    end

    portal
  end

  @doc """
  Pushes given data from left to right. If data is a direction then already
  exisiting data on portal is used.
  """
  def push(portal, data) do
    from = portal.left

    # Push and pop are used to simulate data "travel" through portals.
    Portal.Door.push(from, data)

    case Portal.Door.pop(from) do
      :error -> :ok
      _ = AMQP.Basic.publish(portal.opts.channel, "", portal.opts.routing_key, data)
      IO.puts "Sent data!"
    end

    # Let's return the portal itself
    portal
  end

end
