defmodule BlogqlElixir.Post do
  use BlogqlElixir.Web, :model

  alias BlogqlElixir.Tag
  alias BlogqlElixir.Repo

  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :like_count, :integer, default: 0

    belongs_to :user, BlogqlElixir.User
    has_many :comments, BlogqlElixir.Comment, on_delete: :delete_all
    many_to_many :tags, Tag, join_through: BlogqlElixir.PostTag, on_replace: :delete
    many_to_many :likes, BlogqlElixir.User, join_through: BlogqlElixir.LikePost

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
    |> maybe_insert_tags(params)
  end

  def like_changeset(struct, params) do
    struct
    |> cast(params, [:like_count])
    |> validate_required([:like_count])
    |> validate_number(:like_count, greater_than_or_equal_to: 0)
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

  defp maybe_insert_tags(changeset, params) do
    if Map.has_key?(params, :tags) do
      put_assoc(changeset, :tags, parse_tags(params))
    else
      changeset
    end
  end

  defp parse_tags(params) do
    (params.tags || [])
    |> Enum.map(&String.downcase/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> insert_and_get_all()
  end

  defp insert_and_get_all([]) do
    []
  end
  
  defp insert_and_get_all(names) do
    maps = Enum.map(names, &%{name: &1, inserted_at: timestamp(), updated_at: timestamp()})
    Repo.insert_all Tag, maps, on_conflict: :nothing
    Repo.all(from t in Tag, where: t.name in ^names)
  end

  defp timestamp do
    NaiveDateTime.utc_now
  end
  
end
