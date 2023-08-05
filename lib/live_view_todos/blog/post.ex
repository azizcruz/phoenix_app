defmodule LiveViewTodos.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveViewTodos.Blog.Tag

  schema "posts" do
    field(:title, :string)
    field(:body, :string)
    many_to_many(:tags, LiveViewTodos.Blog.Tag, join_through: "post_tags")

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> cast_assoc(:tags, with: &Tag.changeset/2, on_replace: :delete)
  end
end
