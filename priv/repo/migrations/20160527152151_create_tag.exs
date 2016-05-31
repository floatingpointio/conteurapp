defmodule ConteurApp.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string

      timestamps
    end

    create table(:tag_events) do
      add :event_id, references(:events, on_delete: :nothing), null: false
      add :tag_id, references(:tags, on_delete: :nothing), null: false

      timestamps
    end

    create index(:tags, [:name])
    create unique_index(:tag_events, [:tag_id, :event_id])
  end
end
