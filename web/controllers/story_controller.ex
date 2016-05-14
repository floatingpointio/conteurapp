defmodule MeetingStories.StoryController do
  use MeetingStories.Web, :controller

  alias MeetingStories.Story
  alias MeetingStories.StoryEvent

  plug MeetingStories.Plug.Authenticate

  def index(conn, _params) do
    stories = Repo.all(Story)
    render(conn, "index.json", stories: stories)
  end

  def index(conn, %{"calendar_id" => calendar_id}) do
    calendar = Repo.get!(Calendar, calendar_id)
    render(conn, "index.json", stories: calendar.stories)
  end
  
  def show(conn, %{"id" => id}) do
    story = Repo.get!(Story, id) |> Repo.preload(:events)
    event_ids = Enum.map story.events, fn(e) -> e.id end

    render(conn, "story.json", story: story, event_ids: event_ids)
  end

  def create(conn, %{"story" => story_params}) do
    story_data = %Story{
      calendar_id: story_params["calendar_id"],
      description: story_params["description"]
    }

    story_events_data = Enum.map story_params["event_ids"], fn(ev_id) ->
      %StoryEvent{event_id: ev_id}
    end
    
    result = Repo.transaction(fn ->
      case (story_data |> Story.changeset(%{}) |> Repo.insert) do
        {:ok, story } -> {story, Enum.map(story_events_data, fn(sed) ->
            case sed |> StoryEvent.changeset(%{story_id: story.id}) |> Repo.insert do
              {:ok, story_event} -> {:ok, story_event}
              {:error, reason} -> {:error, reason}
            end
        end)}
        {:error, reason} -> {:error, reason}
      end
    end)

    case result do
      {:ok, {story, stories}} ->

        event_ids = Enum.map stories, fn(tup) -> 
          {:ok, ev} = tup
          ev.id
        end

        conn
        |> put_status(:created)
        |> put_resp_header("location", story_path(conn, :show, story))
        |> render("story.json", story: story, event_ids: event_ids)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MeetingStories.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "story" => story_params}) do
    # TODO
    text conn, "OK"
  end

  def delete(conn, %{"id" => id}) do
    # TODO
    text conn, "OK"
  end
end
