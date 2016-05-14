defmodule MeetingStories.CalendarController do
  use MeetingStories.Web, :controller

  alias MeetingStories.Calendar
  alias MeetingStories.Event
  alias MeetingStories.CalendarFetcher

  plug :scrub_params, "calendar" when action in [:create, :update]

  def index(conn, _params) do
    calendars = Repo.all(Calendar)
    render(conn, "index.html", calendars: calendars)
  end

  def fetch(conn, _params) do
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

  def pick(conn, params) do
    current_user = get_session(conn, :current_user)
    cal_id = params["cal_id"]
    
    if current_user && cal_id do
      calendar = Repo.get!(Calendar, cal_id)
      events = CalendarFetcher.fetch_events(current_user.token, calendar.origin_id)

      for ev <- events["items"] do

        event = Repo.get_by(Event, origin_id: ev["id"])

        starts_at_raw = ev["start"]["dateTime"]
        ends_at_raw = ev["end"]["dateTime"]
        origin_created_at_raw = ev["created"]
        origin_updated_at_raw = ev["updated"]

        if origin_created_at_raw do
          {:ok, origin_created_at } = Timex.parse(origin_created_at_raw, "{ISO:Extended}")
        else
          origin_created_at = nil
        end

        if origin_updated_at_raw do
          {:ok, origin_updated_at } = Timex.parse(origin_updated_at_raw, "{ISO:Extended}")
        else
          origin_updated_at = nil
        end

        if starts_at_raw do
          {:ok, starts_at }   = Timex.parse(starts_at_raw, "{ISO:Extended}")
        else
          starts_at = nil
        end

        if ends_at_raw do
          {:ok, ends_at }   = Timex.parse(ends_at_raw, "{ISO:Extended}")
        else
          ends_at = nil
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
    conn |> redirect(to: "/events")
  end

  def new(conn, _params) do
    changeset = Calendar.changeset(%Calendar{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"calendar" => calendar_params}) do
    changeset = Calendar.changeset(%Calendar{}, calendar_params)

    case Repo.insert(changeset) do
      {:ok, _calendar} ->
        conn
        |> put_flash(:info, "Calendar created successfully.")
        |> redirect(to: calendar_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    calendar = Repo.get!(Calendar, id)
    render(conn, "show.html", calendar: calendar)
  end

  def edit(conn, %{"id" => id}) do
    calendar = Repo.get!(Calendar, id)
    changeset = Calendar.changeset(calendar)
    render(conn, "edit.html", calendar: calendar, changeset: changeset)
  end

  def update(conn, %{"id" => id, "calendar" => calendar_params}) do
    calendar = Repo.get!(Calendar, id)
    changeset = Calendar.changeset(calendar, calendar_params)

    case Repo.update(changeset) do
      {:ok, calendar} ->
        conn
        |> put_flash(:info, "Calendar updated successfully.")
        |> redirect(to: calendar_path(conn, :show, calendar))
      {:error, changeset} ->
        render(conn, "edit.html", calendar: calendar, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    calendar = Repo.get!(Calendar, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(calendar)

    conn
    |> put_flash(:info, "Calendar deleted successfully.")
    |> redirect(to: calendar_path(conn, :index))
  end
end
