defmodule MeetingStories.Repo.Migrations.AddIndexToUserUid do
  use Ecto.Migration

  def change do
    create index(:users, [:uid])
  end
end
