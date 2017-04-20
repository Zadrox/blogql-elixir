defmodule BlogqlElixir.Repo.Migrations.SwitchToCitextUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    drop_if_exists index(:users, [:email])
    drop_if_exists index(:users, [:username])

    alter table(:users) do
      modify :email, :citext
      modify :username, :citext
    end

    create index(:users, [:email])
    create index(:users, [:username]) 

  end
end
