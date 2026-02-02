defmodule ElixirKatasWeb.Kata11StopwatchLive do
  use ElixirKatasWeb, :live_component

  def update(%{info_msg: msg}, socket) do
    {:noreply, socket} = handle_info(msg, socket)
    {:ok, socket}
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    {:ok,
     socket
     |> assign(active_tab: "notes")
     |> assign(time: 0)
     |> assign(running: false)
     |> assign_new(:laps, fn -> [] end)}
  end

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center p-8 gap-8 min-h-[400px]">
      <div class="flex flex-col items-center gap-8">
        <!-- Digital Display -->
        <div class="font-mono text-6xl font-bold tracking-wider text-gray-800 dark:text-gray-100 tabular-nums">
          {format_time(@time)}
        </div>

        <div class="flex gap-4">
          <%= if @running do %>
            <button phx-click="stop" phx-target={@myself} class="btn btn-error btn-lg w-32">
              Stop
            </button>
          <% else %>
            <button phx-click="start" phx-target={@myself} class="btn btn-primary btn-lg w-32">
              Start
            </button>
          <% end %>

          <button
            phx-click="lap"
            phx-target={@myself}
            class="btn btn-secondary btn-lg w-32"
            disabled={!@running}
          >
            Lap
          </button>

          <button
            phx-click="reset"
            phx-target={@myself}
            class="btn btn-outline btn-lg w-32"
            disabled={@running}
          >
            Reset
          </button>
        </div>
        <%= if @laps != [] do %>
          <div class="w-full max-w-sm mt-6">
            <h3 class="font-semibold mb-2 text-center">Laps</h3>
            <ul class="space-y-2 max-h-48 overflow-y-auto">
              <%= for lap <- @laps do %>
                <li class="flex justify-between px-4 py-2 bg-gray-100 rounded font-mono">
                  <span>Lap {lap.index}</span>
                  <span>{format_time(lap.time)}</span>
                </li>
              <% end %>
            </ul>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("start", _, socket) do
    if socket.assigns.running do
      {:noreply, socket}
    else
      Process.send_after(self(), :tick, 100)
      {:noreply, assign(socket, running: true)}
    end
  end

  def handle_event("stop", _, socket) do
    {:noreply, assign(socket, running: false)}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    if tab in ["interactive", "source", "notes"] do
      {:noreply, assign(socket, active_tab: tab)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("reset", _, socket) do
    {:noreply, assign(socket, time: 0, laps: [])}
  end

  def handle_event("lap", _, socket) do
    lap_time = socket.assigns.time

    {:noreply,
     update(socket, :laps, fn laps ->
       [%{index: length(laps) + 1, time: lap_time} | laps]
     end)}
  end

  def handle_info(:tick, socket) do
    if socket.assigns.running do
      # 100ms interval = 1/10th second
      Process.send_after(self(), :tick, 100)
      # Increment by 1 (representing 100ms or 0.1s)
      {:noreply, update(socket, :time, &(&1 + 1))}
    else
      {:noreply, socket}
    end
  end

  defp format_time(deci_seconds) do
    seconds = div(deci_seconds, 10)
    decis = rem(deci_seconds, 10)

    minutes = div(seconds, 60)
    seconds = rem(seconds, 60)

    # Format as MM:SS.d
    "#{pad(minutes)}:#{pad(seconds)}.#{decis}"
  end

  defp pad(i), do: String.pad_leading("#{i}", 2, "0")
end
