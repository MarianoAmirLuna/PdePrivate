import Text.Show.Functions
import Data.List

data Elemento = UnElemento { tipo :: String,
	ataque :: (Personaje-> Personaje),
	defensa :: (Personaje-> Personaje)
    }

data Personaje = UnPersonaje { nombre :: String,
    salud :: Float,
	elementos :: [Elemento],
    anioPresente :: Int 
    }

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
meditar usuario = reducirVida mitadDeVidad usuario usuario

causarDanio :: Float -> Personaje-> Personaje
causarDanio danio enemigo = reducirVida danio enemigo

reducirVida :: Float -> Personaje-> Personaje
reducirVida danio enemigo
    | salud enemigo - danio <= 0 = enemigo 
    | otherwise = enemigo {salud = salud enemigo -danio}

mitadDeVidad :: Personaje -> Float
mitadDeVidad contrincante = salud contrincante / 2