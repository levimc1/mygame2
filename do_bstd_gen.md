# BSTD — Better Standard

> Egy modern, gyorsabb, egyszerűbb és olvashatóbb alternatíva a 40 éves C++ STL-re.  
> Gyökér namespace: `bstd::`

---

## Tartalomjegyzék

1. [Konvenciók](#konvenciók)
2. [Primitív típusok](#primitív-típusok)
3. [Adatstruktúrák](#adatstruktúrák)
   - [Result](#result)
   - [Option](#option)
   - [Sum](#sum)
   - [Tuple](#tuple)
   - [Vec](#vec)
   - [Array](#array)
   - [Seq](#seq)
   - [Mat](#mat)
   - [Map / OrderedMap](#map--orderedmap)
   - [Set / OrderedSet](#set--orderedset)
   - [Pair](#pair)
   - [Complex](#complex)
   - [String / StringView](#string--stringview)
   - [BitSet / BitField](#bitset--bitfield)
4. [Eszközök](#eszközök)
   - [Fájlkezelés](#fájlkezelés)
   - [Szálkezelés](#szálkezelés)
   - [Math](#math)
   - [Idő](#idő)
   - [Range és iterátorok](#range-és-iterátorok)
5. [Tervezett funkciók](#tervezett-funkciók)

---

## Konvenciók

| Téma | Szabály |
|---|---|
| Build rendszer | **Xmake** |
| C++ szabvány | **C++20**, modulok (`.cpp` és `.cppm`) |
| STD / kivételek | **Nincs** — sem `std::`, sem `throw` |
| Verziókezelés | **Git** |
| Függvények | `igével_kezdődnek`, `snake_case`, érthető > rövid |
| Struktúrák | `PascalCase`, alapból `struct` |
| Template paraméterek | Teljes nevek: `Type`, `Error`, `Key`, `Value`, stb. |
| Dokumentáció | Magyarul, de a kód maga angolul marad |
| Filosofia | A kód legyen a dokumentáció; `detail::` angolul összefoglalva |
| Névkonvenciók | Matematikai: `Vec`, `Seq`, `Sum`, `Tuple`, stb. |
| Tesztelés | **Minden**re van teszt |
| Cél | Modernebb mint Rust + explicit mint Zig, ahol szükséges |

---

## Primitív típusok

```cpp
i8   i16   i32   i64   i128   // előjeles egészek
u8   u16   u32   u64   u128   // előjel nélküli egészek
f32  f64                      // lebegőpontos számok
```

---

## Adatstruktúrák

---

### Result

```cpp
Result<Ok, Error>
```

Tárol **vagy** egy `Ok` értéket, **vagy** egy `Error`-t.  
Az `Error` egy concept: képesnek kell lennie hibaüzenetet (stringet) visszaadni.

#### Konstruálás

```cpp
auto res = Result<int, String>::Ok(42);
auto err = Result<int, String>::Error("valami hiba");
return Result<int, String>::Error("hiba");
```

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `is_ok()` | `bool` | Igaz, ha ok |
| `is_error()` | `bool` | Igaz, ha hiba |
| `unwrap()` | `Ok` | Visszaadja az ok értéket, vagy **pánik** |
| `unwrap_or(value)` | `Ok` | Ok értéket ad, különben `value`-t |
| `unwrap_or_default()` | `Ok` | Ok értéket ad, különben `Ok` default értékét — compile hiba, ha `Ok` nem felel meg a `Default` conceptnek |
| `transform(fn)` | `void` | Ha ok, alkalmazza `fn`-t |
| `transform_error(fn)` | `void` | Ha hiba, alkalmazza `fn`-t |
| `and_then(fn)` | chainelhető | Ha ok, futtatja `fn`-t |
| `match(ok_fn, err_fn)` | — | Ok esetén `ok_fn`, hiba esetén `err_fn` fut |
| `ok()` | `Option<Ok>` | Castolja `Option<Ok>`-ra |
| `error()` | `Option<Error>` | Castolja `Option<Error>`-ra |

#### Típus tagok

```cpp
Result<Ok, Error>::Ok     // az Ok típusa
Result<Ok, Error>::Error  // az Error típusa
```

---

### Option

```cpp
Option<Some>
```

Tárol **vagy** egy `Some` értéket, **vagy** semmit (`None`).

#### Konstruálás

```cpp
auto val  = Option<int>::Some(5);
auto none = Option<int>::None();
```

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `is_some()` | `bool` | Igaz, ha van értéke |
| `is_none()` | `bool` | Igaz, ha üres |
| `unwrap()` | `Some` | Visszaadja az értéket, vagy **pánik** |
| `unwrap_or(value)` | `Some` | Értéket ad, különben `value`-t |
| `unwrap_or_default()` | `Some` | Értéket ad, különben `Some` default értékét |
| `transform(fn)` | `Option<U>` | Ha some, alkalmazza `fn`-t, az eredmény új `Option` |
| `and_then(fn)` | chainelhető | Ha some, futtatja `fn`-t |
| `or_else(fn)` | `Option<Some>` | Ha none, futtatja `fn`-t |
| `match(some_fn, none_fn)` | — | Some esetén `some_fn`, none esetén `none_fn` fut |
| `ok_or(error)` | `Result<Some, E>` | Castolja `Result`-ra |

---

### Sum

```cpp
Sum<Type...>
```

A C++ `std::variant` matematikai megfelelője.  
Egyszerre **pontosan egy** értéket tartalmaz a megadott típusok közül.

#### Konstruálás

```cpp
Sum<int, float, String> s = 42;
Sum<int, float, String> s = String("hello");
```

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `holds<T>()` | `bool` | Igaz, ha az aktuális érték `T` típusú |
| `get<T>()` | `T` | Visszaadja `T` típusként, vagy **pánik** |
| `match(fn...)` | — | Minden típushoz egy-egy lambda, a megfelelő fut |
| `index()` | `usize` | Az aktuális típus sorszáma |

---

### Tuple

```cpp
Tuple<Type...>
```

A C++ `std::tuple` megfelelője.  
**Egyszerre az összes** megadott típust tartalmazza.

#### Konstruálás

```cpp
Tuple<int, float, String> t = { 1, 3.14f, "hello" };
```

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `get<N>()` | `TypeN` | Az N-edik elem visszaadása |
| `get<T>()` | `T` | Típus szerint visszaadás (egyedi típus esetén) |
| `size()` | `usize` | Elemek száma |

---

### Vec

```cpp
Vec<N, Type>
```

Fix `N` méretű, matematikai műveletekkel rendelkező vektor.  
SIMD műveletek automatikusan.

#### Konstruálás

```cpp
Vec<3, f32> v = { 1.0f, 2.0f, 3.0f };
```

#### Műveletek

| Művelet | Leírás |
|---|---|
| `+`, `-`, `*`, `/` | Elemenként |
| `dot(other)` | Skaláris szorzat |
| `cross(other)` | Vektoriális szorzat (Vec<3>) |
| `length()` | Hossz |
| `normalize()` | Normalizálás |
| `lerp(other, t)` | Lineáris interpoláció |

---

### Array

```cpp
Array<N, Type>
```

Fix `N` méretű lista, lista-operációkkal (nincs matematika).  
Stack-en allokált.

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `size()` | `usize` | Elemek száma |
| `get(index)` | `Option<Type>` | Biztonságos indexelés |
| `get_unchecked(index)` | `Type&` | Nem ellenőrzött indexelés |
| `iter()` | iterátor | Chainelhető iterátor |
| `contains(value)` | `bool` | Tartalmazza-e az értéket |
| `fill(value)` | `void` | Minden elem beállítása |

---

### Seq

```cpp
Seq<Type, N>   // fix N méretű, stack-en, allokátor nélkül
Seq<Type>      // dinamikus méretű, opcionális allokátorral
```

A BSTD általános célú szekvenciája (lista).

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `size()` | `usize` | Aktuális elemszám |
| `capacity()` | `usize` | Lefoglalt hely (dinamikus) |
| `is_empty()` | `bool` | Üres-e |
| `push_back(value)` | `void` | Hozzáadás a végéhez |
| `pop_back()` | `Option<Type>` | Utolsó elem kivétele |
| `insert(index, value)` | `void` | Beszúrás adott pozícióra |
| `remove(index)` | `Option<Type>` | Eltávolítás adott pozícióról |
| `get(index)` | `Option<Type>` | Biztonságos indexelés |
| `get_unchecked(index)` | `Type&` | Nem ellenőrzött indexelés |
| `clear()` | `void` | Minden elem törlése |
| `iter()` | iterátor | Chainelhető iterátor |
| `contains(value)` | `bool` | Tartalmazza-e az értéket |
| `find(value)` | `Option<usize>` | Első előfordulás indexe |
| `sort()` | `void` | Helyben rendezés |
| `sort_by(cmp_fn)` | `void` | Rendezés komparátorral |

---

### Mat

```cpp
Mat<Rows, Cols, Type>
```

`Rows × Cols` méretű mátrix matematikai műveletekkel.  
SIMD műveletek automatikusan.

#### Konstruálás

```cpp
Mat<4, 4, f32> m = Mat<4, 4, f32>::identity();
```

#### Műveletek

| Művelet | Leírás |
|---|---|
| `+`, `-` | Elemenként |
| `*` | Mátrixszorzás |
| `transpose()` | Transzponálás |
| `inverse()` | `Result<Mat, Error>` — invertálás |
| `determinant()` | Determináns |
| `identity()` | Egységmátrix (statikus) |

---

### Map / OrderedMap

```cpp
Map<Key, Value>          // rendezetlen flat map, opcionális allokátorral
OrderedMap<Key, Value>   // rendezett flat map, opcionális allokátorral
```

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `insert(key, value)` | `void` | Elem hozzáadása |
| `remove(key)` | `Option<Value>` | Elem eltávolítása |
| `get(key)` | `Option<Value>` | Elem lekérése |
| `contains_key(key)` | `bool` | Kulcs megléte |
| `size()` | `usize` | Elemszám |
| `is_empty()` | `bool` | Üres-e |
| `clear()` | `void` | Törlés |
| `iter()` | `Pair<Key, Value>` iterátor | Bejárás |
| `keys()` | iterátor | Csak kulcsok |
| `values()` | iterátor | Csak értékek |

---

### Set / OrderedSet

```cpp
Set<Type>          // rendezetlen set, opcionális allokátorral
OrderedSet<Type>   // rendezett set, opcionális allokátorral
```

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `insert(value)` | `bool` | Hozzáadás (igaz, ha új elem) |
| `remove(value)` | `bool` | Eltávolítás (igaz, ha megvolt) |
| `contains(value)` | `bool` | Tartalmazza-e |
| `size()` | `usize` | Elemszám |
| `is_empty()` | `bool` | Üres-e |
| `union_with(other)` | `Set<Type>` | Unió |
| `intersection_with(other)` | `Set<Type>` | Metszet |
| `difference_with(other)` | `Set<Type>` | Különbség |
| `iter()` | iterátor | Bejárás |

---

### Pair

```cpp
Pair<Key, Value>
```

Két érték párja.

#### Tagok és metódusok

```cpp
pair.first   // Key
pair.second  // Value

Pair<String, int>::make("alma", 3)
```

---

### Complex

```cpp
Complex<Type>
```

Komplex szám, ahol `Type` bármilyen `Math::is_integral<Type>` típus lehet.

#### Konstruálás

```cpp
Complex<f64> c = { 3.0, 4.0 };  // 3 + 4i
```

#### Műveletek

| Művelet | Leírás |
|---|---|
| `+`, `-`, `*`, `/` | Komplex aritmetika |
| `magnitude()` | Abszolút érték (modulus) |
| `conjugate()` | Konjugált |
| `argument()` | Szög (radiánban) |
| `from_polar(r, theta)` | Polár alakból (statikus) |

---

### String / StringView

```cpp
String<Encoding>      // alapból utf8, SSO + opcionális allokátor
StringView<Encoding>  // nem módosítható, nem owning nézet
```

Az `Encoding` lehet: `bstd::str::utf8`, `bstd::str::utf16`, `bstd::str::ascii`, `bstd::str::unicode`, `bstd::str::nullterminated`.  
A `String` típusok képesek castolni egymás között.

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `size()` | `usize` | Byte hossz |
| `char_count()` | `usize` | Karakterek száma (encoding-aware) |
| `is_empty()` | `bool` | Üres-e |
| `as_view()` | `StringView<E>` | Nézet visszaadása |
| `contains(substr)` | `bool` | Tartalmaz-e részstringet |
| `starts_with(prefix)` | `bool` | Előtaggal kezdődik-e |
| `ends_with(suffix)` | `bool` | Utótaggal végződik-e |
| `find(substr)` | `Option<usize>` | Első előfordulás byte-indexe |
| `slice(start, end)` | `StringView<E>` | Részlet |
| `split(delim)` | `Seq<StringView<E>>` | Szétdarabolás |
| `trim()` | `StringView<E>` | Vezető/záró whitespace levágása |
| `to_lowercase()` | `String<E>` | Kisbetűs másolat |
| `to_uppercase()` | `String<E>` | Nagybetűs másolat |
| `as<OtherEncoding>()` | `String<OtherEncoding>` | Encoding-konverzió |
| `push_str(str)` | `void` | Hozzáfűzés |

---

### BitSet / BitField

```cpp
BitSet<N>   // fix N méretű bitek, matematikai operációkkal
BitField    // dinamikus méretű bitek, opcionális allokátorral
```

#### Metódusok

| Metódus | Visszatérés | Leírás |
|---|---|---|
| `set(index)` | `void` | Bit beállítása 1-re |
| `clear(index)` | `void` | Bit törlése 0-ra |
| `flip(index)` | `void` | Bit megfordítása |
| `get(index)` | `bool` | Bit értéke |
| `count_ones()` | `usize` | Beállított bitek száma |
| `count_zeros()` | `usize` | Törölt bitek száma |
| `all()` | `bool` | Minden bit 1-e |
| `any()` | `bool` | Van-e 1-es bit |
| `none()` | `bool` | Nincs 1-es bit |
| `&`, `|`, `^`, `~` | `BitSet<N>` | Bitenkénti műveletek |

---

## Eszközök

---

### Fájlkezelés

```
Path        -> Bejárható fájlrendszer útvonal (mint egy explorer)
PathView    -> Nem módosítható nézet egy Path-ra
File        -> Megnyitott fájl handle; innentől csak File-ként kezelendő
```

A `FileConfig` egy Trait (concept), amely meghatározza hogyan kell egy fájlt kezelni:

```cpp
FileConfig {
    ::open(File) -> Result<Self, Error>
    ::close(File) -> void
    // + extra, típusfüggő műveletek
}
```

#### Megvalósítások

| Típus | Leírás |
|---|---|
| `JSON` | JSON fájl olvasása/írása/szerkesztése |
| `YAML` | YAML fájl olvasása/írása/szerkesztése |
| `RawText` | Sima szöveg fájl |
| `BinaryFile` | Nyers bináris fájl |

#### Példa

```cpp
auto path   = Path::from("config/settings.json");
auto file   = path.open();                          // Result<File, Error>
auto config = JSON::open(file.unwrap());            // Result<JSON, Error>
```

---

### Szálkezelés

```cpp
Thread   // Szál indítása és kezelése
Mutex    // Kölcsönös kizárás
Future   // Aszinkron eredmény
```

---

### Math

A `Math` névtér statikus függvényeket és concepteket tartalmaz.

```cpp
Math::is_integral<T>   // concept: egészszerű típus-e
Math::sqrt(x)
Math::pow(base, exp)
Math::abs(x)
Math::min(a, b)
Math::max(a, b)
Math::clamp(val, lo, hi)
Math::floor(x)
Math::ceil(x)
Math::round(x)
Math::sin(x), Math::cos(x), Math::tan(x)
Math::PI, Math::TAU, Math::E
```

---

### Idő

```cpp
Duration   // Időtartam (pl. 500ms, 2s)
Instant    // Időpont (monotonik óra)
```

#### Példa

```cpp
auto start   = Instant::now();
// ... munka ...
auto elapsed = start.elapsed();   // Duration
```

---

### Range és iterátorok

```cpp
Range(begin, end, step = 1, reverse = false)
```

Iterátort ad vissza, amelyen Rust-szerű chainelt műveletek végezhetők.

#### Iterátor műveletek

| Művelet | Leírás |
|---|---|
| `.map(fn)` | Minden elemre alkalmaz egy függvényt |
| `.filter(fn)` | Csak az igazra értékelő elemeket tartja meg |
| `.for_each(fn)` | Minden elemre lefuttat egy függvényt |
| `.fold(init, fn)` | Akkumulál |
| `.reduce(fn)` | Redukál (első elem az initializáló) |
| `.collect<Seq>()` | Összegyűjti `Seq`-be |
| `.enumerate()` | `(index, value)` párokat ad |
| `.zip(other)` | Két iterátort párosít |
| `.take(n)` | Első `n` elem |
| `.skip(n)` | Első `n` elem kihagyása |
| `.flat_map(fn)` | Map + lapítás |
| `.any(fn)` | Igaz, ha bármely elemre igaz |
| `.all(fn)` | Igaz, ha minden elemre igaz |
| `.count()` | Elemek száma |
| `.first()` | `Option<Type>` — első elem |
| `.last()` | `Option<Type>` — utolsó elem |
| `.find(fn)` | `Option<Type>` — első illeszkedő |

#### Példa

```cpp
auto sum = Range(0, 100)
    .filter([](i32 x) { return x % 2 == 0; })
    .map([](i32 x) { return x * x; })
    .fold(0, [](i32 acc, i32 x) { return acc + x; });
```

Minden `bstd::` kollekciónak van `.iter()` metódusa, amely ilyen chainelhető iterátort ad vissza.

---

## Tervezett funkciók

- `Graph<Node, Edge>` — általános gráf
- `Tree<Type>` — általános fa

---

> **Megjegyzések az allokátorokról:**  
> Az opcionális allokátor alapértelmezés szerint a C linkage-ből jön.  
> Ha nincs megadva, az adott platform/rendszer alapértelmezett allokátorát használja.

> **Matematikai műveletek:**  
> Ahol jelölve van, automatikusan SIMD instrukciókra fordít, ha a platform támogatja.

> **Traitek és conceptek:**  
> A `Hashable`, `Default`, `Comparable` és hasonlók mind C++20 conceptként vannak megvalósítva.
