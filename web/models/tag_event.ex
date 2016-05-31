defmodule ConteurApp.TagEvent do
  use ConteurApp.Web, :model

  schema "tag_events" do
    belongs_to :tag, ConteurApp.Tag
    belongs_to :event, ConteurApp.Event

    timestamps
  end

  @required_fields ~w(tag_id event_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end


