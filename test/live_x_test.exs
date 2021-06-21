defmodule LiveExTest do
  use ExUnit.Case, async: false
  doctest LiveEx

  alias LiveEx.Example
  alias Phoenix.LiveView.{Socket}
  alias Phoenix.LiveViewTest.Endpoint
  alias Phoenix.LiveView.Utils

  setup do
    socket =
      %Socket{endpoint: Endpoint}
      |> Utils.configure_socket(%{}, nil, %{},URI.parse("https://www.example.com"))
      |> Map.merge(%{connected?: true})
      |> Utils.post_mount_prune()

    [socket: socket]
  end

  describe "init" do
    test "sets initial state", context do
      state = %{a: 1, b: "Test", c: nil}
      socket = Example.init(state, context[:socket])

      assert socket.assigns.a == Map.get(state, :a)
      assert socket.assigns.b == Map.get(state, :b)
      assert socket.assigns.c == Map.get(state, :c)
    end

    test "raises when initial state is no map List", context do
      state_keyword = [a: 1, b: "Test", c: nil]
      state_list = [:a, :b, :c]

      assert_raise FunctionClauseError, fn ->
        Example.init(state_keyword, context[:socket])
      end

      assert_raise FunctionClauseError, fn ->
        Example.init(state_list, context[:socket])
      end
    end
  end

  describe "dispatch" do
    test "broadcasts an event to PubSub", context do
      socket = Example.init(context[:socket])

      event = %{
        type: "test_event",
        payload: "test_payload"
      }

      :ok = Example.dispatch(event.type, event.payload, socket)
      assert_receive event
    end

    test "raises when `init` was not called before dispatching", context do
      assert_raise KeyError, fn ->
        Example.dispatch("test", "test", context[:socket])
      end
    end
  end

  describe "commit" do
    test "updates the no_payload state", context do
      socket = Example.init(context[:socket])
      {:noreply, socket} = Example.commit(:no_payload, %{}, socket)

      assert socket.assigns.no_payload == true
    end

    test "updates the with_payload state", context do
      socket = Example.init(context[:socket])
      {:noreply, socket} = Example.commit(:with_payload, "updated_state", socket)

      assert socket.assigns.with_payload == "updated_state"
    end
  end
end
