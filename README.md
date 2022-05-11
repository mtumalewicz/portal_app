# Portal

Simple app based on the Portal game giving user the ability to move data between portals.

## How to get started

```shell
mix deps.get
mix compile
iex -S mix
```

### Example usage

```elixir
# Start 2 portals to move data between
Portal.shoot(:blue)
Portal.shoot(:orange)

# Initzialize transfer between 2 portals
data = [1, 2, 3, 4]
portal = Portal.transfer(:blue, :orange, data)

# Move data
portal |> Portal.push(:right)
portal |> Portal.push(:left)
```
