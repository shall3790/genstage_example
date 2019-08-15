defmodule GenstageExample.ProducerConsumer do
  use GenStage
  require Logger
  require Integer

  def start_link(number) do
    GenStage.start_link(__MODULE__, number, name: __MODULE__)
  end

  def init(state) do
    # {:producer_consumer, state, subscribe_to: [GenstageExample.Producer]}
    # {:producer_consumer, state, subscribe_to: [GenstageExample.Broadcaster]}
    {:producer_consumer, state, subscribe_to: [GenstageExample.QueueBroadcaster]}
  end

  def handle_events(events, _from, state) do
    IO.puts("### Producer_Consumer.handle_events ###")
    IO.inspect({self(), events, state})
    # Logger.debug(IO.inspect(events))
    numbers =
      events
      |> Enum.filter(&Integer.is_even/1)

    {:noreply, numbers, state}
  end
end
