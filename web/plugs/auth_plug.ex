defmodule MeetingStories.Plug.Authenticate do
  import Plug.Conn
  import MeetingStories.Router.Helpers
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, default) do
    current_user = get_session(conn, :current_user)

    if current_user do
      assign(conn, :current_user, current_user)
    else
      conn
        |> put_flash(:error, 'You need to be signed in proceed.')
        |> redirect(to: "/")
    end
  end
end
