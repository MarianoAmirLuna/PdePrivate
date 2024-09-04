import Text.Show.Functions
import Data.List

data Elemento = UnElemento {
 tipo :: String,
 ataque :: (Personaje-> Personaje),
 defensa :: (Personaje-> Personaje)
} deriving (Show)

data Personaje = UnPersonaje { nombre :: String,
 salud :: Float,
 elementos :: [Elemento],
 anioPresente :: Int 
} deriving (Show)

{-
1_ Empecemos por algunas transformaciones básicas:
A. mandarAlAnio: lleva al personaje al año indicado.
B. meditar: le agrega la mitad del valor que tiene a la salud del personaje.
C. causarDanio: le baja a un personaje una cantidad de salud dada.
Hay que tener en cuenta al modificar la salud de un personaje que ésta nunca puede quedar menor a 0.
-}

mandarAlAnio :: Int -> Personaje-> Personaje
mandarAlAnio anioAMandar enemigo = enemigo {anioPresente = anioAMandar}

meditar :: Personaje-> Personaje
meditar usuario = reducirVida (mitadDeVidad usuario) usuario

causarDanio :: Float -> Personaje-> Personaje
causarDanio danio enemigo = reducirVida danio enemigo

reducirVida :: Float -> Personaje-> Personaje
reducirVida danio enemigo
    | salud enemigo - danio <= 0 = enemigo 
    | otherwise = enemigo {salud = salud enemigo -danio}

mitadDeVidad :: Personaje -> Float
mitadDeVidad contrincante = salud contrincante / 2

{-
2_  Queremos poder obtener algo de información extra sobre los personajes. Definir las siguientes funciones:
A.  esMalvado, que retorna verdadero si alguno de los elementos que tiene el personaje en cuestión es de tipo "Maldad".

B.  danioQueProduce :: Personaje -> Elemento -> Float, que retorne la diferencia entre la salud inicial del personaje y
la salud del personaje luego de usar el ataque del elemento sobre él.

C.  enemigosMortales que dado un personaje y una lista de enemigos, devuelve la lista de los enemigos que pueden llegar a matarlo con un solo elemento.
Esto sucede si luego de aplicar el efecto de ataque del elemento, el personaje queda con salud igual a 0.
-}

danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce afectado elemento = salud afectado - saludPostAtaque elemento afectado

saludPostAtaque :: Elemento -> Personaje -> Float
saludPostAtaque elemento afectado = salud.ataque elemento $ afectado

esMalvado :: Elemento -> Bool
esMalvado elemento = tipo elemento == "Maldad"

enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales heroe enemigos = filter (esEnemigoMortal heroe) enemigos

esEnemigoMortal :: Personaje -> Personaje -> Bool
esEnemigoMortal unHeroe unEnemigo = (any (tieneAtaqueMortal unHeroe) . elementos) unEnemigo

tieneAtaqueMortal :: Personaje -> Elemento -> Bool
tieneAtaqueMortal personaje elemento = (estaMuerto . ataque elemento) personaje

estaMuerto :: Personaje -> Bool
estaMuerto unPersonaje = (0==).salud $ unPersonaje

{-
3_  Definir los siguientes personajes y elementos:
a_  Definir concentracion de modo que se pueda obtener un elemento cuyo efecto defensivo sea
    aplicar meditar tantas veces como el nivel de concentración indicado y cuyo tipo sea "Magia".
b_  Definir esbirrosMalvados que recibe una cantidad y retorna una lista con esa cantidad de esbirros
    (que son elementos de tipo "Maldad" cuyo efecto ofensivo es causar un punto de daño).
c_  Definir jack de modo que permita obtener un personaje que tiene 300 de salud, que tiene como
    elementos concentración nivel 3 y una katana mágica (de tipo "Magia" cuyo efecto ofensivo es causar
    1000 puntos de daño) y vive en el año 200.
d_  Definir aku :: Int -> Float -> Personaje que recibe el año en el que vive y la cantidad de salud con
    la que debe ser construido. Los elementos que tiene dependerán en parte de dicho año. Los mismos incluyen:
  i.  Concentración nivel 4
 ii. Tantos esbirros malvados como 100 veces el año en el que se encuentra.
iii. Un portal al futuro, de tipo "Magia" cuyo ataque es enviar al personaje al futuro (donde el futuro es 2800
     años después del año indicado para aku), y su defensa genera un nuevo aku para el año futuro correspondiente
     que mantenga la salud que tenga el personaje al usar el portal.
-}