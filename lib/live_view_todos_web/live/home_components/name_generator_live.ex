defmodule LiveViewTodosWeb.NameGeneratorLive do
  use LiveViewTodosWeb, :live_view
  alias LiveViewTodos.RandomNames

  def mount(params, session, socket) do
    {:ok, socket |> assign(:name, RandomNames.generate_random_name(4))}
  end

  def handle_event("changeName", _unsigned_params, socket) do
    {:noreply, update(socket, :name, fn _ -> RandomNames.generate_random_name(4) end)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-4 bg-purple-400 text-white flex items-center justify-between">
      <p>Your name now is <%= @name %></p>
      <button class="bg-purple-700 p-4 rounded-lg" phx-click="changeName">Change name</button>
    </div>
    """
  end
end
