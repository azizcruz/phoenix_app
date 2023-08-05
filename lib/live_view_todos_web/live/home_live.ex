defmodule LiveViewTodosWeb.HomeLive do
  use LiveViewTodosWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <ul class="list-none flex gap-1 mb-3">
        <li><.link patch={~p"/todos"} class="bg-red-300 p-3 rounded-lg">Todos</.link></li>
        <li><.link patch={~p"/tags"} class="bg-red-300 p-3 rounded-lg">Tags</.link></li>
      </ul>
      <div class="grid grid-cols-[auto,auto] gap-2">
        <div>
          <%= live_render(@socket, LiveViewTodosWeb.NameGeneratorLive, id: "livenamegenerator") %>
        </div>
        <div>
          <%= live_render(@socket, LiveViewTodosWeb.LightLive, id: "livelight") %>
        </div>
      </div>
      <div>
        <%= live_render(@socket, LiveViewTodosWeb.PostsLive, id: "liveposts") %>
      </div>
    </div>
    """
  end
end
