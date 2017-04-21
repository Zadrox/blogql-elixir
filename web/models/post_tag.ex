defmodule BlogqlElixir.PostTag do
  use BlogqlElixir.Web, :model

  @primary_key false
  schema "posts_tags" do
    belongs_to :post, BlogqlElixir.Post
    belongs_to :tag, BlogqlElixir.Tag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:tag_id)
    |> unique_constraint([:post_id, :tag_id], name: :posts_tags_post_id_tag_id_index)
  end
end
