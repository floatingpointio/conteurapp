defmodule ConteurApp.Event do
  use ConteurApp.Web, :model

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

    timestamps
  end

  @required_fields ~w(calendar_id origin_id summary)
  @optional_fields ~w(description status origin_created_at origin_updated_at starts_at ends_at)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
