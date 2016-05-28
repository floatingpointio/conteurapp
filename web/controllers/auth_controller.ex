defmodule ConteurApp.AuthController do
  use ConteurApp.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias ConteurApp.UserFromAuth
  alias ConteurApp.CalendarSync

  def request(conn, _params) do
    IO.inspect conn
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    IO.inspect params
    IO.inspect auth

    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        Task.start(CalendarSync, :sync, [user])

        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> redirect(to: "/app")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
