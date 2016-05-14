defmodule MeetingStories.EventController do
  use MeetingStories.Web, :controller
  alias MeetingStories.User
  alias MeetingStories.Calendar
  alias MeetingStories.Event
  import Ecto.Query

  plug MeetingStories.Plug.Authenticate
  plug :scrub_params, "event" when action in [:create, :update]

  def index(conn, params) do
    current_user = conn.assigns.current_user
    cal_id = params["calendar_id"]

    query =
      Event
      |> join(:inner, [e], c in assoc(e, :calendar))
      |> join(:inner, [e, c], u in assoc(c, :user))
      |> where([e, c, u], u.id == ^current_user.id)
      |> preload([e, c, u], [:calendar])

      # |> if cal_id, do: where([e, c, u], e.calendar_id == ^cal_id), else: nil

    events = Repo.all(query)
    render(conn, "index.html", events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    render(conn, "show.html", event: event)
  end
end
