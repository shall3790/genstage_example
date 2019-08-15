defmodule GenstageExample.QueueBroadcaster do
  use GenStage
  require Logger
  @doc "Starts the broadcaster."
  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc "Sends an event and returns only after the event is dispatched."
  # def sync_notify(event, timeout \\ 5000) do
  #   GenStage.call(__MODULE__, {:notify, event}, timeout)
  # end
  # public endpoint for events adding
  def add(events), do: GenServer.cast(__MODULE__, {:add, events})

  ## Callbacks

  def init(:ok) do
    {:producer, {:queue.new, 0}, dispatcher: GenStage.BroadcastDispatcher}
  end

  # just push events to consumers on adding
  # def handle_cast({:add, events}, {queue, pending_demand}) when is_list(events) do
  #   {:noreply, events, state}
  # end

  def handle_cast({:add, event}, {queue, pending_demand}) do
    queue = :queue.in(event, queue)
    dispatch_events(queue, pending_demand, [])
  end

  # def handle_call({:notify, event}, from, {queue, pending_demand}) do
  #   queue = :queue.in({from, event}, queue)
  #   dispatch_events(queue, pending_demand, [])
  # end

  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_events(queue, incoming_demand + pending_demand, [])
  end

  defp dispatch_events(queue, 0, events) do
    {:noreply, Enum.reverse(events), {queue, 0}}
  end

  defp dispatch_events(queue, demand, events) do
    Logger.debug("queue length: #{:queue.len(queue)}")
    case :queue.out(queue) do
      {{:value, event}, queue} ->
        # GenStage.reply(from, :ok)
        dispatch_events(queue, demand - 1, [event | events])
      {:empty, queue} ->
        {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end
