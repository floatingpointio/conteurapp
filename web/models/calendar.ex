defmodule MeetingStories.Calendar do
  use MeetingStories.Web, :model

  schema "calendars" do
    field :origin_id, :string
    field :summary, :string
    field :time_zone, :string
    field :access_role, :string

    timestamps
  end

  @required_fields ~w(origin_id summary time_zone access_role)
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
