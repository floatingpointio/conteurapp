defmodule ConteurApp.Api.EventController do
  use ConteurApp.Web, :controller
  alias ConteurApp.Calendar
  alias ConteurApp.Event
  alias ConteurApp.EventSync
  alias ConteurApp.Repo
  import Ecto.Query

  def index(conn, %{"calendar_id" => calendar_id} = params) do
    current_user = conn |> get_session(:current_user)
    calendar = Repo.get(Calendar, calendar_id)

    events_count_q = Event
      |> where([e], e.calendar_id == ^calendar_id)
      |> select([e], count(e.id))

    events_q =
      Event.with_tags_and_related_events
      |> where([e1, et1, et2, e2, t], e1.calendar_id == ^calendar_id)
      |> order_by([e1, et1, et2, e2, t], [desc: e1.ends_at, desc: e1.starts_at])

    events = if Repo.one(events_count_q) == 0 do
      Task.start fn -> EventSync.sync(current_user, calendar) end
      []
    else
      Repo.all(events_q)
    end

    render(conn, "index.json", events: events)
  end
  
  def index(conn, _params) do
    render(conn, "index.json", events: [])
  end

  defp apply_date_range(query, starts_at, ends_at) do
    query
    |> apply_after(starts_at)
    |> apply_before(ends_at)
  end

  defp apply_after(query, starts_at) do
    if starts_at do
      {:ok, starts_at} = Timex.parse(starts_at, "{YYYY}-{0M}-{D}")
      query |> where([e], e.starts_at >= ^starts_at)
    else
      query
    end
  end

  defp apply_before(query, ends_at) do
    if ends_at do
      {:ok, ends_at} = Timex.parse(ends_at, "{YYYY}-{0M}-{D}")
      query |> where([e], e.ends_at <= ^ends_at)
    else
      query
    end
  end
end
