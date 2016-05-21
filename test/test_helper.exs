ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ConteurApp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ConteurApp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ConteurApp.Repo)

