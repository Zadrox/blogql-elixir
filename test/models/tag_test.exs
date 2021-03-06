defmodule BlogqlElixir.TagTest do
  use BlogqlElixir.ModelCase

  alias BlogqlElixir.Tag

  @valid_attrs %{tag: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
