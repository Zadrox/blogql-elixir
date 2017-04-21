defmodule BlogqlElixir.Repo.Migrations.AddSlugColumnToUsersAndPosts do
  use Ecto.Migration

  def change do

    alter table(:posts) do
      add :slug, :citext
    end
    
    create unique_index(:posts, [:slug])
  end
end
