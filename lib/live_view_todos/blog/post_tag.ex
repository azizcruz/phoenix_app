defmodule LiveViewTodos.Blog.PostTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_tags" do
    belongs_to :post, LiveViewTodos.Blog.Post, foreign_key: :post_id
    belongs_to :tag, LiveViewTodos.Blog.Tag, foreign_key: :tag_id
  end

  @doc false
  def changeset(post_tag, attrs) do
    post_tag
    |> cast(attrs, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
  end
end
