defmodule BlogqlElixir.LikePost do
  use BlogqlElixir.Web, :model

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

end
