defmodule GenstageExample.ProducerConsumer do
  use GenStage

  require Integer

  def start_link(number) do
    GenStage.start_link(__MODULE__, number, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [GenstageExample.Producer]}
  end

  def handle_events(events, _from, state) do
    IO.puts("Producer_Consumer")
    numbers =
      events
      |> Enum.filter(&Integer.is_even/1)

    {:noreply, numbers, state}
  end
end
