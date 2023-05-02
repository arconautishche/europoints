defmodule Pointex.Model.ReadModels.Shows do
  @all_songs %{
    "Norway" => %{
      flag: "🇳🇴",
      artist: "Alessandra",
      song: "Queen of Kings",
      img: "norway.JPG",
      languages: ["English"]
    },
    "Malta" => %{
      flag: "🇲🇹",
      artist: "The Busker",
      song: "Dance (Our Own Party)",
      img: "malta.webp",
      languages: ["English"]
    },
    "Serbia" => %{
      flag: "🇷🇸",
      artist: "Luke Black",
      song: "Samo mi se spava",
      img: "serbia.jpg",
      languages: ["Serbian", "English"]
    },
    "Latvia" => %{
      flag: "🇱🇻",
      artist: "Sudden Lights",
      song: "Aijā",
      img: "latvia.jpg",
      languages: ["English"]
    },
    "Portugal" => %{
      flag: "🇵🇹",
      artist: "Mimicat",
      song: "Ai coração",
      img: "portugal.jpg",
      languages: ["Portuguese"]
    },
    "Ireland" => %{
      flag: "🇮🇪",
      artist: "Wild Youth",
      song: "We Are One",
      img: "ireland.webp",
      languages: ["English"]
    },
    "Croatia" => %{
      flag: "🇭🇷",
      artist: "Let 3",
      song: "Mama ŠČ!",
      img: "croatia.jpg",
      languages: ["Croatian"]
    },
    "Switzerland" => %{
      flag: "🇨🇭",
      artist: "Remo Forrer",
      song: "Watergun",
      img: "switzerland.jpg",
      languages: ["English"]
    },
    "Israel" => %{
      flag: "🇮🇱",
      artist: "Noa Kirel",
      song: "Unicorn",
      img: "israel.jpg",
      languages: ["English"]
    },
    "Moldova" => %{
      flag: "🇲🇩",
      artist: "Pasha Parfeni",
      song: "Soarele și luna",
      img: "moldova.jpg",
      languages: ["Romanian"]
    },
    "Sweden" => %{
      flag: "🇸🇪",
      artist: "Loreen",
      song: "Tattoo",
      img: "sweden.jpg",
      languages: ["English"]
    },
    "Azerbaijan" => %{
      flag: "🇦🇿",
      artist: "TuralTuranX",
      song: "Tell Me More",
      img: "azerbaijan.jpg",
      languages: ["English"]
    },
    "Czech Republic" => %{
      flag: "🇨🇿",
      artist: "Vesna",
      song: "My Sister's Crown",
      img: "czechia.jpeg",
      languages: ["English", "Ukrainian", "Czech", "Bulgarian"]
    },
    "Netherlands" => %{
      flag: "🇳🇱",
      artist: "Mia Nicolai and Dion Cooper",
      song: "Burning Daylight",
      img: "netherlands.jpg",
      languages: ["English"]
    },
    "Finland" => %{
      flag: "🇫🇮",
      artist: "Käärijä",
      song: "Cha Cha Cha",
      img: "finland.jpg",
      languages: ["Finnish"]
    },
    "Denmark" => %{
      flag: "🇩🇰",
      artist: "Reiley",
      song: "Breaking My Heart",
      img: "denmark.jpg",
      languages: ["English"]
    },
    "Armenia" => %{
      flag: "🇦🇲",
      artist: "Brunette",
      song: "Future Lover",
      img: "armenia.jpg",
      languages: ["English", "Armenian"]
    },
    "Romania" => %{
      flag: "🇷🇴",
      artist: "Theodor Andrei",
      song: "D.G.T. (Off and On)",
      img: "romania.jpg",
      languages: ["Romanian", "English"]
    },
    "Estonia" => %{
      flag: "🇪🇪",
      artist: "Alika",
      song: "Bridges",
      img: "estonia.jpg",
      languages: ["English"]
    },
    "Belgium" => %{
      flag: "🇧🇪",
      artist: "Gustaph",
      song: "Because of You",
      img: "belgium.jpg",
      languages: ["English"]
    },
    "Cyprus" => %{
      flag: "🇨🇾",
      artist: "Andrew Lambrou",
      song: "Break a Broken Heart",
      img: "cypress.jpg",
      languages: ["English"]
    },
    "Iceland" => %{
      flag: "🇮🇸",
      artist: "Diljá",
      song: "Power",
      img: "iceland.jpg",
      languages: ["English"]
    },
    "Greece" => %{
      flag: "🇬🇷",
      artist: "Victor Vernicos",
      song: "What They Say",
      img: "greece.jpg",
      languages: ["English"]
    },
    "Poland" => %{
      flag: "🇵🇱",
      artist: "Blanka",
      song: "Solo",
      img: "poland.jpg",
      languages: ["English"]
    },
    "Slovenia" => %{
      flag: "🇸🇮",
      artist: "Joker Out",
      song: "Carpe Diem",
      img: "slovenia.jpg",
      languages: ["Slovene"]
    },
    "Georgia" => %{
      flag: "🇬🇪",
      artist: "Iru",
      song: "Echo",
      img: "georgia.jpg",
      languages: ["English"]
    },
    "San Marino" => %{
      flag: "🇸🇲",
      artist: "Piqued Jacks",
      song: "Like an Animal",
      img: "sanmarino.png",
      languages: ["English"]
    },
    "Austria" => %{
      flag: "🇦🇹",
      artist: "Teya and Salena",
      song: "Who the Hell Is Edgar?",
      img: "austria.jpg",
      languages: ["English"]
    },
    "Albania" => %{
      flag: "🇦🇱",
      artist: "Albina & Familja Kelmendi",
      song: "Duje",
      img: "albania.webp",
      languages: ["Albanian"]
    },
    "Lithuania" => %{
      flag: "🇱🇹",
      artist: "Monika Linkytė",
      song: "Stay",
      img: "lithuania.jpg",
      languages: ["English"]
    },
    "Australia" => %{
      flag: "🇦🇺",
      artist: "Voyager",
      song: "Promise",
      img: "australia.jpg",
      languages: ["English"]
    },
    "France" => %{
      flag: "🇫🇷",
      artist: "La Zarra",
      song: "Évidemment",
      img: "france.jpg",
      languages: ["French"]
    },
    "Germany" => %{
      flag: "🇩🇪",
      artist: "Lord of the Lost",
      song: "Blood & Glitter",
      img: "germany.jpg",
      languages: ["English"]
    },
    "Italy" => %{
      flag: "🇮🇹",
      artist: "Marco Mengoni",
      song: "Due Vite",
      img: "italy.jpg",
      languages: ["Italian"]
    },
    "Spain" => %{
      flag: "🇪🇸",
      artist: "Blanca Palom",
      song: "Eaea",
      img: "spain.jpg",
      languages: ["Spanish"]
    },
    "Ukraine" => %{
      flag: "🇺🇦",
      artist: "Tvorchi",
      song: "Heart of Steel",
      img: "ukraine.jpg",
      languages: ["English", "Ukrainian"]
    },
    "United Kingdom" => %{
      flag: "🇬🇧",
      artist: "Mae Muller",
      song: "I Wrote a Song",
      img: "uk.jpg",
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

  def songs(2023, :semi_final_1) do
    list_songs_from(@semi_final_1)
  end

  def songs(2023, :semi_final_2) do
    list_songs_from(@semi_final_2)
  end

  def songs(2023, :final) do
    list_songs_from(@final)
  end

  def song_details(country) do
    @all_songs[country]
  end

  defp list_songs_from(show) do
    show
    |> Enum.map(fn %{ro: ro, country: country} ->
      %{ro: ro, country: country}
      |> Map.merge(Map.get(@all_songs, country))
    end)
  end
end
