defmodule LiveViewTodosWeb.Admin.TagControllerTest do
  use LiveViewTodosWeb.ConnCase

  alias LiveViewTodos.Blog

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:tag) do
    {:ok, tag} = Blog.create_tag(@create_attrs)
    tag
  end

  describe "index" do
    test "lists all tags", %{conn: conn} do
      conn = get conn, ~p"/admin/tags"
      assert html_response(conn, 200) =~ "Tags"
    end
  end

  describe "new tag" do
    test "renders form", %{conn: conn} do
      conn = get conn, ~p"/admin/tags/new"
      assert html_response(conn, 200) =~ "New Tag"
    end
  end

  describe "create tag" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, ~p"/admin/tags", tag: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == "/admin/tags/#{id}"

      conn = get conn, ~p"/admin/tags/#{id}"
      assert html_response(conn, 200) =~ "Tag Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, ~p"/admin/tags", tag: @invalid_attrs
      assert html_response(conn, 200) =~ "New Tag"
    end
  end

  describe "edit tag" do
    setup [:create_tag]

    test "renders form for editing chosen tag", %{conn: conn, tag: tag} do
      conn = get conn, ~p"/admin/tags/#{tag}/edit"
      assert html_response(conn, 200) =~ "Edit Tag"
    end
  end

  describe "update tag" do
    setup [:create_tag]

    test "redirects when data is valid", %{conn: conn, tag: tag} do
      conn = put conn, ~p"/admin/tags/#{tag}", tag: @update_attrs
      assert redirected_to(conn) == ~p"/admin/tags/#{tag}"

      conn = get conn, ~p"/admin/tags/#{tag}" 
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, tag: tag} do
      conn = put conn, ~p"/admin/tags/#{tag}", tag: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Tag"
    end
  end

  describe "delete tag" do
    setup [:create_tag]

    test "deletes chosen tag", %{conn: conn, tag: tag} do
      conn = delete conn, ~p"/admin/tags/#{tag}"
      assert redirected_to(conn) == "/admin/tags"
      assert_error_sent 404, fn ->
        get conn, ~p"/admin/tags/#{tag}"
      end
    end
  end

  defp create_tag(_) do
    tag = fixture(:tag)
    {:ok, tag: tag}
  end
end
