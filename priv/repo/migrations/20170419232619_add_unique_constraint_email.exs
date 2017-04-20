defmodule BlogqlElixir.Repo.Migrations.AddUniqueConstraintEmail do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])
  end
end
