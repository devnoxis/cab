# Research: TES-29 — Sprawdź dla mnie

## Problem Understanding

Zgłoszenie prosi o znalezienie 3 przykładowych aplikacji mobilnych dotyczących wędkarstwa i opisanie 3 najważniejszych funkcji każdej z nich. Cel: zrozumienie oczekiwań wędkarzy wobec aplikacji mobilnych.

> "Znajdź 3 przykładowe apki mobilne dotyczące wędkarstwa i opisz 3 najważniejsze ich funkcje aby zobaczyć czego oczekują wędkarze."

---

## Relevant Context and Background

Rynek aplikacji mobilnych dla wędkarzy jest dojrzały i konkurencyjny. Dominujące kategorie funkcji to:
- **Nawigacja i mapy głębokości** — kluczowe przy wędkarzach łodziowych
- **Prognozowanie aktywności ryb** — oparte na solunarze, pogodzie, fazach księżyca
- **Logowanie połowów** — dziennik z danymi o miejscu, przynęcie i warunkach
- **Funkcje społecznościowe** — wymiana doświadczeń, mapa połowów innych użytkowników

---

## Aplikacje i ich funkcje

### 1. Fishbrain

**Opis:** Jedna z największych platform wędkarskich na świecie — ponad 15 milionów zarejestrowanych użytkowników. Łączy dane tłumu (crowd-sourcing) z prognozowaniem opartym na AI.

**Platforma:** iOS, Android | **Model:** freemium (subskrypcja Pro)

#### 3 najważniejsze funkcje:

1. **Prognozowanie BiteTime (AI)** — System oparty na milionach raportów wędkarzy. Uwzględnia pogodę, pływy, fazy księżyca, prędkość wiatru i sezonowość. Podpowiada najlepsze godziny do wędkowania w konkretnym miejscu.

2. **Mapa połowów z 14 milionami lokalizacji** — Interaktywna mapa (opartą na Garmin Navionics) z danymi batometrycznymi. Użytkownicy widzą w czasie rzeczywistym, gdzie łowiono ryby, mogą filtrować po gatunkach i odkrywać nowe łowiska, miejsca cumowania i punkty dostępu.

3. **Dziennik połowów z rozpoznawaniem gatunków** — Logbook rejestruje szczegóły: przynęta, warunki, lokalizacja. Funkcja "Fish Verify" rozpoznaje gatunek ryby ze zdjęcia. Subskrybenci Pro uzyskują zaawansowane analizy z podziałem na porę dnia, fazę księżyca i temperaturę wody.

---

### 2. FishAngler

**Opis:** Aplikacja all-in-one łącząca logowanie połowów, prognozy wędkarskie, mapy głębokości i sieć społecznościową. Bezpłatna z opcjonalnym VIP.

**Platforma:** iOS, Android | **Model:** freemium (subskrypcja VIP)

#### 3 najważniejsze funkcje:

1. **Szczegółowe logowanie połowów (45+ atrybutów)** — Jeden z najbardziej rozbudowanych systemów prowadzenia dziennika połowów. Rejestruje lokalizację GPS, zdjęcia, rodzaj przynęty, warunki wodne, fazy solunarne, pogodę i wiele więcej — wszystko przy jednym połowie.

2. **Prognozy solunarne i szczytowe okna aktywności ryb** — Dla dowolnego akwenu aplikacja generuje okna szczytowej aktywności ryb na podstawie solunarzu, temperatury wody, pływów i prądów. Pomaga planować wyjścia w godziny o maksymalnej aktywności ryb.

3. **Mapy głębokości 3D i kontury jeziora (VIP, Garmin Navionics)** — Użytkownicy VIP odblokowują: dokładne lokalizacje połowów innych użytkowników, kontury głębokości jeziora w wysokiej rozdzielczości oraz trójwymiarowe mapy podwodnego terenu. Daje wędkarzom przewagę przy lokalizowaniu struktur podwodnych.

