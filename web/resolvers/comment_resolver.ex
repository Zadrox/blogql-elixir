defmodule BlogqlElixir.CommentResolver do
  alias BlogqlElixir.Repo
  alias BlogqlElixir.Comment

  def create(%{"comment": comment_params, "post_id": post_id}, 
    %{context: %{current_user: %{id: id}}}) do
    
    changeset = 
      %Comment{} |> Comment.changeset(Map.merge(comment_params, %{user_id: id, post_id: post_id}))
    
    case Repo.insert(changeset) do
      {:ok, comment} -> {:ok, %{:comment => comment}}
      {:error, changeset} -> {:ok, %{:errors => render_errors(changeset.errors)}}
    end
  end

  def create(_,_), do: {:error, "Not Authenticated"}

  def update(%{"comment": comment_params, "comment_id": comment_id}, 
    %{context: %{current_user: current_user}}) do
    
    with comment when not is_nil(comment) <- Repo.get(Comment, comment_id),
         true <- comment.user_id == current_user.id or current_user.admin,
         changeset <- comment |> Comment.changeset(comment_params),
         {:ok, comment} <- Repo.update(changeset)
      do
        {:ok, %{:comment => comment}}
      else
        nil -> 
          {:ok, %{:errors => [%{:key =>  "comment", :value => "Comment not found"}]}}
        false -> 
          {:ok, %{:errors => [%{:key => "user", :value => "Not Authorized"}]}}
        {:error, changeset} ->
          {:ok, %{:errors => render_errors(changeset.errors)}}
      end
  end

  def update(_,_), do: {:error, "Not Authenticated"}

  def delete(%{"comment_id": comment_id}, 
    %{context: %{current_user: current_user}}) do
      
    with comment when not is_nil(comment) <- Repo.get(Comment, comment_id),
         true <- comment.user_id == current_user.id or current_user.admin,
         {:ok, _} <- Repo.delete(comment)
      do
        {:ok, true}
      else
        _ -> {:ok, false}
    end
  end

  def delete(_,_), do: {:error, "Not Authenticated"}

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
