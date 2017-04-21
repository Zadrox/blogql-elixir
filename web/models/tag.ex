defmodule BlogqlElixir.Tag do
  use BlogqlElixir.Web, :model
  
  alias BlogqlElixir.PostTag
  alias BlogqlElixir.Post

  schema "tags" do
    field :name, :string

    many_to_many :posts, Post, join_through: PostTag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tag])
    |> validate_required([:tag])
  end
end
