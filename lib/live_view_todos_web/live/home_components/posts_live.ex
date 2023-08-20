defmodule LiveViewTodosWeb.PostsLive do
  use LiveViewTodosWeb, :live_view

  alias LiveViewTodos.Blog.Post
  alias LiveViewTodos.Blog
  alias LiveViewTodos.Blog.Comment

  @changeset Post.changeset(%Post{}, %{})

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(LiveViewTodos.PubSub, "post:actions")

    {:ok,
     stream(socket, :posts, Blog.list_posts())
     |> assign(params: nil)
     |> assign(:post, %Post{})
     |> assign(:form, to_form(@changeset))
     |> assign(:title, "Create post")
     |> assign(:tags, Blog.list_tags())
     |> assign(:edit, 0)
     |> assign(:comment, 0)}
  end

  @impl true
  def handle_event("save", %{"post" => post_params}, socket) do
    case Blog.create_post(post_params) do
      {:ok, post} ->
        socket =
          socket
          |> assign(:post, %Post{})
          |> assign(:form, to_form(@changeset))
          |> reset_modal()

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset) |> put_flash(:error, "Failed To Create a post")}
    end
  end

  @impl true
  def handle_event("edit", %{"post" => post_params}, socket) do
    post = Blog.get_post!(post_params["id"])

    case Blog.update_post!(post, post_params) do
      {:ok, post} ->
        socket =
          socket
          |> assign(:post, %Post{})
          |> assign(:form, to_form(@changeset))
          |> reset_modal()

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset) |> put_flash(:error, "Failed To Create a post")}
    end
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Blog.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("validate_comment", %{"comment" => comment_params}, socket) do
    changeset =
      %Comment{}
      |> Blog.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :comment_form, changeset)}
  end

  def handle_event("edit", %{"id" => id}, socket) do
    case Blog.get_post!(id) do
      Ecto.NoResultsError ->
        {:noreply,
         socket |> redirect(~p"/") |> put_flash(:error, "No Post Found") |> push_patch(to: ~p"/")}

      post ->
        change = Blog.change_post(post)
        selected_tags = Enum.map(post.tags, & &1.id)

        {:noreply,
         socket
         |> assign(:edit, id)
         |> assign(:form, to_form(change))
         |> assign(:selected_tags, selected_tags)}
    end
  end

  def handle_event("show-comment-modal", %{"id" => id}, socket) do
    case Blog.get_post!(id) do
      Ecto.NoResultsError ->
        {:noreply,
         socket |> redirect(~p"/") |> put_flash(:error, "No Post Found") |> push_patch(to: ~p"/")}

      post ->
        comment = %Comment{}
        comment_change = Comment.changeset(comment, %{})

        {:noreply,
         socket
         |> assign(:comment, id)
         |> assign(:comment_form, to_form(comment_change))}
    end
  end

  def handle_event("reset-modal", _, socket) do
    {:noreply, socket |> reset_modal}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.get_post!(id)
    {:ok, _} = Blog.delete_post(post)

    {:noreply,
     socket
     |> put_flash(:error, "Post #{id} Deleted")
     |> stream_delete(:posts, post)}
  end

  @impl true
  def handle_info({:post_create, %{"post" => post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post, at: 0)}
  end

  @impl true
  def handle_info({:post_update, %{"post" => post}}, socket) do
    {:noreply, stream(socket, :posts, Blog.list_posts())}
  end

  @impl true
  def handle_info({:post_delete, %{"post" => post}}, socket) do
    {:noreply, stream_delete(socket, :posts, post)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp format(date) do
    {:ok, date} = Timex.format(date, "%H-%M-%S", :strftime)
    date
  end

  defp reset_modal(socket) do
    assign(socket, :edit, 0) |> assign(:comment, 0)
  end
end
