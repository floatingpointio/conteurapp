defmodule MeetingStories.Story do
  use MeetingStories.Web, :model

  schema "stories" do
    belongs_to :calendar, MeetingStories.Calendar
    has_many :story_events, MeetingStories.StoryEvent
    has_many :events, through: [:story_events, :event]
    field :description, :string

    timestamps
  end

  @required_fields ~w(calendar_id description)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
