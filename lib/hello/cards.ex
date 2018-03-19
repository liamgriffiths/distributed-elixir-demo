defmodule Hello.Cards do

  @size 5 * 5

  def initial do
    s = Stream.repeatedly(fn -> "222222" end)
    Enum.take(s, @size)
  end

  def start_link(state) do
    case Agent.start_link(fn -> state end, name: {:global, __MODULE__})
      {:ok, pid} ->
        Logger.info "Started #{__MODULE__}"
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        Logger.info "Already started #{__MODULE__}"
        {:ok, pid}
    end
  end

  def get do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def update(index, next) do
    Agent.update(__MODULE__, fn state ->
      List.update_at(state, index, fn _ -> next end)
    end)
  end
end
