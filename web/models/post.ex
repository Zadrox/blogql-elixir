defmodule BlogqlElixir.Post do
  use BlogqlElixir.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
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
    |> gen_slug
    |> unique_constraint(:slug, name: :posts_slug_index)
  end

  def gen_slug(changeset) do
    if title = get_change(changeset, :title) do
      title = Regex.replace(~r/[^\w \xC0-\xFF]/, title, "")
      changeset
      |> put_change(:slug, String.replace(title, " ", "-"))
    else
      changeset
    end
  end
end
