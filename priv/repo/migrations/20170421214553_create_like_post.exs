defmodule BlogqlElixir.Repo.Migrations.CreateLikePost do
  use Ecto.Migration

  def change do
    create table(:like_posts, primary_key: false) do
      add :post_id, references(:posts, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:like_posts, [:post_id])
    create index(:like_posts, [:user_id])

    create unique_index(:like_posts, [:user_id, :post_id])
  end
end
