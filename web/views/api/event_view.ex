defmodule ConteurApp.Api.EventView do
  use ConteurApp.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, ConteurApp.Api.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, ConteurApp.Api.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    as_json(event)
  end

  def as_json(event) do
    %{
      id: event.id,
      origin_id: event.origin_id,
      title: event.summary,
      status: event.status,
      start: format_iso8601(event.starts_at),
      end: format_iso8601(event.ends_at)
    }
  end

  defp format_iso8601(nil) do
    "N/A"
  end

  defp format_iso8601(ts) when not is_nil(ts) do
    dump_and_format(ts)
  end

  defp dump_and_format(datetime) do
    {:ok, dt} = Timex.Ecto.DateTime.dump datetime 
    Timex.format!(dt, "{ISO:Extended}")
  end
end
