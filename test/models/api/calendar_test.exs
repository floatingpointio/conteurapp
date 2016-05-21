defmodule ConteurApp.Api.CalendarTest do
  use ConteurApp.ModelCase

  alias ConteurApp.Api.Calendar

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Calendar.changeset(%Calendar{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Calendar.changeset(%Calendar{}, @invalid_attrs)
    refute changeset.valid?
  end
end
