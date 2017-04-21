defmodule BlogqlElixir.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: BlogqlElixir.Repo

  object :session do
    field :token, :string
    field :error, :string
  end

  object :user do
    field :id, :id
    field :name, :string
    field :bio, :string
    field :username, :string
    field :posts, list_of(:post), resolve: assoc(:posts)
  end

  object :me_user do
    field :id, :id
    field :email, :string
    field :name, :string
    field :bio, :string
    field :username, :string
    field :posts, list_of(:post), resolve: assoc(:posts)
  end
 
  object :post do
    field :id, :id
    field :title, :string
    field :body, :string
    field :slug, :string
    field :inserted_at, :float
    field :updated_at, :float
    field :user, :user, resolve: assoc(:user)
    field :comments, list_of(:comment), resolve: assoc(:comments)
  end

  object :comment do
    field :id, :id
    field :body, :string
    field :inserted_at, :float
    field :updated_at, :float
    field :user, :user, resolve: assoc(:user)
    field :post, :post, resolve: assoc(:post)
  end

  object :error do
    field :key, :string
    field :value, :string
  end

  object :post_result do
    field :post, :post
    field :errors, list_of(non_null(:error))
  end

  object :user_result do
    field :user, :user
    field :errors, list_of(non_null(:error))
  end

  object :me_result do
    field :user, :me_user
    field :errors, list_of(non_null(:error))
  end

  object :comment_result do
    field :comment, :comment
    field :errors, list_of(non_null(:error))
  end
  
  input_object :post_params do
    field :title, :string
    field :body, :string
  end

  input_object :create_user_params do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
    field :username, non_null(:string)
  end

  input_object :update_user_params do
    field :name, :string
    field :email, :string
    field :username, :string
    field :bio, :string
    field :password, :string
  end

  input_object :update_user_password_params do
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
    field :current_password, non_null(:string)
  end

  input_object :comment_params do
    field :body, non_null(:string)
  end

end