defmodule MeetingStories.Api.CalendarController do
  use MeetingStories.Web, :controller

  alias MeetingStories.Calendar
  alias MeetingStories.Event
  import Ecto.Query

  # plug :scrub_params, "calendar" when action in [:create, :update]

  def events(conn, %{"calendar_id" => id} = params) do
    events_query =
      Event
      |> join(:inner, [e], c in assoc(e, :calendar))
      |> where([e, c], not(is_nil(e.starts_at)) and not(is_nil(e.ends_at)))
      |> where([e, c], e.calendar_id == ^id)
      |> apply_date_range(params["start"], params["end"])

    events = Repo.all(events_query)

    filtered_events = Enum.map(events, &summarize_event/1)

    json(conn, filtered_events)
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

  defp summarize_event(event) do
    %{
      id: event.id,
      origin_id: event.origin_id,
      title: event.summary,
      start: format_iso8601(event.starts_at),
      end: format_iso8601(event.ends_at)
    }
  end

  defp format_iso8601(datetime) do
    {:ok, dt} = Timex.Ecto.DateTime.dump datetime
    Timex.format!(dt, "{ISO:Extended}")
  end
end
