defmodule BlogqlElixir.UserResolver do
  alias BlogqlElixir.Repo
  alias BlogqlElixir.User
 
  def all(_args, _info) do
    {:ok, Repo.all(User)}
  end

  def find(%{id: id}, _info) do
    case Repo.get(User, id) do
      nil -> 
        {:ok, %{:errors => [%{:key => "id", :value => "User id #{id} not found"}]}}
      user -> 
        {:ok, %{:user => user}}
    end
  end

  def create(%{user: user_params}, _info) do
    user = %User{}
    |> User.registration_changeset(user_params)
    case Repo.insert(user) do
      {:ok, user } -> 
        {:ok, %{:user => user}}
      {:error, changeset} -> 
        errors = render_errors(changeset.errors)

        {:ok, %{:errors => errors}}
    end
  end

  def update(%{id: id, user: user_params}, %{context: %{current_user: current_user}}) do
    with user when not is_nil(user) <- Repo.get(User, id),
         true <- current_user.admin or current_user.id == user.id,
         changeset <- User.update_changeset(user, user_params),
         {:ok, user} <- Repo.update(changeset)
      do
        {:ok, %{:user => user}}
      else
        nil -> {:ok, %{:errors => [%{:key => "id", :value => "User id #{id} not found"}]}}
        false -> {:ok, %{:errors => [%{:key => "user", :value => "Not Authorized"}]}}
        {:error, changeset} -> {:ok, %{:errors => render_errors(changeset.errors)}}
    end

    # case Repo.get(User, id) do
    #   nil -> 
    #     {:ok, %{:errors => [%{:key => "id", :value => "User id #{id} not found"}]}}
    #   user ->
    #     changeset = User.update_changeset(user, user_params)
    #     case Repo.update(changeset) do
    #       {:ok, user} ->
    #         {:ok, %{:user => user}}
    #       {:error, changeset} ->
    #         errors = render_errors(changeset.errors)

    #         {:ok, %{:errors => errors}}
    #     end
    # end
  end

  def update(%{id: id, password: password_params}, %{context: %{current_user: current_user}}) do
    with user when not is_nil(user) <- Repo.get(User, id),
         true <- current_user.id == user.id,
         changeset <- User.password_changeset(user, password_params, user.password_hash),
         {:ok, user} <- Repo.update(changeset)
      do
        {:ok, %{:user => user}}
      else 
        nil -> {:ok, %{:errors => [%{:key => "id", :value => "User id #{id} not found"}]}}
        false -> {:ok, %{:errors => [%{:key => "user", :value => "Not Authorized"}]}}
        {:error, changeset} -> {:ok, %{:errors => render_errors(changeset.errors)}}       
      end
  end

  def login(params, _info) do
    with {:ok, user} <- BlogqlElixir.Session.authenticate(params, Repo),
         {:ok, jwt, _ } <- Guardian.encode_and_sign(user, :access) 
      do 
        {:ok, %{token: jwt}}
      else 
        _ -> {:ok, %{error: "Invalid Username or Password"}}
    end
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