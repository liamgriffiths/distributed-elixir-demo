defmodule Hello.Cards do

  @size 5 * 5

  def initial do
    s = Stream.repeatedly(fn -> "222222" end)
    Enum.take(s, @size)
  end

  def start_link(state) do
    case Agent.start_link(fn -> state end, name: {:global, __MODULE__}) do
      {:ok, pid} ->
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  def get do
    Agent.get({:global, __MODULE__}, fn state -> state end)
  end

  def update(index, next) do
    Agent.update({:global, __MODULE__}, fn state ->
      List.update_at(state, index, fn _ -> next end)
    end)
  end
end
