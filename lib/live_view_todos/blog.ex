defmodule LiveViewTodos.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false

  alias LiveViewTodos.Blog.Post

  alias LiveViewTodos.Repo

  alias LiveViewTodos.Blog.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  alias LiveViewTodos.Blog.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    query = from(p in Post, order_by: [desc: p.inserted_at], preload: [:tags])
    Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Post
    |> Repo.get!(Post, id)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    ids = attrs["tag_ids"]
    tags = Repo.all(from t in Tag, where: t.id in ^ids)

    %Post{}
    |> Post.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs, tag_ids \\ []) do
    tags = Enum.map(tag_ids, &Repo.get!(Tag, &1))

    post
    |> Post.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias LiveViewTodos.Blog.PostTag

  @doc """
  Returns the list of post_tags.

  ## Examples

      iex> list_post_tags()
      [%PostTag{}, ...]

  """
  def list_post_tags do
    Repo.all(PostTag)
  end

  @doc """
  Gets a single post_tag.

  Raises `Ecto.NoResultsError` if the Post tag does not exist.

  ## Examples

      iex> get_post_tag!(123)
      %PostTag{}

      iex> get_post_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_tag!(id), do: Repo.get!(PostTag, id)

  @doc """
  Creates a post_tag.

  ## Examples

      iex> create_post_tag(%{field: value})
      {:ok, %PostTag{}}

      iex> create_post_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post_tag(attrs \\ %{}) do
    %PostTag{}
    |> PostTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post_tag.

  ## Examples

      iex> update_post_tag(post_tag, %{field: new_value})
      {:ok, %PostTag{}}

      iex> update_post_tag(post_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post_tag(%PostTag{} = post_tag, attrs) do
    post_tag
    |> PostTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post_tag.

  ## Examples

      iex> delete_post_tag(post_tag)
      {:ok, %PostTag{}}

      iex> delete_post_tag(post_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post_tag(%PostTag{} = post_tag) do
    Repo.delete(post_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post_tag changes.

  ## Examples

      iex> change_post_tag(post_tag)
      %Ecto.Changeset{data: %PostTag{}}

  """
  def change_post_tag(%PostTag{} = post_tag, attrs \\ %{}) do
    PostTag.changeset(post_tag, attrs)
  end
end
