defmodule LiveViewTodosWeb.LightLive do
  use LiveViewTodosWeb, :live_view

  @value 10

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(LiveViewTodos.PubSub, "light")
    socket = assign(socket, brightness: @value)
    {:ok, socket}
  end

  def handle_event("low", _unsigned_params, socket) do
    socket = update(socket, :brightness, &max(&1 - @value, 0))
    Phoenix.PubSub.broadcast(LiveViewTodos.PubSub, "light", %{value: socket.assigns.brightness})
    {:noreply, socket}
  end

  def handle_event("high", _unsigned_params, socket) do
    socket = update(socket, :brightness, &min(&1 + @value, 100))
    Phoenix.PubSub.broadcast(LiveViewTodos.PubSub, "light", %{value: socket.assigns.brightness})
    {:noreply, socket}
  end

  def handle_event("random", _unsigned_params, socket) do
    random = Enum.random(1..100)
    socket = update(socket, :brightness, fn _ -> random end)
    Phoenix.PubSub.broadcast(LiveViewTodos.PubSub, "light", %{value: socket.assigns.brightness})
    {:noreply, socket}
  end

  def handle_info(%{value: value}, socket) do
    {:noreply, socket |> assign(:brightness, value)}
  end

  def render(assigns) do
    ~H"""
    <div id="light">
      <h1 class="text-center">
        Torch <span class="font-bold text-green-500"><%= @brightness %>%</span>
      </h1>
      <div class="my-2"></div>
      <progress value={@brightness} max="100" class="w-full h-8">
        <%= @brightness %>%
      </progress>
      <div class="my-2"></div>
      <div class="flex justify-between">
        <button class="bg-yellow-300 p-4 rounded-lg" phx-click="low">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-6 h-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M12 4.5v15m0 0l6.75-6.75M12 19.5l-6.75-6.75"
            />
          </svg>
        </button>

        <button class="bg-yellow-300 p-4 rounded-lg" phx-click="random">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-6 h-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M9.75 3.104v5.714a2.25 2.25 0 01-.659 1.591L5 14.5M9.75 3.104c-.251.023-.501.05-.75.082m.75-.082a24.301 24.301 0 014.5 0m0 0v5.714c0 .597.237 1.17.659 1.591L19.8 15.3M14.25 3.104c.251.023.501.05.75.082M19.8 15.3l-1.57.393A9.065 9.065 0 0112 15a9.065 9.065 0 00-6.23-.693L5 14.5m14.8.8l1.402 1.402c1.232 1.232.65 3.318-1.067 3.611A48.309 48.309 0 0112 21c-2.773 0-5.491-.235-8.135-.687-1.718-.293-2.3-2.379-1.067-3.61L5 14.5"
            />
          </svg>
        </button>
        <button class="bg-yellow-300 p-4 rounded-lg" phx-click="high">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-6 h-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M12 19.5v-15m0 0l-6.75 6.75M12 4.5l6.75 6.75"
            />
          </svg>
        </button>
      </div>
    </div>
    """
  end
end
