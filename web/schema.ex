defmodule BlogqlElixir.Schema do
  use Absinthe.Schema
  import_types BlogqlElixir.Schema.Types
 
  query do
    field :posts, list_of(:post) do
      arg :user_id, :id
      arg :limit, :integer, default_value: 10

      resolve &BlogqlElixir.PostResolver.all/2
    end

    field :post, type: :post do
      arg :post_id, non_null(:id)

      resolve &BlogqlElixir.PostResolver.find/2
    end
 
    field :users, list_of(:user) do
      arg :limit, :integer, default_value: 10

      resolve &BlogqlElixir.UserResolver.all/2
    end

    field :user, type: :user_result do
      arg :id, non_null(:id)

      resolve &BlogqlElixir.UserResolver.find/2
    end
  end

  mutation do
    field :create_post, type: :post_result do
      arg :post, non_null(:post_params)

      resolve &BlogqlElixir.PostResolver.create/2
    end

    field :update_post, type: :post_result do
      arg :id, non_null(:integer)
      arg :post, non_null(:post_params)

      resolve &BlogqlElixir.PostResolver.update/2
    end

    field :delete_post, type: :boolean do
      arg :id, non_null(:integer)

      resolve &BlogqlElixir.PostResolver.delete/2
    end

    field :create_user, type: :user_result do
      arg :user, non_null(:create_user_params)

      resolve &BlogqlElixir.UserResolver.create/2
    end

    field :update_user, type: :user_result do
      arg :id, non_null(:integer)
      arg :user, non_null(:update_user_params)
  
      resolve &BlogqlElixir.UserResolver.update/2
    end

    field :update_user_password, type: :user_result do
      arg :id, non_null(:integer)
      arg :password, non_null(:update_user_password_params)

      resolve &BlogqlElixir.UserResolver.update/2
    end

    field :create_comment, type: :comment_result do
      arg :post_id, non_null(:integer)
      arg :comment, non_null(:comment_params)

      resolve &BlogqlElixir.CommentResolver.create/2
    end

    field :update_comment, type: :comment_result do
      arg :comment_id, non_null(:integer)
      arg :comment, non_null(:comment_params)

      resolve &BlogqlElixir.CommentResolver.update/2
    end

    field :delete_comment, type: :boolean do
      arg :comment_id, non_null(:integer)

      resolve &BlogqlElixir.CommentResolver.delete/2
    end

    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
  
      resolve &BlogqlElixir.UserResolver.login/2
    end
    
  end
end