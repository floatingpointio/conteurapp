defmodule MeetingStories.StoryEvent do
  use MeetingStories.Web, :model

  schema "story_events" do
    belongs_to :story, MeetingStories.Story
    belongs_to :event, MeetingStories.Event

    timestamps
  end

  @required_fields ~w(story_id event_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
