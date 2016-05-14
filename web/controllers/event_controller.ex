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

  def new(conn, _params) do
    changeset = Event.changeset(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    changeset = Event.changeset(%Event{}, event_params)

    case Repo.insert(changeset) do
      {:ok, _event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    changeset = Event.changeset(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Repo.get!(Event, id)
    changeset = Event.changeset(event, event_params)

    case Repo.update(changeset) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: event_path(conn, :index))
  end
end
