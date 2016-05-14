defmodule MeetingStories.Router do
  use MeetingStories.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
  end

  scope "/", MeetingStories do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/calendars", CalendarController, only: [:index, :show]
  end

  scope "/sync", MeetingStories do
    pipe_through :browser

    get "/calendars", SyncController, :calendars
    post "/calendars", SyncController, :calendars
    get "/calendars/:calendar_id", SyncController, :calendar_events
    post "/calendars/:calendar_id", SyncController, :calendar_events
  end

  scope "/api", MeetingStories.Api do
    pipe_through :api

    get "/calendars/:calendar_id/events", CalendarController, :events
    resources "/stories", StoryController
  end

  scope "/auth", MeetingStories do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end
end
