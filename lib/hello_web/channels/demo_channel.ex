defmodule HelloWeb.DemoChannel do
  use Phoenix.Channel
  require Logger

  def join("demo:hello", _message, socket) do
    send(self(), {:new_connection, %{}})
    {:ok, socket}
  end

  def handle_info({:new_connection, _msg}, socket) do
    cards = Hello.Cards.get()
    push(socket, "cards:state", %{data: cards})
    {:noreply, socket}
  end

  def handle_in("cards:change", %{"index" => index, "color" => color}, socket) do
    Hello.Cards.update(index, color)
    broadcast!(socket, "cards:change", %{ index: index, color: color })
    {:noreply, socket}
  end
end
