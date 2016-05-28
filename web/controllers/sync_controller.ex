defmodule ConteurApp.SyncController do
  use ConteurApp.Web, :controller

  alias ConteurApp.Calendar
  alias ConteurApp.CalendarSync
  alias ConteurApp.Event
  alias ConteurApp.EventSync
  
  plug ConteurApp.Plug.Authenticate

  def calendars(conn, _params) do
    current_user = get_session(conn, :current_user)

    case CalendarSync.sync(current_user) do
      {:error, err_msg} -> conn |> put_flash(:error, err_msg)
      _ -> conn
    end
    |> redirect(to: "/app")
  end
  
  def calendar_events(conn, params) do
    current_user = get_session(conn, :current_user)
    cal_id = params["calendar_id"]
    
    if current_user && cal_id do
      EventSync.sync(current_user, cal_id)
    end

    conn |> redirect(to: "/app")
  end
end
