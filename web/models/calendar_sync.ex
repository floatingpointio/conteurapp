defmodule MeetingStories.CalendarSync do

  def sync(user) do
    resp = CalendarFetcher.fetch_calendars(user.token)
    insert_calendars user, resp["items"]
  end

  def insert_calendars(user, calendars_raw) do
    Enum.map calendars_raw, fn(cal) ->
      %Calendar{}
      |> Calendar.changeset(build_calendar(user, cal))
      |> Repo.insert()
    end
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
end
