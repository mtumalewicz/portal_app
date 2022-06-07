defmodule PortalSpec do
  use ESpec

  finally do
    Portal.Door.clear_state(:blue)
    Portal.Door.clear_state(:orange)
    :ok
  end

  describe "portals data transfer" do
    context "when there's no data" do
      example "push left <- while right portal is empty" do
        Portal.transfer(:blue, :orange, [], []) |>
          Portal.push(:left)

        expect(Portal.Door.get(:blue)) |> to(eq([]))
        expect(Portal.Door.get(:orange)) |> to(eq([]))
      end

      example "push right -> while left portal is empty" do
        Portal.transfer(:blue, :orange, [], []) |>
          Portal.push(:right)

        expect(Portal.Door.get(:blue)) |> to(eq([]))
        expect(Portal.Door.get(:orange)) |> to(eq([]))
      end
    end

    context "when there is data" do
      example "push left <- while right portal has data" do
        Portal.transfer(:blue, :orange, [], [1, 2, 3]) |>
          Portal.push(:left)

        expect(Portal.Door.get(:blue)) |> to(eq([3]))
        expect(Portal.Door.get(:orange)) |> to(eq([2, 1]))
      end

      example "push right -> while left portal has data" do
        Portal.transfer(:blue, :orange, [1, 2, 3], []) |>
          Portal.push(:right)

        expect(Portal.Door.get(:blue)) |> to(eq([2, 1]))
        expect(Portal.Door.get(:orange)) |> to(eq([3]))
      end
    end
  end

  describe "open/0" do
    it "opens a portal with dynamic doors" do
      portal = Portal.open()

      expect(portal.left)  |> to(be_pid())
      expect(portal.right) |> to(be_pid())
    end
  end

  describe "open/2" do
    it "opens a portal with named doors" do
      portal = Portal.open(:kitchen, :bedroom)

      {:registered_name, in_name} =
        Process.info(portal.left, :registered_name)

      {:registered_name, out_name} =
        Process.info(portal.right, :registered_name)

      expect(in_name) |> to(eq(:kitchen))
      expect(out_name) |> to(eq(:bedroom))
    end
  end

  describe "push/2" do
    it "pushes value through the portal" do
      portal = Portal.open()
      |> Portal.push(1)
      |> Portal.push(2)

      expect(Portal.Door.get(portal.left)) |> to(eq([]))
      expect(Portal.Door.get(portal.right)) |> to(eq([2, 1]))
    end

    context "when another portal has input connected to the output" do
      it "pushes value through that portal too"
    end

    context "when multiple portals have input connected to the output" do
      it "pushes value through all portals, duplicating it"
    end
  end
end
