defmodule BlogqlElixir.Repo.Migrations.AddColumnsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :bio, :text
      add :username, :string
    end
  end
end
