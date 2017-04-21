# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BlogqlElixir.Repo.insert!(%BlogqlElixir.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BlogqlElixir.User
alias BlogqlElixir.Post
alias BlogqlElixir.Comment
alias BlogqlElixir.Repo

%User{}
|> User.registration_changeset(%{username: "admin", email: "admin@admin.com", password: "horriblethings", password_confirmation: "horriblethings"})
|> Repo.insert!

for _ <- 1..5 do
  %User{}
  |> User.registration_changeset(%{username: Faker.Name.first_name, email: Faker.Internet.safe_email, password: "1234", password_confirmation: "1234"})
  |> Repo.insert!
end
 
for _ <- 1..15 do
  %Post{}
  |> Post.changeset(%{
    title: Faker.Lorem.sentence,
    body: Faker.Lorem.paragraph,
    user_id: [2, 3, 4, 5, 6] |> Enum.take_random(1) |> hd
  })
  |> Repo.insert!
end

for _ <- 1..60 do
  Repo.insert!(%Comment{
    body: Faker.Lorem.paragraph,
    user_id: [2, 3, 4, 5, 6] |> Enum.take_random(1) |> hd,
    post_id: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] |> Enum.take_random(1) |> hd
  })
end