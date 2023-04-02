defmodule Pointex.Model.ReadModels.Shows do
  @all_songs %{
    "Norway" => %{
      flag: "🇳🇴",
      artist: "Alessandra",
      song: "Queen of Kings",
      languages: ["English"]
    },
    "Malta" => %{
      flag: "🇲🇹",
      artist: "The Busker",
      song: "Dance (Our Own Party)",
      languages: ["English"]
    },
    "Serbia" => %{
      flag: "🇷🇸",
      artist: "Luke Black",
      song: "Samo mi se spava (Само ми се спава)",
      languages: ["Serbian", "English"]
    },
    "Latvia" => %{
      flag: "🇱🇻",
      artist: "Sudden Lights",
      song: "Aijā",
      languages: ["English"]
    },
    "Portugal" => %{
      flag: "🇵🇹",
      artist: "Mimicat",
      song: "Ai coração",
      languages: ["Portuguese"]
    },
    "Ireland" => %{
      flag: "🇮🇪",
      artist: "Wild Youth",
      song: "We Are One",
      languages: ["English"]
    },
    "Croatia" => %{
      flag: "🇭🇷",
      artist: "Let 3",
      song: "Mama ŠČ!",
      languages: ["Croatian"]
    },
    "Switzerland" => %{
      flag: "🇨🇭",
      artist: "Remo Forrer",
      song: "Watergun",
      languages: ["English"]
    },
    "Israel" => %{
      flag: "🇮🇱",
      artist: "Noa Kirel",
      song: "Unicorn",
      languages: ["English"]
    },
    "Moldova" => %{
      flag: "🇲🇩",
      artist: "Pasha Parfeni",
      song: "Soarele și luna",
      languages: ["Romanian"]
    },
    "Sweden" => %{
      flag: "🇸🇪",
      artist: "Loreen",
      song: "Tattoo",
      languages: ["English"]
    },
    "Azerbaijan" => %{
      flag: "🇦🇿",
      artist: "TuralTuranX",
      song: "Tell Me More",
      languages: ["English"]
    },
    "Czech Republic" => %{
      flag: "🇨🇿",
      artist: "Vesna",
      song: "My Sister's Crown",
      languages: ["English", "Ukrainian", "Czech", "Bulgarian"]
    },
    "Netherlands" => %{
      flag: "🇳🇱",
      artist: "Mia Nicolai and Dion Cooper",
      song: "Burning Daylight",
      languages: ["English"]
    },
    "Finland" => %{
      flag: "🇫🇮",
      artist: "Käärijä",
      song: "Cha Cha Cha",
      languages: ["Finnish"]
    },
    "Denmark" => %{
      flag: "🇩🇰",
      artist: "Reiley",
      song: "Breaking My Heart",
      languages: ["English"]
    },
    "Armenia" => %{
      flag: "🇦🇲",
      artist: "Brunette",
      song: "Future Lover",
      languages: ["English", "Armenian"]
    },
    "Romania" => %{
      flag: "🇷🇴",
      artist: "Theodor Andrei",
      song: "D.G.T. (Off and On)",
      languages: ["Romanian", "English"]
    },
    "Estonia" => %{
      flag: "🇪🇪",
      artist: "Alika",
      song: "Bridges",
      languages: ["English"]
    },
    "Belgium" => %{
      flag: "🇧🇪",
      artist: "Gustaph",
      song: "Because of You",
      languages: ["English"]
    },
    "Cyprus" => %{
      flag: "🇨🇾",
      artist: "Andrew Lambrou",
      song: "Break a Broken Heart",
      languages: ["English"]
    },
    "Iceland" => %{
      flag: "🇮🇸",
      artist: "Diljá",
      song: "Power",
      languages: ["English"]
    },
    "Greece" => %{
      flag: "🇬🇷",
      artist: "Victor Vernicos",
      song: "What They Say",
      languages: ["English"]
    },
    "Poland" => %{
      flag: "🇵🇱",
      artist: "Blanka",
      song: "Solo",
      languages: ["English"]
    },
    "Slovenia" => %{
      flag: "🇸🇮",
      artist: "Joker Out",
      song: "Carpe Diem",
      languages: ["Slovene"]
    },
    "Georgia" => %{
      flag: "🇬🇪",
      artist: "Iru",
      song: "Echo",
      languages: ["English"]
    },
    "San Marino" => %{
      flag: "🇸🇲",
      artist: "Piqued Jacks",
      song: "Like an Animal",
      languages: ["English"]
    },
    "Austria" => %{
      flag: "🇦🇹",
      artist: "Teya and Salena",
      song: "Who the Hell Is Edgar?",
      languages: ["English"]
    },
    "Albania" => %{
      flag: "🇦🇱",
      artist: "Albina & Familja Kelmendi",
      song: "Duje",
      languages: ["Albanian"]
    },
    "Lithuania" => %{
      flag: "🇱🇹",
      artist: "Monika Linkytė",
      song: "Stay",
      languages: ["English"]
    },
    "Australia" => %{
      flag: "🇦🇺",
      artist: "Voyager",
      song: "Promise",
      languages: ["English"]
    },
    "France" => %{
      flag: "🇫🇷",
      artist: "La Zarra",
      song: "Évidemment",
      languages: ["French"]
    },
    "Germany" => %{
      flag: "🇩🇪",
      artist: "Lord of the Lost",
      song: "Blood & Glitter",
      languages: ["English"]
    },
    "Italy" => %{
      flag: "🇮🇹",
      artist: "Marco Mengoni",
      song: "Due Vite",
      languages: ["Italian"]
    },
    "Spain" => %{
      flag: "🇪🇸",
      artist: "Blanca Palom",
      song: "Eaea",
      languages: ["Spanish"]
    },
    "Ukraine" => %{
      flag: "🇺🇦",
      artist: "Tvorchi",
      song: "Heart of Steel",
      languages: ["English", "Ukrainian"]
    },
    "United Kingdom" => %{
      flag: "🇬🇧",
      artist: "Mae Muller",
      song: "I Wrote a Song",
      languages: ["English"]
    }
  }

  @semi_final_1 [
    %{ro: 1, country: "Norway"},
    %{ro: 2, country: "Malta"},
    %{ro: 3, country: "Serbia"},
    %{ro: 4, country: "Latvia"},
    %{ro: 5, country: "Portugal"},
    %{ro: 6, country: "Ireland"},
    %{ro: 7, country: "Croatia"},
    %{ro: 8, country: "Switzerland"},
    %{ro: 9, country: "Israel"},
    %{ro: 10, country: "Moldova"},
    %{ro: 11, country: "Sweden"},
    %{ro: 12, country: "Azerbaijan"},
    %{ro: 13, country: "Czech Republic"},
    %{ro: 14, country: "Netherlands"},
    %{ro: 15, country: "Finland"}
  ]

  @semi_final_2 [
    %{ro: 1, country: "Denmark"},
    %{ro: 2, country: "Armenia"},
    %{ro: 3, country: "Romania"},
    %{ro: 4, country: "Estonia"},
    %{ro: 5, country: "Belgium"},
    %{ro: 6, country: "Cyprus"},
    %{ro: 7, country: "Iceland"},
    %{ro: 8, country: "Greece"},
    %{ro: 9, country: "Poland"},
    %{ro: 10, country: "Slovenia"},
    %{ro: 11, country: "Georgia"},
    %{ro: 12, country: "San Marino"},
    %{ro: 13, country: "Austria"},
    %{ro: 14, country: "Albania"},
    %{ro: 15, country: "Lithuania"},
    %{ro: 16, country: "Australia"}
  ]

  @final []

  def show(2023, :semi_final_1) do
    list_songs_from(@semi_final_1)
  end

  def show(2023, :semi_final_2) do
    list_songs_from(@semi_final_2)
  end

  def show(2023, :final) do
    list_songs_from(@final)
  end

  defp list_songs_from(show) do
    show
    |> Enum.map(fn %{ro: ro, country: country} ->
      %{ro: ro, country: country}
      |> Map.merge(Map.get(@all_songs, country))
    end)
  end
end
