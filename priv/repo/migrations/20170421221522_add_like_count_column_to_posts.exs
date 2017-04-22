defmodule BlogqlElixir.Repo.Migrations.AddLikeCountColumnToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :like_count, :integer
    end
  end
end
