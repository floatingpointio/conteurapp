defmodule MeetingStories.Repo.Migrations.CreateStory do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :calendar_id, references(:calendars, on_delete: :nothing), null: false
      add :description, :string

      timestamps
    end

    create table(:story_events) do
      add :story_id, references(:stories, on_delete: :nothing), null: false
      add :event_id, references(:events, on_delete: :nothing), null: false

      timestamps
    end

    create index(:stories, [:calendar_id])
    create unique_index(:story_events, [:story_id, :event_id])
  end
end
