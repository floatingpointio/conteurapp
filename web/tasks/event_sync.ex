defmodule ConteurApp.EventSync do
  alias ConteurApp.DataFetching
  alias ConteurApp.StoryBuilding
  alias ConteurApp.Calendar
  alias ConteurApp.Event
  alias ConteurApp.Repo
  alias ConteurApp.Endpoint
  alias ConteurApp.Api.EventView
  import ConteurApp.DataFetching, only: [fetch_events: 2]
  import ConteurApp.TagExtraction, only: [extract: 1]
  import Ecto.Query

  require Logger

  def sync(user, cal_id) do
    calendar = Repo.get(Calendar, cal_id)

    case calendar do
      %{:origin_id => origin_id} ->
        case fetch_events(user.token, calendar.origin_id) do
          %{"error" => err_data} -> report_error(err_data)
          %{"items" => events_raw} -> insert_and_push_events(events_raw, calendar)
        end
      nil ->
        Logger.warn "No such calendar: Requested calendar ID #{cal_id}"
    end
  end

  def insert_and_push_events(events_raw, calendar) do
    events = Enum.map(events_raw, &(insert_or_update_event(&1, calendar)))
 
    Task.start fn -> push_events_over_chan(events) end
    Task.start fn -> StoryBuilding.taggify_events(events) end
  end

  def insert_or_update_event(event_raw, calendar) do
    event = Repo.get_by(Event, origin_id: event_raw["id"])
    data = build_event(event_raw, calendar)

    case event do
      nil -> %Event{}
      exevent -> exevent
    end
    |> Event.changeset(data)
    |> Repo.insert_or_update!
  end

  def push_events_over_chan(events) do
    for e <- events do
      Endpoint.broadcast! "data:events", "new_event", EventView.as_json(e, [])
    end
  end

  def build_event(event_raw, calendar) do
    IO.inspect event_raw
    %{
      calendar_id: calendar.id,
      origin_id: event_raw["id"],
      summary: event_raw["summary"],
      description: event_raw["description"] || "",
      status: event_raw["status"],
      origin_created_at: convert_ts(event_raw["created"]),
      origin_updated_at: convert_ts(event_raw["updated"]),
      starts_at: cascading_convert_ts(event_raw["start"], :start),
      ends_at: cascading_convert_ts(event_raw["end"], :end)
    }
  end

  defp cascading_convert_ts(%{"date" => date}, :start) do
    Timex.parse!(date, "{YYYY}-{0M}-{D}")
  end
  
  defp cascading_convert_ts(%{"date" => date}, :end) do
    Timex.parse!(date, "{YYYY}-{0M}-{D}")
    |> Timex.add({0, 86399, 0})
  end
  
  defp cascading_convert_ts(%{"dateTime" => datetime}, _) do
    Timex.parse!(datetime, "{ISO:Extended}")
  end

  defp convert_ts(nil), do: nil
  defp convert_ts(iso_datetime) when not is_nil(iso_datetime) do
    Timex.parse!(iso_datetime, "{ISO:Extended}")
  end

  def report_error(err_data) do
    Logger.warn "Failed to sync events"
    {:error, "Failed to sync events"}
  end
end
