defmodule BlogqlElixir.Comment do
  use BlogqlElixir.Web, :model

  schema "comments" do
    field :body, :string
    belongs_to :post, BlogqlElixir.Post
    belongs_to :user, BlogqlElixir.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :post_id, :user_id])
    |> validate_required([:body, :post_id, :user_id])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:user_id)
  end
end
