data Persona = Persona {
  nombrePersona :: String,
  suerte :: Int,
  inteligencia :: Int,
  fuerza :: Int
} deriving (Show, Eq)

data Pocion = Pocion {
  nombrePocion :: String,
  ingredientes :: [Ingrediente]
}

type Efecto = Persona -> Persona

data Ingrediente = Ingrediente {
  nombreIngrediente :: String,
  efectos :: [Efecto]
}

nombresDeIngredientesProhibidos = [
 "sangre de unicornio",
 "veneno de basilisco",
 "patas de cabra",
 "efedrina"]

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun _ [ x ] = x
maximoSegun  f ( x : y : xs)
  | f x > f y = maximoSegun f (x:xs)
  | otherwise = maximoSegun f (y:xs)

{-
1_  Dada una persona definir las siguientes funciones para cuantificar sus niveles de suerte, inteligencia y fuerza sin repetir código:
    a.  sumaDeNiveles que suma todos sus niveles.
    b.  diferenciaDeNiveles es la diferencia entre el nivel más alto y más bajo.
    c.  nivelesMayoresA n, que indica la cantidad de niveles de la persona que están por encima del valor dado.
-}

niveles :: Persona -> [Int]
niveles unaPersona = [suerte unaPersona, inteligencia unaPersona, fuerza unaPersona]

maximoNivel :: Persona -> Int
maximoNivel = maximum . niveles

minimoNivel :: Persona -> Int
minimoNivel = minimum . niveles

sumaDeNiveles :: Persona -> Int
sumaDeNiveles = sum . niveles

diferenciaDeNiveles :: Persona -> Int
diferenciaDeNiveles unaPersona = maximoNivel unaPersona - minimoNivel unaPersona

nivelesMayoresA :: Int -> Persona -> Int
nivelesMayoresA unNumero = length . filter ( > unNumero) . niveles

{-
2_  Definir la función efectosDePocion que dada una poción devuelve una lista con los efectos de todos sus ingredientes.
-}

efectosDePocion :: Pocion -> [Efecto]
efectosDePocion = concat . map efectos . ingredientes

{-
3_  Dada una lista de pociones, consultar:

    a.  Los nombres de las pociones hardcore, que son las que tienen al menos 4 efectos.
    b.  La cantidad de pociones prohibidas, que son aquellas que tienen algún ingredien-
te cuyo nombre figura en la lista de ingredientes prohibidos.
    c.  Si son todas dulces, lo cual ocurre cuando todas las pociones de la lista tie-
nen algún ingrediente llamado "azúcar"
-}

nombresDeIngredientes :: Pocion -> [String]
nombresDeIngredientes = map nombreIngrediente . ingredientes

esHardcore  :: Pocion -> Bool
esHardcore = (4<=) . length . efectosDePocion

esProhibida :: Pocion -> Bool
esProhibida = any (\ingrediente -> elem ingrediente nombresDeIngredientesProhibidos) . nombresDeIngredientes

esDulce     :: Pocion -> Bool
esDulce = any (\ingrediente -> ingrediente == "azucar") . nombresDeIngredientes


pocionesHardocre :: [Pocion] -> [String]
pocionesHardocre = map nombrePocion . filter esHardcore

pocionesProhibidas :: [Pocion] -> Int
pocionesProhibidas = length . filter esProhibida

todasSonDulce :: [Pocion] -> Bool
todasSonDulce = all esDulce

{-
4_  Definir la función tomarPocion que recibe una poción y una persona,
y devuelve como quedaría la persona después de tomar la poción. Cuando
una persona toma una poción, se aplican todos los efectos de esta últi-
ma, en orden.
-}

tomarPocion :: Pocion -> Persona -> Persona
tomarPocion unaPocion unaPersona = foldr (\efecto persona -> efecto persona) unaPersona (efectosDePocion unaPocion)

{-
5_  Definir la función esAntidotoDe que recibe dos pociones y una perso-
na, y dice si tomar la segunda poción revierte los cambios que se produ-
cen en la persona al tomar la primera.
-}

esAntidotoDe :: Pocion -> Pocion -> Persona -> Bool
esAntidotoDe pocionDeEfecto antidoto unaPersona = (==unaPersona) . tomarPocion antidoto . tomarPocion pocionDeEfecto $ unaPersona

{-
6_  Definir la función personaMasAfectada que recibe una poción, una fun-
ción cuantificadora (es decir, una función que dada una persona retorna
un número) y una lista de personas, y devuelve a la persona de la lista
que hace máxima el valor del cuantificador. Mostrar un ejemplo de uso uti-
lizando los cuantificadores definidos en el punto 1.
-}

personaMasAfectada :: Pocion -> (Persona -> Int) -> [Persona] -> Persona
personaMasAfectada unaPocion fCuantificadora = maximoSegun fCuantificadora . map (tomarPocion unaPocion)

-- personaMasAfectada (Pocion "Placebo", []) (nivelesMayoresA 3) [(Persona "harry" 1 2 3), (Persona "ron" 3 2 2)]