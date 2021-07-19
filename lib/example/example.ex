defmodule LiveEx.Example do
  @moduledoc """
  Example Implementation of a LiveEx Store that is used by `Phoenix.LiveView`s.
  """

  use LiveEx

  # Set an initial (global) state.
  # Set all variables that are part of the global state.
  @initial_state %{
    no_payload: false,
    with_payload: "default"
  }

  @doc """
  Call this function from the `mount/2` function of your "root"-LiveView.

  Adds the initial state variables to the `socket.assigns` and returns the updated `LiveView.Socket`.
  """
  @spec init(socket) :: socket
  def init(socket) do
    init(@initial_state, socket)
  end

  # Actions
  #
  # Define any Actions below.
  #
  # Actions must be `handle_info/2` GenServer Event Handlers that are pattern-matched
  # against the action `type`.
  #
  # Actions must call the `commit/3` function and return what the `commit/3` function returns.

  @doc """
  Handles a dispatch and commits a mutation based on the payload of the action.

  `action` here has the format: `%{type: :a_type_here, payload: %{}}`
  """
  @spec handle_info(%{type: String.t(), payload: map}, socket) :: {:noreply, socket}
  def handle_info(action, socket)

  def handle_info(%{type: "no_payload"} = action, socket) do
    commit(action.type, %{}, socket)
  end

  def handle_info(%{type: "with_payload"} = action, socket) do
    commit(action.type, action.payload, socket)
  end

  # Mutations
  #
  # Define any Mutations below.
  #
  # Mutations must have the same name as the action `type`.
  # Mutations update the `socket.assigns` with the `assign/3` function.
  #
  # Mutations must return the updated `LiveView.Socket`.

  @doc """
  Mutates the `:no_payload` variable of the store.
  """
  @spec no_payload(map, socket) :: socket
  def no_payload(%{}, socket) do
    assign(socket, :no_payload, !socket.assigns.no_payload)
  end

  @spec with_payload(map, socket) :: socket
  def with_payload(payload, socket) do
    assign(socket, :with_payload, payload)
  end
end
