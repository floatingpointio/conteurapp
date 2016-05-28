defmodule ConteurApp.EventSync do
  alias ConteurApp.DataFetching
  alias ConteurApp.TagExtraction
  alias ConteurApp.Calendar
  alias ConteurApp.Event
  alias ConteurApp.Tag
  alias ConteurApp.Repo
  alias ConteurApp.Endpoint
  alias ConteurApp.Api.EventView
  import ConteurApp.DataFetching, only: [fetch_events: 2]
  import ConteurApp.TagExtraction, only: [extract: 1]

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
    events = 
      events_raw
      |> Enum.map(&(insert_or_update_event(&1, calendar)))
      |> Enum.map(&push_event_over_chan/1)

    events
    |> Enum.map(&extract_and_insert_tags/1)
  end

  def insert_or_update_event(event_raw, calendar) do
    event = Repo.get_by(Event, origin_id: event_raw["id"])
    data = build_event(event_raw, calendar)

    case event  do
      nil -> %Event{}
      _ -> data
    end
    |> Event.changeset(data)
    |> Repo.insert_or_update!
  end

  def push_event_over_chan(event) do
    Endpoint.broadcast! "data:events", "new_event", EventView.as_json(event)
    event
  end

  def extract_and_insert_tags(event) do
    tags = TagExtraction.extract(event)

    tags
    |> Enum.filter(fn(t) -> t != [] end)
    |> Enum.map(fn(t) ->

      tag = Repo.get_by(Tag, name: t)
      data = %{name: t}

      case tag do
        nil -> %Tag{}
        _ -> data
      end
      |> Tag.changeset(data)
      |> Repo.insert_or_update!
    end)
  end

  def build_event(event_raw, calendar) do
    %{
      calendar_id: calendar.id,
      origin_id: event_raw["id"],
      summary: event_raw["summary"],
      description: event_raw["description"] || "",
      status: event_raw["status"],
      origin_created_at: to_ts(event_raw["created"]),
      origin_updated_at: to_ts(event_raw["updated"]),
      starts_at: to_ts(event_raw["start"]["dateTime"]),
      ends_at: to_ts(event_raw["end"]["dateTime"])
    }
  end

  defp to_ts(iso_datetime) when not is_nil(iso_datetime) do
    Timex.parse!(iso_datetime, "{ISO:Extended}")
  end

  defp to_ts(nil) do
    nil
  end
  
  def report_error(err_data) do
    Logger.warn "Failed to sync events"
    {:error, "Failed to sync events"}
  end
end
