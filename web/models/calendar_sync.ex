defmodule ConteurApp.CalendarSync do
  alias ConteurApp.DataFetching
  alias ConteurApp.Calendar
  alias ConteurApp.Repo

  def sync(user) do
    case DataFetching.fetch_calendars(user.token) do
      %{"error" => err_data} -> report_error err_data
      %{"items" => calendars_raw} -> insert_calendars user, calendars_raw
    end
  end

  def insert_calendars(user, calendars_raw) do
    calendars = Enum.map calendars_raw, fn(cal) ->
      %Calendar{}
      |> Calendar.changeset(build_calendar(user, cal))
      |> Repo.insert()
    end

    ConteurApp.Endpoint.broadcast! "data:calendars", "new_calendars", %{calendars: calendars}
  end

  def build_calendar(user, cal) do
    %{
      user_id: user.id,
      origin_id: cal["id"],
      summary: cal["summary"],
      time_zone: cal["timeZone"],
      access_role: cal["accessRole"]
    }
  end

  def report_error(err_data) do
    {:error, "Failed to sync calendars"}
  end
end
