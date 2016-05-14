defmodule MeetingStories.EventTest do
  use MeetingStories.ModelCase

  alias MeetingStories.Event

  @valid_attrs %{calendar_id: 42, ends_at: "2010-04-17 14:00:00", origin_created_at: "2010-04-17 14:00:00", origin_id: "some content", origin_updated_at: "2010-04-17 14:00:00", starts_at: "2010-04-17 14:00:00", status: "some content", summary: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
