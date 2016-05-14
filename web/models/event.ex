defmodule MeetingStories.Event do
  use MeetingStories.Web, :model

  schema "events" do
    field :calendar_id, :integer
    field :origin_id, :string
    field :summary, :string
    field :status, :string
    field :origin_created_at, Ecto.DateTime
    field :origin_updated_at, Ecto.DateTime
    field :starts_at, Ecto.DateTime
    field :ends_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(calendar_id origin_id summary status origin_created_at origin_updated_at starts_at ends_at)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
