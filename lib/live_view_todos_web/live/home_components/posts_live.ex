defmodule LiveViewTodosWeb.PostsLive do
  use LiveViewTodosWeb, :live_view

  alias LiveViewTodos.Blog.Post
  alias LiveViewTodos.Blog

  @changeset Blog.change_post(%Post{})

  @impl true
  def mount(params, session, socket) do
    Phoenix.PubSub.subscribe(LiveViewTodos.PubSub, "posts")

    {:ok,
     stream(socket, :posts, Blog.list_posts())
     |> assign(:post, %Post{})
     |> assign(:form, to_form(@changeset))
     |> assign(:title, "Create post")
     |> assign(:tags, Blog.list_tags())}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    case Blog.create_post(post_params) do
      {:ok, post} ->
        push_event(
          socket,
          "app:updated",
          %{id: post.id}
        )

        socket =
          socket
          |> put_flash(:info, "Post created successfully")
          |> assign(:post, %Post{})
          |> assign(:form, to_form(@changeset))
          |> stream_insert(:posts, post, at: 0)

        Phoenix.PubSub.broadcast(LiveViewTodos.PubSub, "posts", %{
          post: post
        })

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset) |> put_flash(:error, "Failed To Create a post")}
    end
  end

  def handle_info(%{post: post}, socket) do
    {:noreply, stream_insert(socket, :posts, post, at: 0)}
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Blog.change_post(post_params)
      |> Map.put(:action, :insert)

    {:noreply, assign_form(socket, changeset)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-yellow-200 px-4 py-1 rounded-lg mt-3">
      <.flash_group flash={@flash} />
      <div class=" flex rounded-lg">
        <div>
          <.simple_form for={@form} id="post-form" phx-change="validate" phx-submit="save">
            <.input type="text" label="Title" field={@form[:title]} />
            <.input type="textarea" label="Body" field={@form[:body]} />
            <.input
              type="select"
              options={Enum.map(@tags, fn tag -> {tag.name, tag.id} end)}
              field={@form[:tag_ids]}
              multiple
            />
            <.button phx-disable-with="Saving">Submit</.button>
            <div class="divide-y-2"></div>
          </.simple_form>
        </div>
        <div class="ml-4 max-h-[400px] overflow-y-scroll w-full" phx-update="stream" id="posts">
          <div
            :for={{dom_id, post} <- @streams.posts}
            class="my-1 flex justify-between bg-yellow-500 p-4 rounded-lg m-1"
            id={dom_id}
          >
            <div class="w-[70%]">
              <div>
                <%= post.title %>
              </div>
              <div class="ml-2 text-gray-600 max-w-[90%]">
                <%= post.body %>
              </div>

              <button
                :for={tag <- post.tags}
                class="mt-2 ml-2 text-xs text-slate-600 bg-white p-2 rounded-lg"
              >
                <%= tag.name %>
              </button>
            </div>
            <div class="w-[30%] text-center">
              <%= format(post.inserted_at) %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_info(msg, socket) do
    dbg(msg)
    {:noreply, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp format(date) do
    {:ok, date} = Timex.format(date, "%H-%M-%S", :strftime)
    date
  end
end
