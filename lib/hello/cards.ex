defmodule Hello.Cards do

  @size 5 * 5

  def initial do
    List.duplicate("222222", @size)
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
      List.replace_at(state, index, next)
    end)
  end
end
