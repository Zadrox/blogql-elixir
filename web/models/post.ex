defmodule BlogqlElixir.Post do
  use BlogqlElixir.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    belongs_to :user, BlogqlElixir.User
    has_many :comments, BlogqlElixir.Comment, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
