defmodule HelloWeb.DemoChannel do
  use Phoenix.Channel
  require Logger

  def join("demo:hello", _message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :status)
    send(self(), {:new_connection, %{}})
    {:ok, socket}
  end

  def handle_info(:status, socket) do
    # push socket, "status:state", %{ node: Node.self(), nodes: Node.list() }
    {:noreply, socket}
  end

  def handle_info({:new_connection, _msg}, socket) do
    push socket, "cards:state", %{data: Hello.Cards.get()}
    {:noreply, socket}
  end

  def handle_in("cards:change", %{"index" => index, "color" => color}, socket) do
    Hello.Cards.update(index, color)
    broadcast! socket, "cards:change", %{ index: index, color: color }
    {:noreply, socket}
  end
end
