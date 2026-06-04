# BSTD - Better Standard

A saját megoldásom a 40 éves c++ STL-re, és magára a nyelvre.
Mely: modernebb, gyorsabb, egyszerűbb, olvashatóbb -> használhatóbb.

## Konvenciók 

- **Xmake** build rendszer
- C++20 **Modulokat** használunk (.cpp és .cppm)
- **Nincs STD**, Nincsenek exception-ök
- Gitet használunk
- Függvények igével kezdődnek, snake_case és nevük **inkább érthető mint rövid**
- Alapból structokat használunk, PascalCase-el
- Teljes template nevek: T -> Type, E -> Error, K = Key, V = Value, stb
- Kód kommentek és dokumentáció **magyarul**, de kód marad angol
- Maga a kód legyen a dokumentáció, egyszerűen változtatható legyen -> összefoglalja detail::-t angolul
- **Matematikai nevek**: Vec -> Seq, Option -> Sum, Variant -> Tuple stb
- **Teszt mindenre**
- modern, gyorsabb, egyszerűbb, olvashatóbb mint a Rust + explicit **HA KELL** mint Zigben
- Minden BSTD kód gyökere a bstd:: namespace

## Feature lista

Nem fogom leírni az egész dolgot, csak hogy hogy akarom használni, 
csak hogy mi legyen az összefoglaló szinten

i8, i16, i32, i64, i128 |
u8, u16, u32, u64, u128 |
f32, f64                | 

´Result<Ok, Error>´ -> Hiba vagy Ok
´Option<Some>´      -> Valami vagy Semmi
´Sum<T..>´          -> T..-ok akármelyik közül 1 db 
´Tuple<T..>´        -> T.. közül mind lehet benne egyszerre
'Vec<N, T>´         -> fix N mennyiségű T érték matematikai műveletekkel
´Array<N, T>´       -> fix N mennyiségű T érték lista operációkkál
´Seq<T, N>´         -> fix N méretű lista (szekvencia) (allokátor nélküli, stacken)
´Seq<T>´            -> dinamikus méretű lista T elemekkel, opcionális allokátorral
´Mat<R, C, T>´      -> R(ow) X C(olumn) méretű mátrix matematikai műveletekkel
´Map<K, V>´         -> Egy unordered flat map, opcionális allokátorral
´OrderedMap<K, V>´  -> Egy ordered flat map, opcionális allokátorral
´Set<T>´            -> set, opcionális allokátor
´OrderedSet<T>´     -> ordered set, opcionális allokátor
´Pair<K, V>´        -> két érték párja
´Complex<T>´        -> Komplex szám, ahol T = akármilyen Math::is_integral<T>
´String<Encoding>´  | ahol az Encoding alapból utf8. Ezek képesek castolni egymás között. *1
´StringView<E>´     | Encoding lehet utf8, utf16, ascii, unicode, nullterminated (bstd::str::utf8 - tag)
´BitSet<N>´         -> Fix méretű bitek, matematikai operációkkal
´BitField´          -> Dinamikus méretű bitek, opcionális allokátorral

Később:
Graph, Tree

*1 van SSO de opcionális allokátorral

(opcionális allokátor különben default C linkage ből)
(matematikai műveletek = SIMD és ilyenek automatikusan)

"eszközök": (ha az előző az adatstruktúrák, ezek az algoritmusok)

**File dolgok**
Path                -> Egy pathon tudsz böngészni mint egy file explorerben majd File 
PathView
File                -> Megnyit egy File-t, innentől csak File lehet
FileConfig (Trait)  -> ...::open(File) ...::close(File) + extra műveletek (pld JSON, YAML) | szerkeszt egy filet
JSON                -> FileConfig implementáció
YAML                -> FileConfig implementáció 
RawText             -> FileConfig implementáció
BinaryFile          -> FileConfig implementáció

Thread
Mutex
Future

Math

Duration
Instant

Range               -> iterátort ad vissza műveletekhez. Range(begin, end, step = 1, reverse = false)

(vannak ilyen menő iterátorok, .iter() chaining mint Rustban)
(Hashable és hasonlók mind Trait-ek, amik conceptek)

> Eszköz, általában mint egy kollekció de több statikus függvénnyel, lásd ezeket:

´Path´ 

### Result

´Result<Ok, Error>´
Tárol vagy egy Type-ot, vagy egy Error-t

- is_ok() bool -> Igaz ha ok, hamis ha hiba
- is_error() bool -> Igaz ha hiba, hamis ha ok
- unwrap() Ok -> visszaadja az ok értéket, vagy pánik
Error az egy concept legyen aminek kötelező valami olyat visszaadnia ami tud adni egy stringet mint hiba
- unwrap_or(Ok value) Ok -> Ha ok visszaadja, különben value-t adja vissza
- tranform(Fn func) void -> Ha ok alkalmazza func-ot
- transform_error(Fn func) void -> ha error alkalmazza func-ot
- and_then(Fn func) void -> ha ok, futtassa azt, chainelés
- match(Fn ok_fn, Fn err_fn) -> ha ok ok_fn-t futassa, különben err-fn-t
- unwrap_or_default() Ok -> visszaadja a default értékét Ok-nak, ha nem felel meg a Default conceptnek akkor compile hiba
- ok() Option<Ok> -> Cast Option-re Ok-al
- error() Option<Error> -> Cast Option-re Error-al
- Result<T, T>::Ok/Error -> A típusa Oknak és Error-nak, lehet használ konstruktorként:
´auto res = Result<int, String>::Error("hiba");´
´return Reslt<int, String>::Error("hiba");´
