defmodule GenstageExample.Printer do
  require Logger
  def start_link(event) do
    # Note: this function must return the format of `{:ok, pid}` and like
    # all children started by a Supervisor, the process must be linked
    # back to the supervisor (if you use [`Task.start_link/1`](https://hexdocs.pm/elixir/Task.html#start_link/1) then both
    # these requirements are met automatically)
    Task.start_link(fn ->
      # Logger.debug("### Printer #{IO.inspect(self())},#{IO.inspect(event)}###")
      Process.sleep(10000)
      IO.inspect({self(), event})
    end)
  end
end
