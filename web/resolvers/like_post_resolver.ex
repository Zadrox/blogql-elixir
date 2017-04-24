defmodule BlogqlElixir.LikePostResolver do
  alias BlogqlElixir.LikePost
  alias BlogqlElixir.Repo
  alias BlogqlElixir.Post
  import Ecto.Query

  def likes_by_id(current_user, ids) do
    likes = Repo.all(from l in LikePost, 
      where: l.post_id in ^ids, 
      where: l.user_id == ^current_user.id,
      select: {l.post_id})

    Enum.reduce(likes, %{}, fn {a}, acc -> Map.put(acc, a, true) end)
  end  

  def create(%{"post_id": post_id}, %{context: %{current_user: %{id: id}}}) do
    changeset = 
      %LikePost{} |> LikePost.create_changeset(%{post_id: post_id, user_id: id})

    case Repo.insert(changeset) do
      {:ok, _} -> 
        post = Repo.get!(Post, post_id)
        Post.like_changeset(post, %{like_count: post.like_count+1})
        |> Repo.update!
        {:ok, true}
      {:error, changeset} -> {:error, render_errors(changeset.errors)}
    end
  end

  def create(_,_), do: {:error, message: "user", detail: "Not logged in"}

  def delete(%{"post_id": post_id}, %{context: %{current_user: %{id: id}}}) do
    query = "like_posts"
    |> where([p], p.user_id == ^id)
    |> where([p], p.post_id == ^post_id) 

    case Repo.delete_all(query) do
      {1, _} -> 
        post = Repo.get!(Post, post_id)
        Post.like_changeset(post, %{like_count: post.like_count-1})
        |> Repo.update!
        {:ok, true}
      {0, _} -> {:error, message: "like didn't exist"}
    end
  end

  def delete(_,_), do: {:error, message: "user", detail: "Not logged in"}

  def remap_to_presence(results) do
    Enum.map(results,
      fn {_, key} ->
        %{}
        |> Map.put(key, true)
      end)
  end

  defp render_errors(errors) do
    Enum.map(errors, 
      fn {field, detail} -> 
        %{} 
        |> Map.put(:message, field) 
        |> Map.put(:details, render_detail(detail)) 
      end)
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc -> String.replace(acc, "%{#{k}}", to_string(v)) end)
  end

  defp render_detail(message) do
    message
  end
end