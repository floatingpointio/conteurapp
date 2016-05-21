defmodule ConteurApp.PageController do
  use ConteurApp.Web, :controller
  
  plug ConteurApp.Plug.Authenticate when action in [:app]

  def landing(conn, _params) do
    user = get_session(conn, :current_user)

    conn
    |> put_layout("landing.html")
    |> render("landing.html", current_user: user)
  end

  def app(conn, _params) do
    user = get_session(conn, :current_user)

    conn
    |> put_layout("app.html")
    |> render("app.html", current_user: user)
  end
end
