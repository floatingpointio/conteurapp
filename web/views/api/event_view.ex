defmodule ConteurApp.Api.EventView do
  use ConteurApp.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, ConteurApp.Api.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, ConteurApp.Api.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    as_json(event, [:with_tags, :with_related])
  end
  
  def as_json(event, []), do: base_json(event)

  def as_json(event, [:with_related]) do
    base_json(event)
    |> Map.merge(%{
      related: Enum.map(event.events, fn(e) ->
        %{ id: e.id, summary: e.summary, description: e.description }
      end),
    })
  end

  def as_json(event, [:with_tags]) do
    base_json(event)
    |> Map.merge(%{
      tags: Enum.map(event.tags, &(&1.name))
    })
  end

  def as_json(event, [:with_tags, :with_related]) do
    base_json(event)
    |> Map.merge(%{
      related: Enum.map(event.events, fn(e) ->
        %{ id: e.id, summary: e.summary, description: e.description }
      end),
    })
    |> Map.merge(%{
      tags: Enum.map(event.tags, &(&1.name))
    })
  end

  defp base_json(event) do
    %{
      id: event.id,
      origin_id: event.origin_id,
      summary: event.summary,
      description: event.description,
      status: event.status,
      starts_at: format_iso8601(event.starts_at),
      ends_at: format_iso8601(event.ends_at)
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
