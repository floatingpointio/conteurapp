defmodule ConteurApp.EventTag do
  use ConteurApp.Web, :model

  schema "event_tags" do
    belongs_to :event, ConteurApp.Event
    belongs_to :tag, ConteurApp.Story

    timestamps
  end

  @required_fields ~w(event_id tag_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
