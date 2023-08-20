defmodule LiveViewTodos.BlogTest do
  use LiveViewTodos.DataCase

  alias LiveViewTodos.Blog

  describe "tags" do
    alias LiveViewTodos.Blog.Tag

    import LiveViewTodos.BlogFixtures

    @invalid_attrs %{name: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Blog.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Blog.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tag{} = tag} = Blog.create_tag(valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Blog.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_tag(tag, @invalid_attrs)
      assert tag == Blog.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Blog.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Blog.change_tag(tag)
    end
  end

  describe "posts" do
    alias LiveViewTodos.Blog.Post

    import LiveViewTodos.BlogFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %Post{} = post} = Blog.create_post(valid_attrs)
      assert post.title == "some title"
      assert post.body == "some body"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %Post{} = post} = Blog.update_post(post, update_attrs)
      assert post.title == "some updated title"
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end

  describe "post_tags" do
    alias LiveViewTodos.Blog.PostTag

    import LiveViewTodos.BlogFixtures

    @invalid_attrs %{}

    test "list_post_tags/0 returns all post_tags" do
      post_tag = post_tag_fixture()
      assert Blog.list_post_tags() == [post_tag]
    end

    test "get_post_tag!/1 returns the post_tag with given id" do
      post_tag = post_tag_fixture()
      assert Blog.get_post_tag!(post_tag.id) == post_tag
    end

    test "create_post_tag/1 with valid data creates a post_tag" do
      valid_attrs = %{}

      assert {:ok, %PostTag{} = post_tag} = Blog.create_post_tag(valid_attrs)
    end

    test "create_post_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post_tag(@invalid_attrs)
    end

    test "update_post_tag/2 with valid data updates the post_tag" do
      post_tag = post_tag_fixture()
      update_attrs = %{}

      assert {:ok, %PostTag{} = post_tag} = Blog.update_post_tag(post_tag, update_attrs)
    end

    test "update_post_tag/2 with invalid data returns error changeset" do
      post_tag = post_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post_tag(post_tag, @invalid_attrs)
      assert post_tag == Blog.get_post_tag!(post_tag.id)
    end

    test "delete_post_tag/1 deletes the post_tag" do
      post_tag = post_tag_fixture()
      assert {:ok, %PostTag{}} = Blog.delete_post_tag(post_tag)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post_tag!(post_tag.id) end
    end

    test "change_post_tag/1 returns a post_tag changeset" do
      post_tag = post_tag_fixture()
      assert %Ecto.Changeset{} = Blog.change_post_tag(post_tag)
    end
  end

  alias LiveViewTodos.Blog.Post

  @valid_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "#paginate_posts/1" do
    test "returns paginated list of posts" do
      for _ <- 1..20 do
        post_fixture()
      end

      {:ok, %{posts: posts} = page} = Blog.paginate_posts(%{})

      assert length(posts) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_posts/0" do
    test "returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end
  end

  describe "#get_post!/1" do
    test "returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end
  end

  describe "#create_post/1" do
    test "with valid data creates a post" do
      assert {:ok, %Post{} = post} = Blog.create_post(@valid_attrs)
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end
  end

  describe "#update_post/2" do
    test "with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Blog.update_post(post, @update_attrs)
      assert %Post{} = post
    end

    test "with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end
  end

  describe "#delete_post/1" do
    test "deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end
  end

  describe "#change_post/1" do
    test "returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end

  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Blog.create_post()

    post
  end


  alias LiveViewTodos.Blog.Post

  @valid_attrs %{title: "some title", body: "some body", published_at: ~N[2023-08-04 12:44:00], published: true, views: 42}
  @update_attrs %{title: "some updated title", body: "some updated body", published_at: ~N[2023-08-05 12:44:00], published: false, views: 43}
  @invalid_attrs %{title: nil, body: nil, published_at: nil, published: nil, views: nil}

  describe "#paginate_posts/1" do
    test "returns paginated list of posts" do
      for _ <- 1..20 do
        post_fixture()
      end

      {:ok, %{posts: posts} = page} = Blog.paginate_posts(%{})

      assert length(posts) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_posts/0" do
    test "returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end
  end

  describe "#get_post!/1" do
    test "returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end
  end

  describe "#create_post/1" do
    test "with valid data creates a post" do
      assert {:ok, %Post{} = post} = Blog.create_post(@valid_attrs)
      assert post.title == "some title"
      assert post.body == "some body"
      assert post.published_at == ~N[2023-08-04 12:44:00]
      assert post.published == true
      assert post.views == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end
  end

  describe "#update_post/2" do
    test "with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Blog.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.title == "some updated title"
      assert post.body == "some updated body"
      assert post.published_at == ~N[2023-08-05 12:44:00]
      assert post.published == false
      assert post.views == 43
    end

    test "with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end
  end

  describe "#delete_post/1" do
    test "deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end
  end

  describe "#change_post/1" do
    test "returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end

  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Blog.create_post()

    post
  end


  alias LiveViewTodos.Blog.Tag

  @valid_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "#paginate_tags/1" do
    test "returns paginated list of tags" do
      for _ <- 1..20 do
        tag_fixture()
      end

      {:ok, %{tags: tags} = page} = Blog.paginate_tags(%{})

      assert length(tags) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_tags/0" do
    test "returns all tags" do
      tag = tag_fixture()
      assert Blog.list_tags() == [tag]
    end
  end

  describe "#get_tag!/1" do
    test "returns the tag with given id" do
      tag = tag_fixture()
      assert Blog.get_tag!(tag.id) == tag
    end
  end

  describe "#create_tag/1" do
    test "with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Blog.create_tag(@valid_attrs)
      assert tag.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_tag(@invalid_attrs)
    end
  end

  describe "#update_tag/2" do
    test "with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, tag} = Blog.update_tag(tag, @update_attrs)
      assert %Tag{} = tag
      assert tag.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_tag(tag, @invalid_attrs)
      assert tag == Blog.get_tag!(tag.id)
    end
  end

  describe "#delete_tag/1" do
    test "deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Blog.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_tag!(tag.id) end
    end
  end

  describe "#change_tag/1" do
    test "returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Blog.change_tag(tag)
    end
  end

  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Blog.create_tag()

    tag
  end


  alias LiveViewTodos.Blog.Comment

  @valid_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  describe "#paginate_comments/1" do
    test "returns paginated list of comments" do
      for _ <- 1..20 do
        comment_fixture()
      end

      {:ok, %{comments: comments} = page} = Blog.paginate_comments(%{})

      assert length(comments) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_comments/0" do
    test "returns all comments" do
      comment = comment_fixture()
      assert Blog.list_comments() == [comment]
    end
  end

  describe "#get_comment!/1" do
    test "returns the comment with given id" do
      comment = comment_fixture()
      assert Blog.get_comment!(comment.id) == comment
    end
  end

  describe "#create_comment/1" do
    test "with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Blog.create_comment(@valid_attrs)
      assert comment.content == "some content"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_comment(@invalid_attrs)
    end
  end

  describe "#update_comment/2" do
    test "with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = Blog.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.content == "some updated content"
    end

    test "with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_comment(comment, @invalid_attrs)
      assert comment == Blog.get_comment!(comment.id)
    end
  end

  describe "#delete_comment/1" do
    test "deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Blog.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_comment!(comment.id) end
    end
  end

  describe "#change_comment/1" do
    test "returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Blog.change_comment(comment)
    end
  end

  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Blog.create_comment()

    comment
  end

end
