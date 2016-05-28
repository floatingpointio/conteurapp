defmodule ConteurApp.Repo.Migrations.AddDescToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :description, :text, default: ""
    end
  end
end
