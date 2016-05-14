defmodule MeetingStories.Repo.Migrations.CreateCalendar do
  use Ecto.Migration

  def change do
    create table(:calendars) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :origin_id, :string
      add :summary, :string
      add :time_zone, :string
      add :access_role, :string

      timestamps
    end

    create index(:calendars, [:user_id])
  end
end
