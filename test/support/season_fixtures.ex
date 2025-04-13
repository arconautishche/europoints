defmodule Pointex.Test.SeasonFixtures do
  def generate_songs(year) do
    Pointex.Europoints.Season.import_songs(year, [
      %{
        name: "Sjerm",
        country: "Albania",
        img: "https://eurovision.tv/sites/default/files/styles/banner/public/media/image/2024-12/shkodra-elektronike.jpg?itok=vsOod8Q2",
        artist: "Shkodra Elektronike",
        order_in_final: nil,
        order_in_sf1: 12,
        order_in_sf2: nil
      },
      %{
        name: "SURVIVOR",
        country: "Armenia",
        img: "https://eurovision.tv/sites/default/files/styles/banner/public/media/image/2025-02/pargarmenia25.jpeg?h=cff42d3a&itok=2Q8-Nt-f",
        artist: "PARG",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 5
      },
      %{
        name: "Milkshake Man",
        country: "Australia",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-02/GoJo_JeremyKeesOrr_09.jpg?h=5195bb07&itok=r_Rx5ZVd",
        artist: "Go-Jo",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 1
      },
      %{
        name: "Wasted Love",
        country: "Austria",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-01/ESC25_AUT_JJ_full-28.jpg?h=6143e829&itok=OXcFnxrT",
        artist: "JJ",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 6
      },
      %{
        name: "Run With U",
        country: "Azerbaijan",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/MAMAGAMA-1.jpg?h=4445faf9&itok=GBiNioIK",
        artist: "Mamagama",
        order_in_final: nil,
        order_in_sf1: 10,
        order_in_sf2: nil
      },
      %{
        name: "Strobe Lights",
        country: "Belgium",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/RED-SEBASTIAN-1-adjust.jpg?h=7e7caea9&itok=eRY8kMWY",
        artist: "Red Sebastian",
        order_in_final: nil,
        order_in_sf1: 9,
        order_in_sf2: nil
      },
      %{
        name: "Poison Cake",
        country: "Croatia",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/Croatia_Poison_Cake_Marko_Bosnjak_1.jpg?h=d6d43ece&itok=bMAnyaLq",
        artist: "Marko Bošnjak",
        order_in_final: nil,
        order_in_sf1: 14,
        order_in_sf2: nil
      },
      %{
        name: "Shh",
        country: "Cyprus",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/SHH-COVER-PHOTO-2.jpg?h=f8a52a4c&itok=ZRfzU6L3",
        artist: "Theo Evan",
        order_in_final: nil,
        order_in_sf1: 15,
        order_in_sf2: nil
      },
      %{
        name: "Kiss Kiss Goodbye",
        country: "Czechia",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/DAVID_URBAN_ADONXS_COVER_ART_03-kopie.jpg?h=12c6f0a9&itok=bYlKfTZm",
        artist: "ADONXS",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 12
      },
      %{
        name: "Hallucination",
        country: "Denmark",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/edit4.png?itok=oY3DGiSe",
        artist: "Sissal",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 11
      },
      %{
        name: "Espresso Macchiato",
        country: "Estonia",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/10.jpg?h=6bde16c2&itok=6d3iI822",
        artist: "Tommy Cash",
        order_in_final: nil,
        order_in_sf1: 4,
        order_in_sf2: nil
      },
      %{
        name: "ICH KOMME",
        country: "Finland",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/LOVETAR_1-NelliKentta.jpg?h=2783956c&itok=3ZcQyhN0",
        artist: "Erika Vikman",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 16
      },
      %{
        name: "maman",
        country: "France",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-04/8da8b004-fca4-4d82-bb02-0498282d08da-2.jpg?itok=EHiTLSmr",
        artist: "Louane",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: nil
      },
      %{
        name: "Freedom",
        country: "Georgia",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/IMG_4371.jpg?h=a45cbb2e&itok=4Yuchjmj",
        artist: "Mariam Shengelia",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 10
      },
      %{
        name: "Baller",
        country: "Germany",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/23_10_11-C-LINHNGUYEN_Abor-Tynna_019.jpg?h=fe3f4cff&itok=gqpTisAB",
        artist: "Abor & Tynna",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: nil
      },
      %{
        name: "Asteromáta",
        country: "Greece",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/GR-KLAVDIA_04.jpg?h=20510505&itok=fcaVvHxu",
        artist: "Klavdia",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 7
      },
      %{
        name: "RÓA",
        country: "Iceland",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/IMG_6644.jpg?h=f0fd4ca4&itok=B0yDbmn1",
        artist: "VÆB",
        order_in_final: nil,
        order_in_sf1: 1,
        order_in_sf2: nil
      },
      %{
        name: "Laika Party",
        country: "Ireland",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/v1-olemartinsandness-Emmy_134.jpg?h=8c728c9e&itok=EbpYDmZI",
        artist: "EMMY",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 3
      },
      %{
        name: "New Day Will Rise",
        country: "Israel",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/Yuval-Raphael-PR-1-BEST.jpg?h=7eef1963&itok=LRjr3QqV",
        artist: "Yuval Raphael",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 14
      },
      %{
        name: "Lucio Corsi",
        country: "Italy",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/DSCF8932-Landscape-Credit-Simone-Biavati.jpg?itok=sgHdB4kW",
        artist: "Volevo Essere Un Duro",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: nil
      },
      %{
        name: "Bur Man Laimi",
        country: "Latvia",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/Tautumeitas_8.jpg?h=5097032e&itok=DIAonjfc",
        artist: "Tautumeitas",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 4
      },
      %{
        name: "Tavo Akys",
        country: "Lithuania",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/1-katarsis.jpg?itok=lPNHD4AK",
        artist: "Katarsis",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 8
      },
      %{
        name: "La Poupée Monte Le Son",
        country: "Luxembourg",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/Laura-20.02.2025-884.jpg?h=8810d7df&itok=3brAsu51",
        artist: "Laura Thorn",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 13
      },
      %{
        name: "SERVING",
        country: "Malta",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/Miriana-Official-Shoot-07.jpg?h=61fa50b8&itok=qQ232U3w",
        artist: "Miriana Conte",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 9
      },
      %{
        name: "Dobrodošli",
        country: "Montenegro",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/Nina-Zizic-1.jpeg?h=25cad640&itok=I_ybk9tq",
        artist: "Nina Žižić",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 2
      },
      %{
        name: "C'est La Vie",
        country: "Netherlands",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-02/TB_Claude_Press_31499.jpg?h=2b572afe&itok=x3qona8I",
        artist: "Claude",
        order_in_final: nil,
        order_in_sf1: 13,
        order_in_sf2: nil
      },
      %{
        name: "Lighter",
        country: "Norway",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/3-Kyle-Alessandro-2025-03-05-pressebilder-048-TorHakon.JPG?h=1ca26648&itok=p7AM7sQR",
        artist: "Kyle Alessandro",
        order_in_final: nil,
        order_in_sf1: 8,
        order_in_sf2: nil
      },
      %{
        name: "GAJA",
        country: "Poland",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/Justyna-Steczkowska-main.jpg?itok=bz_da__k",
        artist: "Justyna Steczkowska",
        order_in_final: nil,
        order_in_sf1: 2,
        order_in_sf2: nil
      },
      %{
        name: "Deslocado",
        country: "Portugal",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/07_NAPA.jpg?h=03ccecd2&itok=QUlFowrS",
        artist: "NAPA",
        order_in_final: nil,
        order_in_sf1: 7,
        order_in_sf2: nil
      },
      %{
        name: "Tutta L'Italia",
        country: "San Marino",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/240724_GabryPonte0749.jpg?h=769e5664&itok=W3xBzv8x",
        artist: "Gabry Ponte",
        order_in_final: nil,
        order_in_sf1: 11,
        order_in_sf2: nil
      },
      %{
        name: "Mila",
        country: "Serbia",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-04/Princ-photo-2-by-Nikola-Glisic.jpeg?h=37e0424a&itok=O2pMgT_o",
        artist: "Princ",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: 15
      },
      %{
        name: "How Much Time Do We Have Left",
        country: "Slovenia",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-04/Klemen_How-Much-Time-Do-We-Have-Left_3_Tomo-Brejc.jpg?h=86e69b69&itok=vENHE4dI",
        artist: "Klemen",
        order_in_final: nil,
        order_in_sf1: 3,
        order_in_sf2: nil
      },
      %{
        name: "ESA DIVA",
        country: "Spain",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/Melody-Eurovison44033_v1-copia.jpg?h=080709a8&itok=YBzY32nM",
        artist: "Melody",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: nil
      },
      %{
        name: "Bara Bada Bastu",
        country: "Sweden",
        img:
          "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/BARABADABASTU-07C-Fotograf-Erik-Ahman.jpg?h=abddad90&itok=DoSSxP1U",
        artist: "KAJ",
        order_in_final: nil,
        order_in_sf1: 6,
        order_in_sf2: nil
      },
      %{
        name: "Voyage",
        country: "Switzerland",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/1_HR_O7A4734.jpg?h=85cff267&itok=GAVt-cyq",
        artist: "Zoë Më",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: nil
      },
      %{
        name: "Bird of Pray",
        country: "Ukraine",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/DSC00359.jpg?h=0f39a6c3&itok=9QM0U-ZC",
        artist: "Ziferblat",
        order_in_final: nil,
        order_in_sf1: 5,
        order_in_sf2: nil
      },
      %{
        name: "What The Hell Just Happened?",
        country: "United Kingdom",
        img: "https://eurovision.tv/sites/default/files/styles/og_image/public/media/image/2025-03/DSC_3336_V2.jpg?h=cae35e29&itok=2VtDtYGJ",
        artist: "Remember Monday",
        order_in_final: nil,
        order_in_sf1: nil,
        order_in_sf2: nil
      }
    ])

    Ash.get!(Pointex.Europoints.Season, year)
  end
end
