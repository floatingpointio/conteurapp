defmodule ConteurApp.Tag do
  use ConteurApp.Web, :model

  schema "tags" do
    field :name, :string
    has_many :tag_events, ConteurApp.TagEvent

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
