import Data.Char (toUpper)
import Data.Char (isUpper)

data Barbaro = Barbaro {
    nombre :: String,
    fuerza :: Int,
    habilidades :: [String],
    objetos :: [Objeto]
}

type Objeto = Barbaro -> Barbaro
type ModificarBarbaro = Objeto



modificarNombre :: String -> ModificarBarbaro
modificarNombre nuevoNombre unBarbaro = unBarbaro{nombre = nuevoNombre}

modificarFuerza :: (Int -> Int) -> ModificarBarbaro
modificarFuerza funcion unBarbaro = unBarbaro{fuerza = funcion (fuerza unBarbaro)}

agregarFuerza :: Int -> ModificarBarbaro
agregarFuerza valor unBarbaro = modificarFuerza (+valor) unBarbaro

reemplazarFuerza :: Int ->ModificarBarbaro
reemplazarFuerza valor unBarbaro = unBarbaro{fuerza = valor}

modificarHabilidad :: ([String] -> [String]) -> ModificarBarbaro
modificarHabilidad funcion unBarbaro = unBarbaro{habilidades= funcion (habilidades unBarbaro)}

añadirHabilidad :: String -> ModificarBarbaro
añadirHabilidad habilidad unBarbaro = unBarbaro{habilidades = habilidad : (habilidades unBarbaro) }

reemplazarHabilidad :: [String] -> ModificarBarbaro
reemplazarHabilidad nuevaHabilidad unBarbaro = unBarbaro{habilidades = nuevaHabilidad }

añadirObjetos :: Objeto -> ModificarBarbaro
añadirObjetos nuevoObjeto unBarbaro = unBarbaro{objetos = nuevoObjeto : (objetos unBarbaro)}

reemplazarObjetos :: [Objeto] -> ModificarBarbaro
reemplazarObjetos objetosFuturos unBarbaro = unBarbaro{objetos = objetosFuturos}

-- ==================================================================================================
espadas :: Int -> Objeto
espadas pesoDeLaEspada unBarbaro = agregarFuerza (pesoDeLaEspada*2) unBarbaro

amuletosMisticos :: String -> Objeto
amuletosMisticos habilidad unBarbaro = añadirHabilidad habilidad unBarbaro

varitasDefectuosas :: Objeto
varitasDefectuosas unBarbaro = añadirHabilidad "Hacer magia" . reemplazarObjetos [] $ unBarbaro 

ardilla :: Objeto
ardilla unBarbaro = unBarbaro

cuerda :: Objeto -> Objeto -> Objeto
cuerda objeto1 objeto2 unBarbaro = objeto1.objeto2 $ unBarbaro

--2
{-
convertirAMayusculas :: String -> String
convertirAMayusculas = map toUpper

convertirHabilidadesEnSuper :: [String] -> [String]
convertirHabilidadesEnSuper habilidades = map convertirAMayusculas habilidades

megafono :: Objeto
megafono unBarbaro = modificarHabilidad (concat.convertirHabilidadesEnSuper) unBarbaro
-}

-- 3 
type Evento = [Barbaro] -> [Barbaro]
type Condicion = Barbaro -> Bool

sobrevivirAlEvento :: Condicion -> Evento
sobrevivirAlEvento condicion unosBarbaro = filter condicion unosBarbaro

condicionInvDuendes :: Condicion
condicionInvDuendes unBarbaro = elem "Escribir Poesia Atroz" (habilidades unBarbaro)

invasionDeSuciosDuende :: Evento
invasionDeSuciosDuende unosBarbaro = sobrevivirAlEvento condicionInvDuendes unosBarbaro

condicionCremalleraDelTiempo :: Condicion
condicionCremalleraDelTiempo unBarbaro = (nombre unBarbaro) == "Faffe" || (nombre unBarbaro) == "Astro"

cremalleraDelTiempo :: Evento
cremalleraDelTiempo unosBarbaros = sobrevivirAlEvento condicionCremalleraDelTiempo unosBarbaros

saqueo :: Condicion
saqueo unBarbaro = elem "Robar" (habilidades unBarbaro) && 80 < (fuerza unBarbaro)

gritoDeGuerra :: Barbaro -> Int
gritoDeGuerra unBarbaro = length.concat.habilidades $ unBarbaro

gritoGuerrero :: Condicion
gritoGuerrero unBarbaro = (gritoDeGuerra unBarbaro ==).(4*).length.objetos $ unBarbaro

caligrafia :: Condicion
caligrafia unBarbaro = (all habilidadMayorA3Vocales.habilidades) unBarbaro && (all primeraLetraMayuscula.habilidades) unBarbaro

obtenerStringsDeVocales :: String -> String
obtenerStringsDeVocales habilidad = filter esVocal habilidad

esVocal :: Char -> Bool
esVocal c = c `elem` "aeiouAEIOU"

primeraLetraMayuscula :: [Char] -> Bool
primeraLetraMayuscula (x:xs) = isUpper x

habilidadMayorA3Vocales :: String -> Bool
habilidadMayorA3Vocales habilidad =  (3==).length . obtenerStringsDeVocales $ habilidad

condicionRitualesFechorias :: Condicion
condicionRitualesFechorias unBarbaro = caligrafia unBarbaro || gritoGuerrero unBarbaro || saqueo unBarbaro

ritualesFechorias ::Evento
ritualesFechorias unosBarbaros = filter condicionRitualesFechorias unosBarbaros

type Aventura = [Evento]

--Muchos Barbaros muchos eventos
{-
sobreviveAVariosEventos :: Aventura -> Barbaro -> Bool
sobreviveAVariosEventos unosEventos unBarbaro = all ($ unBarbaro) unosEventos

sobrevientesAVariosEventos :: Aventura -> [Barbaro] -> [Barbaro]
sobrevientesAVariosEventos unosEventos unosBarbaros = filter (sobreviveAVariosEventos unosEventos) unosBarbaros
-}

-- #############
-- ##### 4 #####
-- #############
--Se puede con foldl1??

eliminarElementosRepetidos :: (Eq a) => [a] -> [a]
eliminarElementosRepetidos [x] = [x]
eliminarElementosRepetidos (x:y:xs)
    | any (== x) (y:xs) = eliminarElementosRepetidos (y:xs)
    | otherwise = x : eliminarElementosRepetidos (y:xs)

--eliminarRepetidos :: (Eq a) => [a] -> [a]
--eliminarRepetidos lista = foldl1 estaRepetido lista


--modificarNombre :: String -> ModificarBarbaro
--modificarNombre nuevoNombre unBarbaro = unBarbaro{nombre = nuevoNombre}






