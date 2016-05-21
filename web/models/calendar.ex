defmodule ConteurApp.Calendar do
  use ConteurApp.Web, :model

  schema "calendars" do
    belongs_to :user, ConteurApp.User
    has_many :events, ConteurApp.Event
    has_many :stories, ConteurApp.Story

    field :origin_id, :string
    field :summary, :string
    field :time_zone, :string
    field :access_role, :string

    timestamps
  end

  @required_fields ~w(user_id origin_id summary time_zone)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:origin_id)
  end
end
