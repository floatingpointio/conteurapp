defmodule MeetingStories.SyncController do
  use MeetingStories.Web, :controller
  alias MeetingStories.CalendarFetcher

  alias MeetingStories.Calendar
  alias MeetingStories.Event

  def calendars(conn, _params) do
    current_user = get_session(conn, :current_user)

    if current_user do
      calendars = CalendarFetcher.fetch_calendars(current_user.token)

      for cal <- calendars["items"] do

        data = %{
          user_id: current_user.id,
          origin_id: cal["id"],
          summary: cal["summary"],
          time_zone: cal["timeZone"],
          access_role: cal["accessRole"]
        }

        %Calendar{}
        |> Calendar.changeset(data)
        |> Repo.insert()
      end
    end

    conn |> redirect(to: "/calendars")
  end
  
  def calendar_events(conn, params) do
    current_user = get_session(conn, :current_user)
    cal_id = params["calendar_id"]
    
    if current_user && cal_id do
      calendar = Repo.get!(Calendar, cal_id)
      events = CalendarFetcher.fetch_events(current_user.token, calendar.origin_id)

      for ev <- events["items"] do

        event = Repo.get_by(Event, origin_id: ev["id"])

        starts_at_raw = ev["start"]["dateTime"]
        ends_at_raw = ev["end"]["dateTime"]
        origin_created_at_raw = ev["created"]
        origin_updated_at_raw = ev["updated"]

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
          origin_id: ev["id"],
          summary: ev["summary"],
          status: ev["status"],
          origin_created_at: origin_created_at,
          origin_updated_at: origin_updated_at,
          starts_at: starts_at,
          ends_at: ends_at
        }

        case event do
          nil  -> %Event{}
          e -> e
        end
        |> Event.changeset(data)
        |> Repo.insert_or_update()
      end
    end

    conn |> redirect(to: "/calendars/#{cal_id}")
  end
  
end
