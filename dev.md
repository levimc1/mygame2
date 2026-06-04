# MYGAME

## dev.md (ez a file)
Csak ide írok mindent a projektről miközben dolgozok, nem README.md

Ha akármilyen másik projektbe kezdel aminek célja egy játék, jöjjön ide!

## Konvenciók, eszközök:
 - **Modulokat használunk** (.cpp, .cppm) 
 - az **xmake** build rendszert. bár ez nem jön ide. 
 - **git**-et, de NEM githubon keresztül. mert Microsoft.
 - **BSTD** az STL helyett, ha valami hiányzik, sajnos fejleszteni kell.
 - Legyen **Magyar nyelvű** dokumentáció, commentek, közösség. **NEM KÓD**
 - Függvény konvenció -> igével kezdődik, snake_case
 - Struct konvenció -> főnév, PascalCase
 - Akármilyen függvény neve ne legyen túl rövid, ha van egy hoszabb érthetőbb név használd! 
 - Teljes template nevek, amiket itt a dev.md-ben megszegek. T -> Type. E -> Error


Az 1. projekt nem is a játék, hanem:
## BSTD

**Konvenciók:**
 - A Fenti
 - Matematikai megközelítés. 
 - Forráskódnak úgy kell olvasnia mint egy mondatnak:
    detail:: segítségével sok absztrakció, és detail:: lehet spagetti
 - Kötelező tesztek mindenre, detail::-ben is!

Egy rustosabb, modernebb, egyszerűbb, olvashatóbb C++ STL.
Ezáltal nem fogok használni akármilyen STD dolgot. 

Az alapoktól szeretnék szükség alapján felfelé nőni. mint a mcy/best githubon.
Csak ő egy meleg femboy aki Furry NSFW tartalmat gyárt.. Inspirációnál több ne legyen.
Valamiért nem bízok meg az ő eszközének használatában. pedig jófejnek tűnt elsőre.

### Alaptípusok:
**Ami nem allokál és ja.**
- Tuple<A, B, ...> -> Típusai mind léteznek
- Sum<A, B, ...> -> Csak 1 típusa lehet egyszerre 
- Result<T, E> -> Hiba vagy T
- Option<T> -> 1 T lehet hogy van, lehet hogy nincs.
- Vec<N, T> -> egyszerre N T számokkal
- Mat<R, C, T> -> mátrix dolog :/
- Array<N, T> -> szintén N darab T DE nem számokkal.
- Pair<K, V> -> Sum<K, V> extra műveletekkel
**Ez még nem egy komplett model csak egy feature lista**
Lehet kelleni fog iter, meg stb. 

**Hozzászólás**
Mind különálló, detail:: implementációkkal. Konvenció alapján jól kommentálva.
Lehetne Quat és Complex de majd ha megértem őket max :/**

**Ábra:**

´´´
bstd::detail::
┌─────────────────────────────────────────────────────┐
│             nyers, optimalizált, spagetti           │
└──────────────────────┬──────────────────────────────┘
                       │ organizálja 
bstd::core::           ▼
┌──────────────────────────────────────────────────────┐
│         tiszta API, dokumentált, tesztelt            │
└──────────────────────────────────────────────────────┘
´´´

Ez csak Core, lesz még ugye Map, és Owning dolgok, meg String meg bla blah blaugye Map, és Owning dolgok, meg String meg bla blah blahh
ide fog kelleni inkább a detail.

Bár néhány ilyen piszok egyszerű. és a bstd::detail:: dolog nem működne szerintem.
Itt a probléma inkább a dependencia. Attól még mind1 egyedi lesz. 
