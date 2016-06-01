defmodule ConteurApp.Api.PostbackController do
  use ConteurApp.Web, :controller

  def hi(conn, _params) do
    text(conn, "you're on the right place")
  end

  def handle_event(conn, params) do
    IO.inspect conn
    IO.inspect params
    json conn, %{msg: "ok"}
  end

  def handle_calendar(conn, params) do
    IO.inspect conn
    IO.inspect params
    json conn, %{msg: "ok"}
  end
end
