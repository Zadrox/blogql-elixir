defmodule BlogqlElixir.User do
  use BlogqlElixir.Web, :model
  
  import Comeonin.Bcrypt, only: [hashpwsalt: 1, checkpw: 2]

  schema "users" do
    field :name, :string
    field :email, :string
    field :username, :string
    field :admin, :boolean, default: false
    field :bio, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :current_password, :string, virtual: true
    field :password_hash, :string
    
    has_many :posts, BlogqlElixir.Post
    many_to_many :likes, BlogqlElixir.Post, join_through: BlogqlElixir.LikePost

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :bio, :username, :name])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/@/, message: "Email is not valid format")
    |> validate_format(:username, ~r/^[a-z\d]{4,}$/i, message: "Username contains invalid characters")
    |> unique_constraint(:username, name: :users_username_index)
    |> unique_constraint(:email, name: :users_email_index)
  end
 
  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :password_confirmation, :username])
    |> validate_required([:username, :email, :password, :password_confirmation])
    |> validate_confirmation(:password, message: "Passwords do not match")
    |> validate_format(:email, ~r/@/, message: "Email is not valid format")
    |> validate_format(:username, ~r/^[a-z\d]{3,}$/i, message: "Username contains invalid characters")
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:username, name: :users_username_index)
    |> put_pass_hash
  end

  def password_changeset(struct, params \\ %{}, password_hash) do
    struct
    |> cast(params, [:password, :password_confirmation, :current_password])
    |> validate_required([:password, :password_confirmation, :current_password])
    |> validate_current_pass(password_hash)
    |> validate_confirmation(:password, message: "New passwords do not match")
    |> put_pass_hash
  end

  defp validate_current_pass(changeset, password_hash) do
    case checkpw(get_change(changeset, :current_password), password_hash) do
      true -> changeset
      _ -> add_error(changeset, :current_password, "Current password does not match")
    end
  end

  defp put_pass_hash(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_hash, hashpwsalt(password))
    else
      changeset
    end
  end
end
