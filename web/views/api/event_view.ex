defmodule ConteurApp.Api.EventView do
  use ConteurApp.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, ConteurApp.Api.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, ConteurApp.Api.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    summarize_event(event)
  end

  defp summarize_event(event) do
    %{
      :id => event.id,
      :origin_id => event.origin_id,
      :title => event.summary,
      :start => format_iso8601(event.starts_at),
      :end => format_iso8601(event.ends_at)
    }
  end

  defp format_iso8601(datetime) do
    {:ok, dt} = Timex.Ecto.DateTime.dump datetime
    Timex.format!(dt, "{ISO:Extended}")
  end
end
