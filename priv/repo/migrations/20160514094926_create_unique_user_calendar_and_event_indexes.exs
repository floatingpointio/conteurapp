defmodule ConteurApp.Repo.Migrations.CreateUniqueUserCalendarAndEventIndexes do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:uid])
    create unique_index(:calendars, [:origin_id])
    create unique_index(:events, [:origin_id])
  end
end
