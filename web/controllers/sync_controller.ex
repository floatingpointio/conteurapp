defmodule ConteurApp.SyncController do
  use ConteurApp.Web, :controller

  alias ConteurApp.Calendar
  alias ConteurApp.CalendarSync
  alias ConteurApp.Event
  alias ConteurApp.EventSync
  alias ConteurApp.PostbackRegistration
  alias ConteurApp.Repo
  
  plug ConteurApp.Plug.Authenticate

  def calendars(conn, _params) do
    current_user = get_session(conn, :current_user)

    case CalendarSync.sync(current_user) do
      {:error, err_msg} -> conn |> put_flash(:error, err_msg)
      _ -> conn
    end
    |> redirect(to: "/app")
  end
  
  def calendar_events(conn, %{"calendar_id" => calendar_id} = params) do
    current_user = get_session(conn, :current_user)
    calendar = Repo.get(Calendar, calendar_id)
    
    if current_user && calendar do
      Task.start fn -> EventSync.sync(current_user, calendar.id) end
      Task.start fn -> PostbackRegistration.watch_events(current_user, calendar) end
    end

    conn |> redirect(to: "/app")
  end
end
