defmodule BlogqlElixir.Repo.Migrations.UpdateLikePostsColumns do
  use Ecto.Migration

  def change do
    drop index(:posts_tags, [:post_id, :tag_id])
    drop index(:like_posts, [:post_id])
    drop index(:like_posts, [:user_id])
    drop index(:like_posts, [:user_id, :post_id])

    drop constraint(:posts_tags, "posts_tags_post_id_fkey")
    drop constraint(:posts_tags, "posts_tags_tag_id_fkey")
    drop constraint(:like_posts, "like_posts_post_id_fkey")
    drop constraint(:like_posts, "like_posts_user_id_fkey")

    alter table(:posts_tags) do
      modify :post_id, references(:posts, on_delete: :delete_all)
      modify :tag_id, references(:tags, on_delete: :delete_all)
    end

    alter table(:like_posts) do
      modify :post_id, references(:posts, on_delete: :delete_all)
      modify :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:posts_tags, [:post_id, :tag_id])
    create index(:like_posts, [:post_id])
    create index(:like_posts, [:user_id])
    create index(:like_posts, [:user_id, :post_id])
  end
end
