defmodule MeetingStories.Calendar do
  use MeetingStories.Web, :model

  schema "calendars" do
    belongs_to :user, ChargingIo.User

    field :origin_id, :string
    field :summary, :string
    field :time_zone, :string
    field :access_role, :string

    timestamps
  end

  @required_fields ~w(user_id origin_id summary time_zone)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:origin_id)
  end
end
