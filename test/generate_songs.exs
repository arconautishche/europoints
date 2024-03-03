defmodule TempTest do
  use ExUnit.Case

  # First, we need to import the Floki module
  alias Pointex.Model.ReadModels.Shows
  alias Floki

  test "extract" do
    # Let's assume that the provided HTML is stored in a variable called html
    html = """
    <div class="container layout">
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/449774d5-c0a6-4785-8bee-c513208d8224.jpeg?h=53a6e391&amp;itok=uyF7WKfp" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/albania">
    <span class="image">
    <img src="/sites/default/files/AL_2.svg" alt="Albania">
    </span>
    <span>Albania</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/albina-familja-kelmendi-2023" rel="bookmark">
    <span>Albina &amp; Familja Kelmendi</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Duje
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-01/Brunette%20done.jpeg?h=186cd243&amp;itok=MRYtt4O2" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/armenia">
    <span class="image">
    <img src="/sites/default/files/AM_2.svg" alt="Armenia">
    </span>
    <span>Armenia</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/brunette-2023" rel="bookmark">
    <span>Brunette</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Future Lover
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/3537e159-08b5-423e-8e4e-b781f4b3774e.jpeg?itok=O9-d6VtL" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/australia">
    <span class="image">
    <img src="/sites/default/files/AU_2.svg" alt="Australia">
    </span>
    <span>Australia</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/voyager-2023" rel="bookmark">
    <span>Voyager</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Promise
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/88be0dba-fd52-4f0d-9c3e-eaf185e4da96_0.jpeg?h=23a79147&amp;itok=zhzm1FUp" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/austria">
    <span class="image">
    <img src="/sites/default/files/AT_2.svg" alt="Austria">
    </span>
    <span>Austria</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/teya-and-salena-2023" rel="bookmark">
    <span>Teya &amp; Salena</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Who The Hell Is Edgar?
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/ef4eabe8-efdc-4fa8-8a23-f54087e84aa6.jpeg?itok=kQMTEqmJ" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/azerbaijan">
    <span class="image">
    <img src="/sites/default/files/AZ_2.svg" alt="Azerbaijan">
    </span>
    <span>Azerbaijan</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/turalturanx-2023" rel="bookmark">
    <span>TuralTuranX</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Tell Me More
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/b2c1e94c-b35e-4d20-b147-5134252e7513.jpeg?itok=uoLL2xld" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/belgium">
    <span class="image">
    <img src="/sites/default/files/BE_2.svg" alt="Belgium">
    </span>
    <span>Belgium</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/gustaph-2023" rel="bookmark">
    <span>Gustaph</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Because Of You
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/5d2dd15e-e3f5-47f6-ab35-1bc8bcc73b0b.jpeg?itok=aABO-ReD" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/croatia">
    <span class="image">
    <img src="/sites/default/files/HR_0.svg" alt="Croatia">
    </span>
    <span>Croatia</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/let-3-2023" rel="bookmark">
    <span>Let 3</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Mama ŠČ!
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/07462922-d666-49db-adb2-fe18519dc111.jpeg?h=23c3f129&amp;itok=5QYnM_qY" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/cyprus">
    <span class="image">
    <img src="/sites/default/files/CY_0.svg" alt="Cyprus">
    </span>
    <span>Cyprus</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/andrew-lambrou-2023" rel="bookmark">
    <span>Andrew Lambrou</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Break A Broken Heart
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-02/026.jpg?h=bfd973b4&amp;itok=9Iw9EAPm" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/czechia">
    <span class="image">
    <img src="/sites/default/files/CZ_0.svg" alt="Czechia">
    </span>
    <span>Czech Republic</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/vesna-2023" rel="bookmark">
    <span>Vesna</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    My Sister's Crown
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/48044418-a725-4aaa-8e24-90c1069f6530.jpeg?h=784e8525&amp;itok=sJSw1hSa" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/denmark">
    <span class="image">
    <img src="/sites/default/files/DK_0.svg" alt="Denmark">
    </span>
    <span>Denmark</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/reiley-2023" rel="bookmark">
    <span>Reiley</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Breaking My Heart
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/3cf228c0-fe98-426c-ab70-58c5609b4082.jpeg?h=08c9bc6a&amp;itok=NUpN3mDi" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/estonia">
    <span class="image">
    <img src="/sites/default/files/EE_0.svg" alt="Estonia">
    </span>
    <span>Estonia</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/alika-2023" rel="bookmark">
    <span>Alika</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Bridges
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/4485f82f-38a6-42dc-bba0-e7c48f6adaf2.jpeg?h=d95d5961&amp;itok=LZgEsNXm" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/finland">
    <span class="image">
    <img src="/sites/default/files/FI_0.svg" alt="Finland">
    </span>
    <span>Finland</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/Kaarija-2023" rel="bookmark">
    <span>Käärijä</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Cha Cha Cha
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/1af0bb69-c32f-43e6-931e-f1550693ca63.jpeg?h=21bed124&amp;itok=d-USKIwi" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/france">
    <span class="image">
    <img src="/sites/default/files/FR_0.svg" alt="France">
    </span>
    <span>France</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/la-zarra-2023" rel="bookmark">
    <span>La Zarra</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Évidemment
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/7ef1086a-801c-471a-b989-cb3f3a9cfd19.jpeg?h=f0088780&amp;itok=yNEEf3l1" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/georgia">
    <span class="image">
    <img src="/sites/default/files/GE_0.svg" alt="Georgia">
    </span>
    <span>Georgia</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/iru-2023" rel="bookmark">
    <span>Iru</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Echo
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-01/LOTL_3%20-%20VD%20Pictures.jpg?h=97d2f479&amp;itok=ErW68kYY" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/germany">
    <span class="image">
    <img src="/sites/default/files/DE_0.svg" alt="Germany">
    </span>
    <span>Germany</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/lord-of-the-lost-2023" rel="bookmark">
    <span>Lord of the Lost</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Blood &amp; Glitter
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/6e2fe3e4-ad53-476a-8ed1-ac4cc168c60d.jpeg?h=26f2c4e2&amp;itok=U3IY5zlu" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/greece">
    <span class="image">
    <img src="/sites/default/files/GR_0.svg" alt="Greece">
    </span>
    <span>Greece</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/victor-vernicos-2023" rel="bookmark">
    <span>Victor Vernicos</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    What They Say
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/84a82fd1-6293-4224-9c48-3f717fc1ff7e.jpeg?h=1eeb85b1&amp;itok=9J8ngjMb" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/iceland">
    <span class="image">
    <img src="/sites/default/files/IS.svg" alt="Iceland">
    </span>
    <span>Iceland</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/dilja-2023" rel="bookmark">
    <span>Diljá</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Power
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/8d0750ee-32be-4ac9-a538-0e394eceb9df.jpeg?h=b2460ed6&amp;itok=xyub99VM" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/ireland">
    <span class="image">
    <img src="/sites/default/files/IE_0.svg" alt="Ireland">
    </span>
    <span>Ireland</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/wild-youth-2023" rel="bookmark">
    <span>Wild Youth</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    We Are One
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/8884881f-6ca9-477b-ae0d-8a4f4d8438d4.jpeg?h=1e2936cd&amp;itok=BshM2tmC" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/israel">
    <span class="image">
    <img src="/sites/default/files/IL_0.svg" alt="Israel">
    </span>
    <span>Israel</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/noa-kirel-2023" rel="bookmark">
    <span>Noa Kirel</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Unicorn
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/0781fa75-f6de-4c0e-9b36-2d0c8a56f9aa.jpeg?h=16717976&amp;itok=SKL77oJP" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/italy">
    <span class="image">
    <img src="/sites/default/files/IT_0.svg" alt="Italy">
    </span>
    <span>Italy</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/marco-mengoni-2023" rel="bookmark">
    <span>Marco Mengoni</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Due Vite
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/e974dda8-1bac-477c-b3bc-0bfc114c60f6_0.jpeg?h=bc55d9c4&amp;itok=uHREhGVm" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/latvia">
    <span class="image">
    <img src="/sites/default/files/LV_0.svg" alt="Latvia">
    </span>
    <span>Latvia</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/sudden-lights-2023" rel="bookmark">
    <span>Sudden Lights</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Aijā
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/0ac6d6a2-a000-4ed3-a649-87d57be0f105.jpeg?h=a13845c2&amp;itok=dl5Y-h-K" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/lithuania">
    <span class="image">
    <img src="/sites/default/files/LT_0.svg" alt="Lithuania">
    </span>
    <span>Lithuania</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/Monika-Linkyt%C4%97-2023" rel="bookmark">
    <span>Monika Linkytė</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Stay
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/91365ecb-10b3-4160-a26f-385c3ff4b335.jpeg?h=d2605b7e&amp;itok=lWTPCIxL" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/malta">
    <span class="image">
    <img src="/sites/default/files/MT.svg" alt="Malta">
    </span>
    <span>Malta</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/the-busker-2023" rel="bookmark">
    <span>The Busker</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Dance (Our Own Party)
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/5db65092-c94c-47bb-9f05-e11bf844cb98.jpeg?h=021f04f9&amp;itok=1sS8JeQU" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/moldova">
    <span class="image">
    <img src="/sites/default/files/MD_0.svg" alt="Moldova">
    </span>
    <span>Moldova</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/pasha-parfeni-2023" rel="bookmark">
    <span>Pasha Parfeni</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Soarele şi Luna
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/46c17872-bacd-4c46-9c01-83352d5788ed.jpeg?h=3bd9d3df&amp;itok=L8vmvMyQ" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/the-netherlands">
    <span class="image">
    <img src="/sites/default/files/NL.svg" alt="Netherlands">
    </span>
    <span>Netherlands</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/mia-nicolai-and-dion-cooper-2023" rel="bookmark">
    <span>Mia Nicolai &amp; Dion Cooper</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Burning Daylight
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/56466726-5b9d-45fc-890f-d1bc25211f6d.jpeg?h=edd2a7d9&amp;itok=JSRPsuqe" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/norway">
    <span class="image">
    <img src="/sites/default/files/NO.svg" alt="Norway">
    </span>
    <span>Norway</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/alessandra-2023" rel="bookmark">
    <span>Alessandra</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Queen of Kings
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/07187561-2289-4c64-8dee-af5afabf1303.jpeg?h=4595282c&amp;itok=BujALnpH" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/poland">
    <span class="image">
    <img src="/sites/default/files/PL.svg" alt="Poland">
    </span>
    <span>Poland</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/blanka-2023" rel="bookmark">
    <span>Blanka</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Solo
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/ad9a1d79-ca3b-4a56-b7e3-4ed6cdfada7f.jpeg?h=066afd71&amp;itok=gEA-KiZ2" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/portugal">
    <span class="image">
    <img src="/sites/default/files/PT.svg" alt="Portugal">
    </span>
    <span>Portugal</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/mimicat-2023" rel="bookmark">
    <span>Mimicat</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Ai Coração
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-02/DSC07654.jpg?h=02e69080&amp;itok=PupBlrys" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/romania">
    <span class="image">
    <img src="/sites/default/files/RO.svg" alt="Romania">
    </span>
    <span>Romania</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/theodor-andrei-2023" rel="bookmark">
    <span>Theodor Andrei</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    D.G.T. (Off and On)
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/48d6f605-6248-46ef-be91-2bbfa5634247.png?h=d17f33df&amp;itok=_vojXDZS" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/san-marino">
    <span class="image">
    <img src="/sites/default/files/SM.svg" alt="San Marino">
    </span>
    <span>San Marino</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/piqued-jacks-2023" rel="bookmark">
    <span>Piqued Jacks</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Like An Animal
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/83f4fed0-8c64-4775-8b8c-586828f9c185.jpeg?h=e6f8a7a2&amp;itok=dKjIHT1d" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/serbia">
    <span class="image">
    <img src="/sites/default/files/RS.svg" alt="Serbia">
    </span>
    <span>Serbia</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/luke-black-2023" rel="bookmark">
    <span>Luke Black</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Samo Mi Se Spava
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/f9380ed4-f0a3-406c-a10b-86de7f203ee1.jpeg?h=3b06d382&amp;itok=801Ap81G" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/slovenia">
    <span class="image">
    <img src="/sites/default/files/SI_2.svg" alt="Slovenia">
    </span>
    <span>Slovenia</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/joker-out-2023" rel="bookmark">
    <span>Joker Out</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Carpe Diem
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/013f7831-22e5-4eac-8265-ad76a4a8db9e.png?h=0220687c&amp;itok=Xmr06l2X" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/spain">
    <span class="image">
    <img src="/sites/default/files/ES_0.svg" alt="Spain">
    </span>
    <span>Spain</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/blanca-paloma-2023" rel="bookmark">
    <span>Blanca Paloma</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Eaea
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/fcfb7390-656f-4111-865f-f8ec2c26e77d.jpeg?h=998bca34&amp;itok=9dL7ZFmA" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/sweden">
    <span class="image">
    <img src="/sites/default/files/SE_2.svg" alt="Sweden">
    </span>
    <span>Sweden</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/loreen-2023" rel="bookmark">
    <span>Loreen</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Tattoo
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/cc806f68-fead-4e29-ab53-946b7057540b.jpeg?h=c5580b1b&amp;itok=t_AivCYd" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/switzerland">
    <span class="image">
    <img src="/sites/default/files/CH_2.svg" alt="Switzerland">
    </span>
    <span>Switzerland</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/remo-forrer-2023" rel="bookmark">
    <span>Remo Forrer</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    Watergun
    </div>
    </div>
    </article>
    <article role="article" class="watch-item">
      <div class="watch-item__media">
      <div class="watch-item__image">
      <picture>
      <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/a342befd-4e91-4a47-acb5-db89b856db58.jpeg?itok=DPgyswS6" title="a342befd-4e91-4a47-acb5-db89b856db58.jpeg">
      </picture>
      </div>
      </div>
      <div class="watch-item__info">
      <div class="watch-item__country">
      <a href="/country/ukraine">
      <span class="image">
      <img src="/sites/default/files/UA_2.svg" alt="Ukraine">
      </span>
      <span>Ukraine</span>
      </a>
      </div>
      <div class="watch-item__title">
      <a href="/participant/tvorchi-2023" rel="bookmark">
      <span>TVORCHI</span>
      </a>
      </div>
      <div class="watch-item__subtitle">
      Heart Of Steel
      </div>
      </div>
    </article>
    <article role="article" class="watch-item">
    <div class="watch-item__media">
    <div class="watch-item__image">
    <picture>
    <img src="/sites/default/files/styles/teaser/public/media/image/2023-03/ed43292f-a5fb-4cba-b0f6-9c90b14cd1fb_0.jpeg?h=796e0efb&amp;itok=mJyAzf8Y" alt="">
    </picture>
    </div>
    </div>
    <div class="watch-item__info">
    <div class="watch-item__country">
    <a href="/country/united-kingdom">
    <span class="image">
    <img src="/sites/default/files/GB_0.svg" alt="United Kingdom">
    </span>
    <span>United Kingdom</span>
    </a>
    </div>
    <div class="watch-item__title">
    <a href="/participant/mae-muller-2023" rel="bookmark">
    <span>Mae Muller</span>
    </a>
    </div>
    <div class="watch-item__subtitle">
    I Wrote A Song
    </div>
    </div>
    </article>
    </div>
    """

    html
    |> Floki.find("article")
    |> Enum.map(fn article ->
      # Extract the country name and image URL
      country =
        article
        |> Floki.find(".watch-item__country span")
        |> Enum.at(1)
        |> Floki.text()
        |> IO.inspect()

      image_url =
        article
        |> Floki.find(".watch-item__image img")
        |> hd()
        |> Floki.attribute("src")
        |> hd()

      # Create a map with the country name and image URL
      {country,
       Shows.song_details(country) |> Map.merge(%{img: "https://eurovision.tv" <> image_url})}
    end)
    |> Enum.into(%{})
    |> IO.inspect()
  end
end
