defmodule ConteurApp.DataFetching do

  alias Ecto.DateTime
  alias Ecto.Date

  def fetch_calendars(token) do
    response =
      "https://www.googleapis.com/calendar/v3/users/me/calendarList?key=#{api_key}"
      |> HTTPoison.get!(headers(token))

    response.body |> Poison.decode!
  end

  def fetch_events(token, cal_id) do
    url_encoded_cal_id = URI.encode(cal_id)
    response =
      "https://www.googleapis.com/calendar/v3/calendars/#{url_encoded_cal_id}/events?key=#{api_key}"
      |> HTTPoison.get!(headers(token))

    response.body |> Poison.decode!
  end

  defp headers(token) do
    [{"Authorization", "OAuth #{token}"}, {"Accept", "applications/json"}]
  end

  defp api_key do
    Application.get_env(:conteur_app, :google)[:api_key]
  end
end
