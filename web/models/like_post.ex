defmodule BlogqlElixir.LikePost do
  use BlogqlElixir.Web, :model

  alias BlogqlElixir.Repo
  alias BlogqlElixir.Post

  @primary_key false
  schema "like_posts" do
    belongs_to :post, BlogqlElixir.Post
    belongs_to :user, BlogqlElixir.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id, name: :like_posts_user_id_post_id_index)
  end

  # def delete_changeset(struct) do
  #   struct
  #   |> decrease_like_count(struct.post_id)
  # end

  # defp increase_like_count(changeset, post_id) do
  #   IO.inspect changeset

  #   post = Repo.get!(Post, post_id)
  #   Post.like_changeset(post, %{like_count: post.like_count+1})
  #   |> Repo.update!

  #   changeset
  # end

  # defp decrease_like_count(changeset, post_id) do
  #   post = Repo.get!(Post, post_id)
  #   Post.like_changeset(post, %{like_count: post.like_count-1})
  #   |> Repo.update!

  #   changeset
  # end
end
