defmodule ConteurApp.Api.CalendarView do
  use ConteurApp.Web, :view

  def render("index.json", %{calendars: calendars}) do
    %{data: render_many(calendars, ConteurApp.Api.CalendarView, "calendar.json")}
  end

  def render("show.json", %{calendar: calendar}) do
    %{data: render_one(calendar, ConteurApp.Api.CalendarView, "calendar.json")}
  end

  def render("calendar.json", %{calendar: calendar}) do
    summarize_calendar(calendar)
  end

  defp summarize_calendar(calendar) do
    %{
      :id => calendar.id,
      :origin_id => calendar.origin_id,
      :title => calendar.summary,
      :time_zone => calendar.time_zone
    }
  end
end
