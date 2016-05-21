defmodule ConteurApp.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :calendar_id, references(:calendars, on_delete: :nothing), null: false
      add :origin_id, :string
      add :summary, :string
      add :status, :string
      add :origin_created_at, :datetime
      add :origin_updated_at, :datetime
      add :starts_at, :datetime
      add :ends_at, :datetime

      timestamps
    end

    create index(:events, [:calendar_id])
  end
end
