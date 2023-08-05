defmodule LiveViewTodosWeb.PostControllerTest do
  use LiveViewTodosWeb.ConnCase

  alias LiveViewTodos.Blog

  @create_attrs %{title: "some title", body: "some body", published_at: ~N[2023-08-04 12:44:00], published: true, views: 42}
  @update_attrs %{title: "some updated title", body: "some updated body", published_at: ~N[2023-08-05 12:44:00], published: false, views: 43}
  @invalid_attrs %{title: nil, body: nil, published_at: nil, published: nil, views: nil}

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get conn, ~p"/posts"
      assert html_response(conn, 200) =~ "Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get conn, ~p"/posts/new"
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, ~p"/posts", post: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == "/posts/#{id}"

      conn = get conn, ~p"/posts/#{id}"
      assert html_response(conn, 200) =~ "Post Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, ~p"/posts", post: @invalid_attrs
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = get conn, ~p"/posts/#{post}/edit"
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = put conn, ~p"/posts/#{post}", post: @update_attrs
      assert redirected_to(conn) == ~p"/posts/#{post}"

      conn = get conn, ~p"/posts/#{post}" 
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put conn, ~p"/posts/#{post}", post: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete conn, ~p"/posts/#{post}"
      assert redirected_to(conn) == "/posts"
      assert_error_sent 404, fn ->
        get conn, ~p"/posts/#{post}"
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end
