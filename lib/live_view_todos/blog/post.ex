defmodule LiveViewTodos.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    field(:body, :string)

    has_many(:comments, LiveViewTodos.Blog.Comment)

    many_to_many(:tags, LiveViewTodos.Blog.Tag,
      join_through: "post_tags",
      on_replace: :delete,
      on_delete: :delete_all
    )

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
