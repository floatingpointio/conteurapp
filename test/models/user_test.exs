defmodule MeetingStories.UserTest do
  use MeetingStories.ModelCase

  alias MeetingStories.User

  @valid_attrs %{avatar: "some content", email: "some content", name: "some content", token: "some content", uid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
