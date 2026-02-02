defmodule ElixirKatasWeb.Kata08AccordionLive do
  use ElixirKatasWeb, :live_component

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    faqs = [
      %{
        id: "faq-1",
        question: "What is Phoenix LiveView?",
        answer:
          "Phoenix LiveView is a library that enables rich, real-time user experiences with server-rendered HTML."
      },
      %{
        id: "faq-2",
        question: "How does it work?",
        answer:
          "It maintains a stateful connection via WebSockets, allowing the server to push updates to the client efficiently."
      },
      %{
        id: "faq-3",
        question: "Is it scalable?",
        answer:
          "Yes! Since it runs on the BEAM (Erlang VM), it handles concurrency extremely well, supporting millions of connections."
      }
    ]

    {:ok,
     socket
     |> assign(active_tab: "notes")
     |> assign(faqs: faqs)
     |> assign(active_ids: [])}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-8 mx-auto mt-12 items-center w-full max-w-2xl">
      <div class="w-full space-y-4">
        <div
          :for={faq <- @faqs}
          class="border border-base-300 rounded-lg overflow-hidden bg-base-100 shadow-sm"
        >
          <button
            phx-click="toggle"
            phx-target={@myself}
            phx-value-id={faq.id}
            class={"w-full flex justify-between items-center p-4 text-left font-semibold transition-colors duration-200 hover:bg-base-200 " <> if(faq.id in @active_ids, do: "bg-base-200 text-primary", else: "")}
          >
            <span>{faq.question}</span>
            <.icon
              name="hero-chevron-down"
              class={"w-5 h-5 transition-transform duration-300 " <> if(faq.id in @active_ids, do: "rotate-180", else: "")}
            />
          </button>

          <div class={"grid transition-all duration-300 ease-in-out " <> if(faq.id in @active_ids, do: "grid-rows-[1fr] opacity-100", else: "grid-rows-[0fr] opacity-0")}>
            <div class="overflow-hidden">
              <div class="p-4 pt-0 text-base-content/80 leading-relaxed border-t border-base-200">
                {faq.answer}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("toggle", %{"id" => id}, socket) do
    active_ids = socket.assigns.active_ids

    new_active_ids =
      if id in active_ids do
        List.delete(active_ids, id)
      else
        [id | active_ids]
      end

    {:noreply, assign(socket, active_ids: new_active_ids)}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end
end
