defmodule BlogqlElixir.PostResolver do
  alias BlogqlElixir.Repo
  alias BlogqlElixir.Post
  import Ecto.Query, only: [where: 2]
  
  def all(%{"user_id": user_id}, _) do
    posts = Post
      |> where(user_id: ^user_id)
      |> Repo.all
    
    {:ok, posts}
  end

  def all(_args, _info) do
    posts = Repo.all(Post)
    {:ok, posts}
  end

  def find(%{"slug": slug}, _) do
    post = Repo.get_by(Post, slug: slug)

    {:ok, post}
  end

  def create(%{"post": post_params}, %{context: %{current_user: %{id: id}}}) do
    changeset = 
      %Post{} |> Post.changeset(Map.merge(post_params, %{user_id: id}))
    
    case Repo.insert(changeset) do
      {:ok, post} -> {:ok, %{:post => post}}
      {:error, changeset} -> {:ok, %{:errors => render_errors(changeset.errors)}}
    end
  end

  def create(_,_) do
    {:ok, %{:errors => [%{:key => "user", :value => "Not Authenticated"}]}}
  end

  def update(%{"post": post_params, "id": post_id}, %{context: %{current_user: current_user}}) do
    with post when not is_nil(post) <- Repo.get!(Post, post_id) 
                                         |> Repo.preload(:tags),
         true <- post.user_id == current_user.id or current_user.admin,
         changeset <- post |> Post.changeset(post_params),
         {:ok, post} <- Repo.update(changeset)
      do
        {:ok, %{:post => post}}
      else
        nil ->
          {:ok, %{:errors => [%{:key => "post", :value => "Post not found"}]}}
        false ->
          {:ok, %{:errors => [%{:key => "user", :value => "Not Authorized"}]}}
        {:error, changeset} ->
          {:ok, %{:errors => render_errors(changeset.errors)}}
    end
  end

  def update(_,_) do
    {:ok, %{:errors => [%{:key => "user", :value => "Not Authenticated"}]}}
  end

  def delete(%{:id => post_id}, %{context: %{current_user: current_user}}) do
    with post when not is_nil(post) <- Repo.get(Post, post_id),
         true <- post.user_id == current_user.id or current_user.admin,
         {:ok, _} <- Repo.delete(post)
      do
        {:ok, true}
      else
        _ -> {:ok, false}
    end
  end

  def delete(_, _) do
    {:error, false}
  end

  defp render_errors(errors) do
    Enum.map(errors, 
      fn {field, detail} -> 
        %{} 
        |> Map.put(:key, field) 
        |> Map.put(:value, render_detail(detail)) 
      end)
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc -> String.replace(acc, "%{#{k}}", to_string(v)) end)
  end

  defp render_detail(message) do
    message
  end

end