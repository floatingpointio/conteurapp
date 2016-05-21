defmodule ConteurApp.Api.EventController do
  use ConteurApp.Web, :controller

  alias ConteurApp.Calendar
  alias ConteurApp.Event
  import Ecto.Query

  # plug :scrub_params, "calendar" when action in [:create, :update]

  def index(conn, params) do
    id = params["calendar_id"] || 3

    events_query =
      Event
      |> join(:inner, [e], c in assoc(e, :calendar))
      |> where([e, c], not(is_nil(e.starts_at)) and not(is_nil(e.ends_at)))
      |> where([e, c], e.calendar_id == ^id)
      |> apply_date_range(params["start"], params["end"])

    events = Repo.all(events_query)

    # filtered_events = Enum.map(events, &summarize_event/1)

    render(conn, "index.json", events: events)
  end

  defp apply_date_range(query, starts_at, ends_at) do
    query
    |> apply_after(starts_at)
    |> apply_before(ends_at)
  end

  defp apply_after(query, starts_at) do
    if starts_at do
      {:ok, starts_at} = Timex.parse(starts_at, "{YYYY}-{0M}-{D}")
      query |> where([e, c], e.starts_at >= ^starts_at)
    else
      query
    end
  end

  defp apply_before(query, ends_at) do
    if ends_at do
      {:ok, ends_at} = Timex.parse(ends_at, "{YYYY}-{0M}-{D}")
      query |> where([e, c], e.ends_at <= ^ends_at)
    else
      query
    end
  end
end
