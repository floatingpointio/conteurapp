defmodule ConteurApp.EventSync do
  alias ConteurApp.DataFetching
  alias ConteurApp.Calendar
  alias ConteurApp.Event
  alias ConteurApp.Repo

  def sync(user, cal_id) do
    calendar = Repo.get!(Calendar, cal_id)
    resp = DataFetching.fetch_events(user.token, calendar.origin_id)
    insert_events calendar, resp["items"]
  end

  def insert_events(calendar, events_raw) do
    Enum.map events_raw, fn(ev_raw) ->
      event = Repo.get_by(Event, origin_id: ev_raw["id"])
      data = build_event(calendar, ev_raw)

      if event == nil, do: %Event{}, else: data
      |> Event.changeset(data)
      |> Repo.insert_or_update()
    end
  end

  def build_event(calendar, ev_raw) do
    starts_at_raw = ev_raw["start"]["dateTime"]
    ends_at_raw = ev_raw["end"]["dateTime"]
    origin_created_at_raw = ev_raw["created"]
    origin_updated_at_raw = ev_raw["updated"]

    origin_created_at = if origin_created_at_raw do
      {:ok, res } = Timex.parse(origin_created_at_raw, "{ISO:Extended}")
      res
    end

    origin_updated_at = if origin_updated_at_raw do
      {:ok, res } = Timex.parse(origin_updated_at_raw, "{ISO:Extended}")
      res
    end

    starts_at = if starts_at_raw do
      {:ok, res } = Timex.parse(starts_at_raw, "{ISO:Extended}")
      res
    end

    ends_at = if ends_at_raw do
      {:ok, res } = Timex.parse(ends_at_raw, "{ISO:Extended}")
      res
    end

    data = %{
      calendar_id: calendar.id,
      origin_id: ev_raw["id"],
      summary: ev_raw["summary"],
      status: ev_raw["status"],
      origin_created_at: origin_created_at,
      origin_updated_at: origin_updated_at,
      starts_at: starts_at,
      ends_at: ends_at
    }
  end
end
