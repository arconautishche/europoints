defmodule PointexWeb.SeasonSongs do
  use PointexWeb, :live_view
  alias Pointex.Europoints.Country
  alias Pointex.Europoints.Season
  alias Pointex.Europoints.Song

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-center text-2xl text-slate-800">
        <.link navigate={~p"/season/#{@year}"} class="text-sky-700 hover:text-sky-900 hover:underline">{@year}</.link> - Songs
      </h1>
      <div class="mx-1 sm:mx-8 mt-4">
        <div class="bg-white shadow rounded-lg p-4">
          <h2 class="text-lg font-semibold mb-4">Participating Countries</h2>
          <div class="flex flex-col gap-8">
            <.form
              :for={%{form: form, went_to_final: went_to_final} = wrapped_form <- @all_forms}
              for={form}
              class={"border-l-4 rounded flex flex-col gap-2 shadow-lg #{if form.source.type == :create, do: "border-gray-200", else: "border-green-500"}"}
              phx-change="validate_song"
              phx-submit="save_song"
            >
              <div class="flex items-center gap-2 bg-slate-100 px-4 py-2">
                <span class="text-xl">{wrapped_form.flag}</span>
                <span class="font-medium">{wrapped_form.country}</span>
              </div>
              <div class="flex flex-col gap-2">
                <div class="flex gap-4 px-4 py-2">
                  <div class="flex flex-col gap-2 grow">
                    <.text_input label="👯" field={form[:artist]} placeholder="Artist" />
                    <.text_input label="🎶" field={form[:name]} placeholder="Song" />
                    <.text_input label="🎞️" field={form[:img]} input_class="!text-xs" placeholder="Poster URL" />
                  </div>
                  <img src={Ash.Changeset.get_attribute(form.source.source, :img)} alt="Poster" class="h-[200px] object-contain" />
                </div>
                <.running_order_input :if={form.source.type == :update} form={form} went_to_final={went_to_final} />
                <div class="border-b border-gray-200 px-4 py-2 flex justify-center">
                  <button
                    type="submit"
                    class="px-48 py-1 bg-sky-200 text-sky-700 rounded hover:bg-sky-300 disabled:opacity-50 disabled:bg-gray-200"
                    phx-disable-with="Saving..."
                  >
                    Save
                  </button>
                </div>
              </div>
            </.form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp text_input(assigns) do
    ~H"""
    <div class="flex gap-2 items-center">
      <.label for={@field.id}>{@label}</.label>
      <.input_tag type="text" id={@field.id} name={@field.name} value={@field.value} placeholder={@placeholder} />
    </div>
    """
  end

  defp num_input(assigns) do
    ~H"""
    <div class="flex gap-2 items-center">
      <.label for={@field.id}>{@label}</.label>
      <.input_tag type="number" id={@field.id} name={@field.name} value={@field.value} placeholder={@placeholder} min={1} max={30} />
    </div>
    """
  end

  defp running_order_input(assigns) do
    ~H"""
    <div class="flex flex-col gap-1 items-start px-4">
      <.num_input :if={@form[:order_in_sf1].value} label="Ranking order in Semi Final 1" field={@form[:order_in_sf1]} placeholder="position" />
      <button
        :if={!@form[:order_in_sf1].value}
        type="button"
        class="text-sm px-2 bg-sky-100 text-sky-800 rounded hover:bg-sky-200"
        phx-click="move_to_sf1"
        phx-value-form_id={@form.id}
      >
        🔄 In Semi Final 1
      </button>
      <.num_input :if={@form[:order_in_sf2].value} label="Ranking order in Semi Final 2" field={@form[:order_in_sf2]} placeholder="position" />
      <button
        :if={!@form[:order_in_sf2].value}
        type="button"
        class="text-sm px-2 bg-sky-100 text-sky-800 rounded hover:bg-sky-200"
        phx-click="move_to_sf2"
        phx-value-form_id={@form.id}
      >
        🔄 In Semi Final 2
      </button>
      <hr :if={@went_to_final} class="w-full border-gray-200" />
      <.num_input :if={@went_to_final} label="Ranking order in final" field={@form[:order_in_final]} placeholder="position" />
    </div>
    """
  end

  attr :type, :string, default: "text"
  attr :name, :string, required: true
  attr :value, :string, required: true
  attr :rest, :global, include: ~w(min max)

  defp input_tag(assigns) do
    ~H"""
    <input type={@type} name={@name} value={@value} class="grow border border-slate-300 rounded-md p-1 w-36" {@rest} />
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"year" => year}, _uri, socket) do
    {:noreply,
     socket
     |> assign(page_title: "Season Songs")
     |> assign(year: year)
     |> assign(all_forms: all_forms(year))}
  end

  @impl Phoenix.LiveView
  def handle_event("move_to_sf1", params, socket) do
    all_forms = socket.assigns.all_forms
    all_forms = update_form(all_forms, params["form_id"], %{order_in_sf1: next_place(all_forms, :sf1), order_in_sf2: nil})

    {:noreply, assign(socket, all_forms: all_forms)}
  end

  def handle_event("move_to_sf2", params, socket) do
    all_forms = socket.assigns.all_forms
    all_forms = update_form(all_forms, params["form_id"], %{order_in_sf2: next_place(all_forms, :sf2), order_in_sf1: nil})

    {:noreply, assign(socket, all_forms: all_forms)}
  end

  def handle_event("validate_song", params, socket) do
    form_id = hd(params["_target"])

    all_forms =
      update_form(socket.assigns.all_forms, form_id, params[form_id])

    {:noreply, assign(socket, all_forms: all_forms)}
  end

  def handle_event("save_song", params, socket) do
    form_id = hd(Map.keys(params))
    form = Enum.find_value(socket.assigns.all_forms, &if(&1.form.id == form_id, do: &1.form))

    AshPhoenix.Form.submit!(form, params: params[form_id])

    {:noreply, assign(socket, all_forms: all_forms(socket.assigns.year))}
  end

  defp all_forms(year) do
    season = Ash.get!(Season, year, load: [:songs])

    Country.all()
    |> Enum.sort()
    |> Enum.map(fn country ->
      %{
        country: country,
        flag: Country.flag(country),
        went_to_final: Enum.find(season.songs, &(&1.country == country and &1.went_to_final)),
        form:
          case Enum.find(season.songs, &(&1.country == country)) do
            nil -> form_for_create(country, year)
            song -> form_for_update(song)
          end
      }
    end)
  end

  defp form_for_create(country, year) do
    AshPhoenix.Form.for_create(Song, :register,
      prepare_source: fn changeset ->
        changeset
        |> Ash.Changeset.set_argument(:season, year)
        |> Ash.Changeset.change_attribute(:country, country)
      end,
      as: "song_#{country}"
    )
    |> to_form()
  end

  defp form_for_update(song) do
    song
    |> AshPhoenix.Form.for_update(:change_description, as: "song_#{song.country}")
    |> to_form()
  end

  defp update_form(all_forms, form_id, params) do
    Enum.map(all_forms, fn wrapped_form ->
      if wrapped_form.form.id == form_id do
        %{wrapped_form | form: AshPhoenix.Form.validate(wrapped_form.form, params)}
      else
        wrapped_form
      end
    end)
  end

  defp next_place(all_forms, show_kind) do
    all_forms
    |> Enum.map(& &1.form[:"order_in_#{show_kind}"].value)
    |> Enum.reject(&(&1 == nil))
    |> case do
      [] -> 1
      taken_places -> Enum.max(taken_places) + 1
    end
  end
end
