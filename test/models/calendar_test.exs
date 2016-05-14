defmodule MeetingStories.CalendarTest do
  use MeetingStories.ModelCase

  alias MeetingStories.Calendar

  @valid_attrs %{access_role: "some content", origin_id: "some content", summary: "some content", time_zone: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Calendar.changeset(%Calendar{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Calendar.changeset(%Calendar{}, @invalid_attrs)
    refute changeset.valid?
  end
end
