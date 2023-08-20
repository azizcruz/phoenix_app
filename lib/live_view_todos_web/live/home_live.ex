defmodule LiveViewTodosWeb.HomeLive do
  use LiveViewTodosWeb, :live_view
  alias LiveViewTodos.Blog

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(LiveViewTodos.PubSub, "post:actions")
    {:ok, socket}
  end

  def handle_params(unsigned_params, uri, socket) do
    {:noreply, assign(socket, params: unsigned_params)}
  end

  # def handle_info(_msg, _params, socket) do
  #   {:noreply, socket |> put_flash(:info, "New Post was added")}
  # end

  def handle_info({:post_create, %{"post" => post}}, socket) do
    {:noreply, socket |> put_flash(:info, "New Post #{post.title} was created")}
  end

  def handle_info({:post_update, %{"post" => post}}, socket) do
    {:noreply, socket |> put_flash(:info, "New Post #{post.title} was updated")}
  end

  def handle_info({:post_delete, %{"post" => post}}, socket) do
    {:noreply, socket |> put_flash(:info, "New Post #{post.title} was deleted")}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div>
      <.flash_group flash={@flash} />

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
        <%= live_render(@socket, LiveViewTodosWeb.PostsLive,
          id: "liveposts",
          session: %{"params" => @params}
        ) %>
      </div>
    </div>
    """
  end
end
