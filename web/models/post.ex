defmodule BlogqlElixir.Post do
  use BlogqlElixir.Web, :model

  alias BlogqlElixir.Tag
  alias BlogqlElixir.Repo

  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string

    belongs_to :user, BlogqlElixir.User
    has_many :comments, BlogqlElixir.Comment, on_delete: :delete_all
    many_to_many :tags, Tag, join_through: BlogqlElixir.PostTag

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
    |> put_assoc(:tags, parse_tags(params))
  end

  defp gen_slug(changeset) do
    if title = get_change(changeset, :title) do
      title = Regex.replace(~r/[^\w \xC0-\xFF]/, title, "")
      changeset
      |> put_change(:slug, String.replace(title, " ", "-"))
    else
      changeset
    end
  end

  defp parse_tags(params)  do
    (params.tags || "")
    |> Enum.map(&String.downcase/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> insert_and_get_all()
  end

  defp insert_and_get_all([]) do
    []
  end
  
  defp insert_and_get_all(names) do
    maps = Enum.map(names, &%{name: &1, inserted_at: timestamp, updated_at: timestamp})
    Repo.insert_all Tag, maps, on_conflict: :nothing
    Repo.all(from t in Tag, where: t.name in ^names)
  end

  defp timestamp do
    NaiveDateTime.utc_now
  end
  
end