---

### 3. Navionics Boating

**Opis:** Branżowy standard w nawigacji morskiej i jeziorowej (własność Garmin). Aplikacja skupia się na mapowaniu i nawigacji, a nie funkcjach społecznościowych. Szczególnie popularna wśród wędkarzy łodziowych.

**Platforma:** iOS, Android | **Cena:** ~24,99 USD/rok

#### 3 najważniejsze funkcje:

1. **Mapy batometryczne SonarChart HD** — Dane głębokości z rozdzielczością do 0,5 m dla jezior i wód przybrzeżnych. Możliwość wyświetlania do 5 zakresów głębokości jednocześnie, co ułatwia identyfikację struktur podwodnych i łowisk. Funkcja **SonarChart Live** pozwala tworzyć własne mapy głębokości w czasie rzeczywistym z sonaru łódki.

2. **Auto Guidance+ — planowanie trasy** — Generuje sugerowane trasy nawigacyjne od brzegu do brzegu z uwzględnieniem danych z map i oznakowania nawigacyjnego. Wyświetla ETA, odległość, kurs i szacunkowe zużycie paliwa. Szczególnie wartościowe podczas wypraw morskich i na dużych jeziorach.

3. **Prognoza pogody, pływy i prądy w czasie rzeczywistym** — Integruje aktualne prognozy pogody, dane wiatru, przewidywania pływów i informacje o prądach bezpośrednio na widoku mapy. Możliwość zapisu map offline — kluczowe przy wędkowaniu w zasięgu bez zasięgu komórkowego.

---

## Technical Considerations

Analiza trzech aplikacji wskazuje na następujące oczekiwania technologiczne wędkarzy:

| Obszar | Oczekiwania wędkarzy |
|--------|---------------------|
| **Mapy** | Mapy głębokości HD, dane batometryczne, widok 3D |
| **Prognozy** | AI / solunar, uwzględnienie pogody, księżyca, temperatury wody |
| **Logowanie** | Szczegółowy dziennik połowów z GPS, zdjęciem, przynętą, warunkami |
| **Społeczność** | Mapy połowów innych użytkowników, wymiana doświadczeń |
| **Offline** | Dostęp do map bez internetu |
| **Rozpoznawanie** | Identyfikacja gatunków ryb ze zdjęcia (AI) |

---

## Potential Approaches or Solutions

Jeśli celem zgłoszenia jest planowanie własnej aplikacji lub funkcjonalności dla wędkarzy, kluczowe wnioski to:

1. **Must-have:** dziennik połowów z GPS i zdjęciami, mapy (nawet podstawowe), prognoza aktywności ryb.
2. **Wyróżnik konkurencyjny:** AI do rozpoznawania gatunków, prognozowanie oparte na lokalnych danych historycznych.
3. **Monetyzacja:** model freemium sprawdza się dobrze — darmowy dostęp + premium mapy/analizy (Fishbrain Pro, FishAngler VIP).
4. **Offline-first:** wędkarze często są w miejscach bez zasięgu — praca offline to nie opcja, lecz wymóg.

---

## Open Questions

1. Jaki jest cel tego researchu — benchmarking przed budową własnej aplikacji, czy analiza rynku?
2. Czy interesują tylko aplikacje globalnie popularne, czy też lokalne (polskie) aplikacje dla wędkarzy?
3. Czy chodzi o aplikacje do wędkarstwa słodkowodnego, morskiego, czy obu typów?
4. Czy zakres ma być rozszerzony o aplikacje związane z regulacjami prawnymi wędkarstwa (np. zezwolenia, limity połowów) — tego nie obejmuje żadna z przebadanych aplikacji?

---

## Sources

- Fishbrain: https://fishbrain.com/features
- FishAngler: https://www.fishangler.com/
- Navionics Boating: https://www.navionics.com/apps/navionics-boating
