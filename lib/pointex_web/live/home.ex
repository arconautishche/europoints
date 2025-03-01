defmodule PointexWeb.Home do
  use PointexWeb, :live_view
  alias Pointex.Europoints.WatchParty
  alias PointexWeb.Components.ShowLabel

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class={"flex flex-col md:gap-8 p-4 #{if length(@my_watch_parties) > 0, do: "gap-8", else: "gap-4"}"}>
      <.login_instructions live_action={@live_action} user={@user} />

      <.my_watch_parties
        :if={length(@my_watch_parties) > 0 && @live_action != :show_login_instructions}
        my_watch_parties={@my_watch_parties}
        current_user={@user}
      />

      <div
        :if={@live_action != :show_login_instructions}
        class={[
          "flex flex-col gap-2 w-full",
          if(length(@my_watch_parties) > 0, do: "opacity-50 hover:opacity-100")
        ]}
      >
        <h1 class="uppercase text-gray-400">Start or join a watch party to begin</h1>
        <div class={[
          "w-full flex flex-col gap-4 max-w-lg bg-white shadow rounded p-4 sm:p-6 md:p-8",
          if(@user, do: "", else: "mx-auto")
        ]}>
          <.button navigate_to={~p"/wp/join"}>Join Watch Party</.button>
          <.button navigate_to={~p"/wp/new"} kind="secondary">
            New Watch Party
          </.button>
        </div>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    account_id = user(socket).id

    {:ok, assign(socket, my_watch_parties: WatchParty.for_account(account_id))}
  end

  defp my_watch_parties(assigns) do
    ~H"""
    <div class="w-full flex flex-col gap-2">
      <h1 class="uppercase text-gray-400">My Watch Parties</h1>

      <div :for={wp <- @my_watch_parties}>
        <.watch_party_card watch_party={wp} current_user={@current_user} />
      </div>
    </div>
    """
  end

  defp watch_party_card(assigns) do
    ~H"""
    <.link
      navigate={~p"/wp/#{@watch_party.id}/viewing"}
      class="w-full flex flex-col gap-4 max-w-lg bg-white shadow rounded p-3 sm:py-4 sm:px-6 cursor-pointer transition hover:bg-sky-200/50 hover:scale-105"
    >
      <div class="flex gap-2 sm:gap-4 items-top">
        <.icon name="hero-user-group" class="text-sky-700 h-8 w-8 mt-1" />
        <div class="flex flex-col gap-2">
          <h2>{@watch_party.name}</h2>
          <ShowLabel.show_label year={@watch_party.show.year} show_name={@watch_party.show.kind} />

          <div class="flex gap-2 flex-wrap text-gray-500 mt-4">
            <.participant :for={participant <- other_participants(@watch_party.participants, @current_user)} name={participant.account.name} />
          </div>
        </div>
      </div>
    </.link>
    """
  end

  defp participant(assigns) do
    ~H"""
    <div class="flex items-center gap-1 rounded bg-gray-100 px-1">
      <.icon name="hero-user" class="text-sky-700 h-3 w-3" />
      <span>{@name}</span>
    </div>
    """
  end

  defp other_participants(participants, current_user) do
    Enum.reject(participants, &(&1.account_id == current_user.id))
  end

  defp login_instructions(assigns) do
    ~H"""
    <div class="space-y-4">
      <.link :if={@live_action != :show_login_instructions} navigate={~p"/login_instructions"} class="text-sky-800 underline">
        Want to login in a different browser?
      </.link>
      <.link :if={@live_action == :show_login_instructions} navigate={~p"/"} class="text-sky-800 underline">
        Go back
      </.link>
      <p :if={@live_action == :show_login_instructions} class="flex flex-col gap-2">
        <span>1. Copy or send yourself your unique ID: </span>
        <code class="ml-4 px-4 py-2 text-xs bg-slate-100 border border-slate-200">{@user.id}</code>
        <div>
          <span>2. Go to the Login page</span>
          <div class="flex flex-col ml-4 text-slate-500">
            <span>https://europoints.fly.dev/<b>login</b></span>
            <span>You should see "Welcome back!"</span>
          </div>
        </div>
        <div>3. Enter your unique ID and you're in!</div>
      </p>
    </div>
    """
  end
end
