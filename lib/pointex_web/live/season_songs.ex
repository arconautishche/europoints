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
              :for={%{form: form} = wrapped_form <- @all_forms}
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
                <div :if={form.source.type == :update} class="flex flex-col gap-1 items-start px-4">
                  <.num_input label="Starts in SF 1 at" field={form[:order_in_sf1]} placeholder="position" />
                  <.num_input label="Starts in SF 2 at" field={form[:order_in_sf2]} placeholder="position" />
                </div>
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
      <.input_tag
        type="text"
        id={@field.id}
        name={@field.name}
        value={@field.value}
        placeholder={@placeholder}
      />
    </div>
    """
  end

  defp num_input(assigns) do
    ~H"""
    <div class="flex gap-2 items-center">
      <.label for={@field.id}>{@label}</.label>
      <.input_tag
        type="number"
        id={@field.id}
        name={@field.name}
        value={@field.value}
        placeholder={@placeholder}
        min={1}
        max={30}
      />
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
  def handle_event("validate_song", params, socket) do
    form_id = hd(params["_target"])

    all_forms =
      socket.assigns.all_forms
      |> Enum.map(fn wrapped_form ->
        if wrapped_form.form.id == form_id do
          form = AshPhoenix.Form.validate(wrapped_form.form, params[form_id])

          %{wrapped_form | form: form}
        else
          wrapped_form
        end
      end)

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
end
