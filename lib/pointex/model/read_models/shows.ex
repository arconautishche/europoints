defmodule Pointex.Model.ReadModels.Shows do
  @all_songs %{
    "Sweden" => %{
      artist: "Loreen",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/fcfb7390-656f-4111-865f-f8ec2c26e77d.jpeg",
      song: "Tattoo"
    },
    "Greece" => %{
      artist: "Victor Vernicos",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/6e2fe3e4-ad53-476a-8ed1-ac4cc168c60d.jpeg",
      song: "What They Say"
    },
    "France" => %{
      artist: "La Zarra",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/1af0bb69-c32f-43e6-931e-f1550693ca63.jpeg",
      song: "Évidemment"
    },
    "Armenia" => %{
      artist: "Brunette",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-01/Brunette%20done.jpeg",
      song: "Future Lover"
    },
    "San Marino" => %{
      artist: "Piqued Jacks",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/48d6f605-6248-46ef-be91-2bbfa5634247.png",
      song: "Like an Animal"
    },
    "United Kingdom" => %{
      artist: "Mae Muller",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/ed43292f-a5fb-4cba-b0f6-9c90b14cd1fb_0.jpeg",
      song: "I Wrote a Song"
    },
    "Serbia" => %{
      artist: "Luke Black",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/83f4fed0-8c64-4775-8b8c-586828f9c185.jpeg",
      song: "Samo mi se spava"
    },
    "Spain" => %{
      artist: "Blanca Palom",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/013f7831-22e5-4eac-8265-ad76a4a8db9e.png",
      song: "Eaea"
    },
    "Ireland" => %{
      artist: "Wild Youth",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/8d0750ee-32be-4ac9-a538-0e394eceb9df.jpeg",
      song: "We Are One"
    },
    "Moldova" => %{
      artist: "Pasha Parfeni",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/5db65092-c94c-47bb-9f05-e11bf844cb98.jpeg",
      song: "Soarele și luna"
    },
    "Denmark" => %{
      artist: "Reiley",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/48044418-a725-4aaa-8e24-90c1069f6530.jpeg",
      song: "Breaking My Heart"
    },
    "Israel" => %{
      artist: "Noa Kirel",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/8884881f-6ca9-477b-ae0d-8a4f4d8438d4.jpeg",
      song: "Unicorn"
    },
    "Czechia" => %{
      artist: "Vesna",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-02/026.jpg",
      song: "My Sister's Crown"
    },
    "Malta" => %{
      artist: "The Busker",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/91365ecb-10b3-4160-a26f-385c3ff4b335.jpeg",
      song: "Dance (Our Own Party)"
    },
    "Albania" => %{
      artist: "Albina & Familja Kelmendi",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/449774d5-c0a6-4785-8bee-c513208d8224.jpeg",
      song: "Duje"
    },
    "Slovenia" => %{
      artist: "Joker Out",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/f9380ed4-f0a3-406c-a10b-86de7f203ee1.jpeg",
      song: "Carpe Diem"
    },
    "Poland" => %{
      artist: "Blanka",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/07187561-2289-4c64-8dee-af5afabf1303.jpeg",
      song: "Solo"
    },
    "Lithuania" => %{
      artist: "Monika Linkytė",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/0ac6d6a2-a000-4ed3-a649-87d57be0f105.jpeg",
      song: "Stay"
    },
    "Iceland" => %{
      artist: "Diljá",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/84a82fd1-6293-4224-9c48-3f717fc1ff7e.jpeg",
      song: "Power"
    },
    "Switzerland" => %{
      artist: "Remo Forrer",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/cc806f68-fead-4e29-ab53-946b7057540b.jpeg",
      song: "Watergun"
    },
    "Cyprus" => %{
      artist: "Andrew Lambrou",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/07462922-d666-49db-adb2-fe18519dc111.jpeg",
      song: "Break a Broken Heart"
    },
    "Belgium" => %{
      artist: "Gustaph",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/b2c1e94c-b35e-4d20-b147-5134252e7513.jpeg",
      song: "Because of You"
    },
    "Croatia" => %{
      artist: "Let 3",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/5d2dd15e-e3f5-47f6-ab35-1bc8bcc73b0b.jpeg",
      song: "Mama ŠČ!"
    },
    "Austria" => %{
      artist: "Teya and Salena",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/88be0dba-fd52-4f0d-9c3e-eaf185e4da96_0.jpeg",
      song: "Who the Hell Is Edgar?"
    },
    "Latvia" => %{
      artist: "Sudden Lights",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/e974dda8-1bac-477c-b3bc-0bfc114c60f6_0.jpeg",
      song: "Aijā"
    },
    "Azerbaijan" => %{
      artist: "TuralTuranX",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/ef4eabe8-efdc-4fa8-8a23-f54087e84aa6.jpeg",
      song: "Tell Me More"
    },
    "Australia" => %{
      artist: "Voyager",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/3537e159-08b5-423e-8e4e-b781f4b3774e.jpeg",
      song: "Promise"
    },
    "Estonia" => %{
      artist: "Alika",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/3cf228c0-fe98-426c-ab70-58c5609b4082.jpeg",
      song: "Bridges"
    },
    "Finland" => %{
      artist: "Käärijä",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/4485f82f-38a6-42dc-bba0-e7c48f6adaf2.jpeg",
      song: "Cha Cha Cha"
    },
    "Ukraine" => %{
      artist: "Tvorchi",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/a342befd-4e91-4a47-acb5-db89b856db58.jpeg",
      song: "Heart of Steel"
    },
    "Netherlands" => %{
      artist: "Mia Nicolai and Dion Cooper",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/46c17872-bacd-4c46-9c01-83352d5788ed.jpeg",
      song: "Burning Daylight"
    },
    "Norway" => %{
      artist: "Alessandra",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/56466726-5b9d-45fc-890f-d1bc25211f6d.jpeg",
      song: "Queen of Kings"
    },
    "Portugal" => %{
      artist: "Mimicat",
      img:
        "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/ad9a1d79-ca3b-4a56-b7e3-4ed6cdfada7f.jpeg?h=066afd71&itok=gEA-KiZ2",
      song: "Ai coração"
    },
    "Germany" => %{
      artist: "Lord of the Lost",
      img:
        "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-01/LOTL_3%20-%20VD%20Pictures.jpg?h=97d2f479&itok=ErW68kYY",
      song: "Blood & Glitter"
    },
    "Georgia" => %{
      artist: "Iru",
      img:
        "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/7ef1086a-801c-471a-b989-cb3f3a9cfd19.jpeg?h=f0088780&itok=yNEEf3l1",
      song: "Echo"
    },
    "Romania" => %{
      artist: "Theodor Andrei",
      img: "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-02/DSC07654.jpg?h=02e69080&itok=PupBlrys",
      song: "D.G.T. (Off and On)"
    },
    "Italy" => %{
      artist: "Marco Mengoni",
      img:
        "https://eurovision.tv/sites/default/files/styles/teaser/public/media/image/2023-03/0781fa75-f6de-4c0e-9b36-2d0c8a56f9aa.jpeg?h=16717976&itok=SKL77oJP",
      song: "Due Vite"
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

  @final [
    %{ro: 1, country: "Austria"},
    %{ro: 2, country: "Portugal"},
    %{ro: 3, country: "Switzerland"},
    %{ro: 4, country: "Poland"},
    %{ro: 5, country: "Serbia"},
    %{ro: 6, country: "France"},
    %{ro: 7, country: "Cyprus"},
    %{ro: 8, country: "Spain"},
    %{ro: 9, country: "Sweden"},
    %{ro: 10, country: "Albania"},
    %{ro: 11, country: "Italy"},
    %{ro: 12, country: "Estonia"},
    %{ro: 13, country: "Finland"},
    %{ro: 14, country: "Czech Republic"},
    %{ro: 15, country: "Australia"},
    %{ro: 16, country: "Belgium"},
    %{ro: 17, country: "Armenia"},
    %{ro: 18, country: "Moldova"},
    %{ro: 19, country: "Ukraine"},
    %{ro: 20, country: "Norway"},
    %{ro: 21, country: "Germany"},
    %{ro: 22, country: "Lithuania"},
    %{ro: 23, country: "Israel"},
    %{ro: 24, country: "Slovenia"},
    %{ro: 25, country: "Croatia"},
    %{ro: 26, country: "United Kingdom"}
  ]

  def songs(2023) do
    @all_songs
  end

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
