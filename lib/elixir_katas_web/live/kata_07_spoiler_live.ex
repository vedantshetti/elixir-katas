defmodule ElixirKatasWeb.Kata07SpoilerLive do
  use ElixirKatasWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:active_tab, fn -> "notes" end)
      |> assign_new(:visible, fn -> false end)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-8 mx-auto mt-12 items-center w-full max-w-lg">
      <div class="card bg-base-100 shadow-xl w-full border border-base-300">
        <div class="card-body">
          <h2 class="card-title text-warning">
            <.icon name="hero-exclamation-triangle" class="w-6 h-6" />
            Major Plot Twist
          </h2>

          <div
            class="relative mt-4 border border-base-200 rounded-lg p-4 bg-base-200/30 overflow-hidden"
            phx-mouseenter="show_spoiler"
            phx-mouseleave="hide_spoiler"
            phx-target={@myself}
          >
            <!-- Spoiler Content -->
            <p class={[
              "transition-all duration-500",
              if(!@visible, do: "blur-md select-none opacity-50", else: "")
            ]}>
              The main character was actually a ghost the entire time!
              They didn't realize it because they could still interact with objects,
              but no one ever looked them in the eye.
            </p>

            <!-- Hover Overlay -->
            <div
              :if={!@visible}
              class="absolute inset-0 flex items-center justify-center bg-base-100/50 backdrop-blur-[2px] z-10"
            >
              <span class="text-sm text-gray-600 animate-pulse">
                Hover to reveal spoiler 👀
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("show_spoiler", _params, socket) do
    {:noreply, assign(socket, visible: true)}
  end

  @impl true
  def handle_event("hide_spoiler", _params, socket) do
    {:noreply, assign(socket, visible: false)}
  end
end
