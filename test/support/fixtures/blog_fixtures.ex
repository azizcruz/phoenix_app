defmodule LiveViewTodos.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewTodos.Blog` context.
  """

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> LiveViewTodos.Blog.create_tag()

    tag
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        title: "some title",
        body: "some body"
      })
      |> LiveViewTodos.Blog.create_post()

    post
  end

  @doc """
  Generate a post_tag.
  """
  def post_tag_fixture(attrs \\ %{}) do
    {:ok, post_tag} =
      attrs
      |> Enum.into(%{

      })
      |> LiveViewTodos.Blog.create_post_tag()

    post_tag
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{

      })
      |> LiveViewTodos.Blog.create_post()

    post
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        title: "some title",
        body: "some body",
        published_at: ~N[2023-08-04 12:44:00],
        published: true,
        views: 42
      })
      |> LiveViewTodos.Blog.create_post()

    post
  end
end
