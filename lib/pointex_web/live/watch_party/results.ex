defmodule PointexWeb.WatchParty.Results do
  use PointexWeb, :live_view
  alias Pointex.Europoints.WatchParty
  alias PointexWeb.WatchParty.NotFound
  alias PointexWeb.WatchParty.SongComponents
  alias PointexWeb.Endpoint
  alias PointexWeb.WatchParty.Nav

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Nav.layout wp_id={@wp.id} active={:results}>
      <div :if={!@results_visible} class="flex h-full w-full justify-center py-32">
        <div class="max-w-lg mb-32 flex flex-col items-center bg-red-100 rounded-lg shadow-xl border border-red-200 overflow-clip">
          <div class="h-[6px] w-full bg-red-300" />
          <div class="px-8 py-8 flex flex-col gap-4">
            <h2 class="font-bold text-red-800">🙈 Hey hey!</h2>
            <p>
              <span class="text-black/50">No peeking! </span>
              <.link navigate={~p"/wp/#{@wp.id}/voting"} class="underline text-sky-800 mx-1">
                Finish your own voting first!
              </.link>
              <span>😉</span>
            </p>
          </div>
        </div>
      </div>
      <div :if={@results_visible} class="flex flex-col h-full sm:flex-row gap-4 my-2">
        <.still_voting :if={@still_voting_participants != []} participants={@still_voting_participants} />
        <.wp_results :if={@live_action == :wp_totals} songs={@wp_totals} wp_id={@wp.id} />
        <.predictions :if={@live_action == :predictions} wp={@wp} />
      </div>
    </Nav.layout>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    data = load_data(wp_id, user(socket).id)
    if connected?(socket), do: Endpoint.subscribe("watch_party:#{wp_id}")

    {:noreply,
     socket
     |> assign(page_title: "Results")
     |> assign(data)}
  end

  @impl Phoenix.LiveView
  def handle_info(_, socket) do
    {:noreply, assign(socket, load_data(socket.assigns.wp.id, user(socket).id))}
  end

  defp load_data(wp_id, user_id) do
    with {:ok, watch_party} <- Ash.get(WatchParty, wp_id, action: :results) do
      participant = Enum.find(watch_party.participants, &(&1.account_id == user_id))

      %{
        wp: watch_party,
        results_visible: participant.final_vote_submitted,
        wp_totals:
          watch_party.total_points_by_participants
          |> Enum.sort_by(& &1.points, :desc)
          |> Enum.with_index(1),
        still_voting_participants: Enum.reject(watch_party.participants, & &1.final_vote_submitted)
      }
    else
      _ -> raise NotFound
    end
  end

  defp still_voting(assigns) do
    ~H"""
    <section class="w-full">
      <.section_header label="⏳ Still Voting..." class="mb-4" />
      <div class="flex flex-wrap gap-4 place-items-start ml-4">
        <.participant :for={participant <- @participants} name={participant.account.name} />
      </div>
    </section>
    """
  end

  defp wp_results(assigns) do
    ~H"""
    <section class="w-full">
      <div class="flex justify-between items-end px-2">
        <.section_header label="🏅 Our Top" class="bg-amber-200 text-amber-900/80 pl-4 pr-8 py-2 mb-0 rounded-t-md" />
        <.link navigate={~p"/wp/#{@wp_id}/results/predictions"}>
          <.section_header label="🔮 Our Predictions" class="text-blue-700" />
        </.link>
      </div>
      <.scores_container>
        <.song :for={{%{song: song, points: points}, place} <- @songs} song={song} points={points} place={place} />
      </.scores_container>
    </section>
    """
  end

  defp predictions(assigns) do
    ~H"""
    <section class="w-full">
      <div class="flex justify-between items-end px-2">
        <.link navigate={~p"/wp/#{@wp.id}/results"} class="pr-4">
          <.section_header label="🏅 Our Top" class="text-blue-700" />
        </.link>
        <.section_header label="🔮 Our Predictions" class="bg-amber-200 text-amber-900/80 pl-8 pr-4 py-2 mb-0 rounded-t-md" />
      </div>
      <.scores_container>
        <.semi_final_prediction_scores :if={@wp.show.kind in [:semi_final_1, :semi_final_2]} scores={@wp.prediction_scores} />
        <.final_prediction_scores :if={@wp.show.kind == :final} scores={@wp.prediction_scores} />
      </.scores_container>
    </section>
    """
  end

  defp song(assigns) do
    ~H"""
    <div class="flex">
      <div class="grow flex w-72 transition-all">
        <div :if={@place > 0} class={"w-8 font-bold text-black/25 text-2xl text-center " <> song_bg(@place)}>
          <%= @place %>
        </div>
        <SongComponents.description song={@song} class={song_bg(@place)} />
      </div>
      <.points_label points={@points} place={@place} />
    </div>
    """
  end

  defp semi_final_prediction_scores(assigns) do
    ~H"""
    <.prediction_scores_visualization scores={@scores}>
      <:score_explanation>
        <p class="text-sm text-slate-500">
          You get 1 <span class="rounded border border-slate-200 px-2 mx-1">📺</span> for each song from your Top 10 that's actually going to the Final
        </p>
      </:score_explanation>
    </.prediction_scores_visualization>
    """
  end

  defp final_prediction_scores(assigns) do
    ~H"""
    <.prediction_scores_visualization scores={@scores}>
      <:score_explanation>
        <p class="text-xs font-mono text-slate-500">
          You get points depending on how your Top 10 corresponds to the actual Top 10:
          <ul class="text-xs font-mono text-slate-500">
            <li>• 10 📺 for having the same winner</li>
            <li>•  3 📺 for having any other song at the same place</li>
            <li>•  2 📺 for having any song 1 place higher or lower</li>
            <li>•  1 📺 for having any song 2 places higher or lower</li>
          </ul>
        </p>
      </:score_explanation>
    </.prediction_scores_visualization>
    """
  end

  defp prediction_scores_visualization(%{scores: %{error: _}} = assigns) do
    ~H"""
    <div class="flex items-center gap-4 m-12 text-slate-600 animate-bounce">
      <.icon name="hero-clock" /> Actual results are not available yet...
    </div>
    """
  end

  defp prediction_scores_visualization(assigns) do
    assigns =
      assign(assigns,
        scores:
          assigns.scores
          |> Enum.map(fn {participant, score} -> %{name: participant.account.name, score: score} end)
          |> Enum.sort_by(& &1.score, :desc)
      )

    ~H"""
    <div class="flex flex-col gap-6 mx-6 my-4 min-w-96">
      <div class="space-y-2 pb-4 mb-2 border-b border-slate-200">
        <h3 class="text-slate-600">Who's got the same taste as Europe?</h3>
        <%= render_slot(@score_explanation) %>
      </div>
      <div class="flex flex-col gap-4 justify-items-start items-top">
        <%= for entry <- @scores do %>
          <div class="flex justify-items-start gap-6">
            <div class="w-1/3 flex items-center gap-1 rounded bg-amber-100 border-b border-amber-300/50 text-amber-900 px-2 py-1">
              <.icon name="hero-user-solid" class="h-3 w-3" />
              <span class="truncate"><%= entry.name %></span>
            </div>
            <div class="grow flex items-center gap-2">
              <span class="text-slate-500 bg-slate-100 px-2 rounded"><%= entry.score %></span>
              <div :if={entry.score > 0} class="flex gap-1 flex-wrap">
                <span :for={_ <- 1..entry.score}>📺</span>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :class, :string, default: "text-gray-500"

  defp section_header(assigns) do
    ~H"""
    <h2 class={["uppercase px-2 my-2", @class]}>
      <%= @label %>
    </h2>
    """
  end

  defp scores_container(assigns) do
    ~H"""
    <div class="flex flex-col divide-y divide-gray-200 bg-white shadow-lg border-t border-amber-200">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp points_label(assigns) do
    ~H"""
    <div class={[
      points_bg(@place, @points),
      "font-bold text-4xl w-24 flex items-center justify-center transition-all"
    ]}>
      <span class="">
        <%= if @place > 0 do %>
          <%= @points %>
        <% else %>
          ?
        <% end %>
      </span>
    </div>
    """
  end

  defp participant(assigns) do
    ~H"""
    <div class="flex items-center gap-1 rounded bg-red-50 text-red-900 shadow px-2 py-1 animate-bounce">
      <.icon name="hero-user-solid" class="text-red-800 h-3 w-3" />
      <span><%= @name %></span>
    </div>
    """
  end

  defp song_bg(1) do
    "p-2 bg-amber-100"
  end

  defp song_bg(2) do
    "p-2 bg-slate-100"
  end

  defp song_bg(3) do
    "p-2 bg-amber-600/10"
  end

  defp song_bg(_) do
    "p-2"
  end

  defp points_bg(1, _) do
    "bg-yellow-400 text-yellow-800"
  end

  defp points_bg(2, _) do
    "bg-slate-300 text-slate-600"
  end

  defp points_bg(3, _) do
    "bg-amber-600 text-amber-300"
  end

  defp points_bg(_, 0) do
    "bg-gray-100 text-gray-400"
  end

  defp points_bg(_place, _points) do
    "bg-sky-200 text-sky-500"
  end
end
