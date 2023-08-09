defmodule LiveViewTodosWeb.PostsLive do
  alias Phoenix.Flash
  use LiveViewTodosWeb, :live_view

  alias LiveViewTodos.Blog.Post
  alias LiveViewTodos.Blog

  @changeset Blog.change_post(%Post{})

  @impl true
  def mount(params, session, socket) do
    Phoenix.PubSub.subscribe(LiveViewTodos.PubSub, "posts")

    {:ok,
     stream(socket, :posts, Blog.list_posts())
     |> assign(params: nil)
     |> assign(:post, %Post{})
     |> assign(:form, to_form(@changeset))
     |> assign(:title, "Create post")
     |> assign(:tags, Blog.list_tags())
     |> assign(:edit, 0)}
  end

  @impl true
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
          |> reset_modal()
          |> stream_insert(:posts, post, at: 0)

        Phoenix.PubSub.broadcast(LiveViewTodos.PubSub, "posts", %{
          post: post
        })

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset) |> put_flash(:error, "Failed To Create a post")}
    end
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Blog.change_post(post_params)
      |> Map.put(:action, :insert)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("edit", %{"id" => id}, socket) do
    case Blog.get_post!(id) do
      Ecto.NoResultsError ->
        {:noreply,
         socket |> redirect(~p"/") |> put_flash(:error, "No Post Found") |> push_patch(to: ~p"/")}

      post ->
        change = Blog.change_post(post)
        selected_tags = Enum.map(post.tags, & &1.id)
        dbg(selected_tags)

        {:noreply,
         socket
         |> assign(:edit, id)
         |> assign(:form, to_form(change))
         |> assign(:selected_tags, selected_tags)}
    end
  end

  def handle_event("reset-modal", _, socket) do
    {:noreply, socket |> reset_modal}
  end

  def handle_info(%{post: post}, socket) do
    {:noreply, stream_insert(socket, :posts, post, at: 0)}
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

  defp reset_modal(socket) do
    socket |> assign(:edit, 0) |> assign(:post, nil) |> assign(:form, to_form(@changeset))
  end
end
