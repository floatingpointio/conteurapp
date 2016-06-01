defmodule ConteurApp.PostbackRegistration do
  require Logger

  def watch_events(user, calendar) do
    HTTPoison.post!(watch_events_url(calendar.origin_id), Poison.encode!(watch_events_body), headers(user))
  end

  def watch_events_url(origin_id) do
    "https://www.googleapis.com/calendar/v3/calendars/#{URI.encode(origin_id)}/events/watch"
  end

  def watch_events_body do
    %{
      "id" => UUID.uuid1,
      "type" => "web_hook",
      "address" => address
    }
  end

  def headers(user) do
    [{"Authorization", "Bearer #{user.token}"}, {"Content-Type", "application/json"}]
  end

  def address do
    case Mix.env do
      :dev ->  "https://dev.conteurapp.com/api/postback/events"
      :prod ->  "https://app.conteurapp.com/api/postback/events"
    end
  end
end
