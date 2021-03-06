defmodule BlogqlElixir.Repo.Migrations.CreatePostTag do
  use Ecto.Migration

  def change do
    create table(:posts_tags) do
      add :post_id, references(:posts, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:posts_tags, [:post_id, :tag_id])
  end
end
