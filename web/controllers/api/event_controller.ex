defmodule ConteurApp.Api.EventController do
  use ConteurApp.Web, :controller
  alias ConteurApp.Calendar
  alias ConteurApp.Event
  alias ConteurApp.EventSync
  import Ecto.Query

  def index(conn, %{"calendar_id" => calendar_id} = params) do
    current_user = conn |> get_session(:current_user)

    events_count_q = Event
      |> where([e], e.calendar_id == ^calendar_id)
      |> select([e], count(e.id))

    events_q = Event
      |> where([e], e.calendar_id == ^calendar_id)
      |> order_by([e], [asc: e.starts_at, asc: e.ends_at])

    events = if Repo.one(events_count_q) == 0 do
      Task.start(EventSync, :sync, [current_user, calendar_id])
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
