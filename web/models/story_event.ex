defmodule ConteurApp.StoryEvent do
  use ConteurApp.Web, :model

  schema "story_events" do
    belongs_to :story, ConteurApp.Story
    belongs_to :event, ConteurApp.Event

    timestamps
  end

  @required_fields ~w(story_id event_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
