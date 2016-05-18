defmodule MeetingStories.SyncController do
  use MeetingStories.Web, :controller

  alias MeetingStories.CalendarFetcher
  alias MeetingStories.Calendar
  alias MeetingStories.CalendarSync
  alias MeetingStories.Event
  alias MeetingStories.EventSync
  
  plug MeetingStories.Plug.Authenticate

  def calendars(conn, _params) do
    current_user = get_session(conn, :current_user)

    if current_user do
      CalendarSync.sync(current_user.token)
    end

    conn |> redirect(to: "/calendars")
  end
  
  def calendar_events(conn, params) do
    current_user = get_session(conn, :current_user)
    cal_id = params["calendar_id"]
    
    if current_user && cal_id do
      EventSync.sync(current_user.token, cal_id)
    end

    conn |> redirect(to: "/calendars/#{cal_id}")
  end
end
