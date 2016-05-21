defmodule ConteurApp.Repo.Migrations.CreateApi.Calendar do
  use Ecto.Migration

  def change do
    create table(:calendars) do

      timestamps
    end

  end
end
