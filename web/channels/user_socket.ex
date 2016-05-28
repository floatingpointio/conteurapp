defmodule ConteurApp.UserSocket do
  use Phoenix.Socket

  channel "data:events", ConteurApp.DataChannel

  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000
  
  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
