defmodule PointexWeb.WatchParty.Overview do
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="bg-gradient-to-br from-white to-sky-100/50 sm:rounded sm:border border-gray-200 sm:shadow mx-auto overflow-clip">
      <div class="h-[6px] w-full bg-sky-600" />
      <div class="flex flex-col gap-4 p-4 sm:p-6 md:p-8 ">
        <div class="flex items-baseline gap-4 opacity-75 font-light text-xl text-center">
          <span>💌</span>
          <span class="">Invite someone</span>
        </div>

        <span class="text-sm text-gray-400">Send this link</span>
        <div class="flex items-baseline justify-start gap-4 font-light text-sky-900">
          <span>🔗</span>
          <.link navigate={@link} class=" border-b border-sky-900/20"><%= @link %></.link>
        </div>

        <span class="text-sm text-gray-400">... or lazy much?</span>
        <div class="flex items-baseline gap-4 font-light">
          <img src={"data:image/png;base64," <> @qr} />
        </div>
      </div>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    invite_link = url(socket, ~p"/wp/join/#{wp_id}")

    {:noreply,
     socket
     |> assign(page_title: "Share")
     |> assign(%{
       wp_id: wp_id,
       link: invite_link,
       qr:
         invite_link
         |> EQRCode.encode()
         |> EQRCode.png()
         |> Base.encode64()
     })}
  end
end
