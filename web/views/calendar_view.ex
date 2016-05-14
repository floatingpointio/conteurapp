defmodule MeetingStories.CalendarView do
  use MeetingStories.Web, :view
  
  def timestamp(ts) do
    if ts do
      {:ok, formatted } = ts |> Timex.format("{ISO:Extended}")
      formatted
    else
      "N/A"
    end
  end
end
