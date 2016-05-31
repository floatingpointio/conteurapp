defmodule ConteurApp.Event do
  use ConteurApp.Web, :model
  alias ConteurApp.Event
  alias ConteurApp.TagEvent
  alias ConteurApp.Tag
  alias ConteurApp.Repo
  import Ecto.Query

  schema "events" do
    belongs_to :calendar, ConteurApp.Calendar

    field :origin_id, :string
    field :summary, :string
    field :description, :string
    field :status, :string
    field :origin_created_at, Timex.Ecto.DateTime
    field :origin_updated_at, Timex.Ecto.DateTime
    field :starts_at, Timex.Ecto.DateTime
    field :ends_at, Timex.Ecto.DateTime

    has_many :tag_events, ConteurApp.TagEvent
    has_many :tags, through: [:tag_events, :tag]
    has_many :events, through: [:tag_events, :event]

    timestamps
  end

  @required_fields ~w(calendar_id origin_id summary)
  @optional_fields ~w(description status origin_created_at origin_updated_at starts_at ends_at)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def with_tags do
    Event
    |> join(:left, [e], et in assoc(e, :tag_events))
    |> join(:left, [e, et], t in assoc(et, :tag))
    |> preload([e, et, t], [tags: t])
  end

  def with_related_events do
    Event
    |> join(:left, [e1], et1 in TagEvent, e1.id == et1.event_id)
    |> join(:left, [e1, et1], et2 in TagEvent, et1.tag_id == et2.tag_id)
    |> join(:left, [e1, et1, et2], e2 in Event, et2.event_id == e2.id)
    |> join(:left, [e1, et1, et2, e2], t in Tag, et1.tag_id == t.id)
    |> where([e1, et1, et2, e2], e1.id != e2.id or is_nil(e2.id))
  end
  
  def with_tags_and_related_events do
    with_related_events
    |> preload([e1, et1, et2, e2, t], [tags: t, events: e2])
  end
end
