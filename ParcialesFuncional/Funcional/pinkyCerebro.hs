{-
1. Modelar a los animales: escribir un sinónimo de tipo y definir algunos ejemplos de animales como constantes.
De un animal se sabe su coeficiente intelectual (un número), su especie (un string) y sus capacidades (strings). 
-}
import Control.Monad (replicateM)

data Animal = Animal{
    ci :: Float,
    especie :: String,
    capacidades :: [String]
} deriving (Show, Eq)

{-
2. Transformar a un animal de laboratorio:
    inteligenciaSuperior: Incrementa en n unidades su coeficiente intelectual
    pinkificar: quitarle todas las habilidades que tenía
    superpoderes:  le da habilidades nuevas	
        En caso de ser un elefante: le da la habilidad "no tenerle miedo a los ratones"
        En caso de ser un ratón con coeficiente intelectual mayor a 100: le agrega la habilidad de "hablar". 
        Si no, lo deja como está. 
-}

type TransformarAnimal = Animal -> Animal

inteligenciaSuperior :: Float -> TransformarAnimal
inteligenciaSuperior valor unAnimal = unAnimal{ci = valor + (ci unAnimal)}

pinkificar :: TransformarAnimal
pinkificar unAnimal = unAnimal{capacidades = [] }

superpoderes :: TransformarAnimal
superpoderes unAnimal
    | esEspecie "elefante" unAnimal = agregarHabilidad "no tenerle miedo a los ratones" unAnimal
    | esEspecie "raton" unAnimal && ciMayorA 100 unAnimal = agregarHabilidad "hablar" unAnimal
    | otherwise = unAnimal

agregarHabilidad :: String -> TransformarAnimal
agregarHabilidad habilidad unAnimal = unAnimal {capacidades = habilidad : capacidades unAnimal}

esEspecie :: String -> Animal -> Bool
esEspecie especieAVerificar unAnimal = especieAVerificar == especie unAnimal

ciMayorA :: Float -> Animal -> Bool
ciMayorA ciAVerificar unAnimal = ciAVerificar < (ci unAnimal)

tieneHabilidad :: String -> Animal -> Bool
tieneHabilidad habilidadAVerificar unAnimal = any (habilidadAVerificar ==) (capacidades unAnimal) 

{-
3. Los científicos muchas veces desean saber si un animal cumple ciertas propiedades, porque luego las usan como criterio
de éxito de una transformación. Desarrollar los siguientes criterios:
antropomórfico: si tiene la habilidad de hablar y su coeficiente es mayor a 60.
noTanCuerdo: si tiene más de dos habilidades de hacer sonidos pinkiescos. Hacer una  función pinkiesco, que significa que
la habilidad empieza con "hacer", y luego va seguido de una palabra "pinkiesca", es decir, con 4 letras o menos y al menos una vocal.
-}

type Criterio = Animal -> Bool

antropomorfico :: Criterio
antropomorfico unAnimal = ciMayorA 60 unAnimal && tieneHabilidad "hablar" unAnimal

pinkiesco :: String -> Bool
pinkiesco habilidad = "hacer " == take 6 habilidad && length habilidad == 10

noTanCuerdo :: Criterio
noTanCuerdo unAnimal = (2<).length.filter pinkiesco $ (capacidades unAnimal)

{-
4. Los científicos construyen experimentos: un experimento se compone de un conjunto de transformaciones sobre un animal, y un criterio de éxito. Se pide:
Modelar a los experimentos: dar un sinónimo de tipo.
Desarollar experimentoExitoso: Dado un experimento y un animal, indica si al aplicar sucesivamente todas las transformaciones se cumple el criterio de éxito. 
Dar un ejemplo de consulta para representar la siguiente situación:
-}

data Experimento = Experimento{
    transformaciones :: [TransformarAnimal],
    criterioExito :: Criterio
}

experimentoExitoso :: Experimento -> Animal -> Bool
experimentoExitoso algunExperimento unAnimal = (criterioExito algunExperimento) (aplicarTransformaciones (transformaciones algunExperimento) unAnimal)

aplicarTransformaciones :: [TransformarAnimal] -> TransformarAnimal
aplicarTransformaciones transformacionesDelExperimento unAnimal = foldr ($) unAnimal transformacionesDelExperimento

{-
5. Periódicamente, ACME pide informes sobre los experimentos realizados.
Desarrollar los siguientes reportes, que a partir de una lista de animales,
una lista de capacidades y un experimento (o una serie de transformaciones)
permitan obtener:
a.  Una lista con los coeficientes intelectuales de los animales que entre sus
capacidades, luego de efectuar el experimento, tengan alguna de las capacidades dadas.
b.  Una lista con las especie de los animales que, luego de efectuar el experimento,
tengan entre sus capacidades todas las capacidades dadas.
c.  Una lista con la cantidad de capacidades de todos los animales que, luego de
efectuar el experimento, no tengan ninguna de las capacidades dadas.
-}

reporteA :: [Animal] -> [String] -> [TransformarAnimal] -> [Float]
reporteA animales habilidades transformaciones = map ci . transformarYFiltrarAnimales habilidades transformaciones $ animales

reporteB :: [Animal] -> [String] -> [TransformarAnimal] -> [String]
reporteB animales habilidades transformaciones = map especie . transformarYFiltrarAnimales habilidades transformaciones $ animales

reporteC :: [Animal] -> [String] -> [TransformarAnimal] -> [Int]
reporteC animales habilidades transformaciones = map (length . capacidades) . filter (not.tienenLasHabilidades habilidades ) . aplicarTranssAAnimales transformaciones $ animales

aplicarTranssAAnimales :: [TransformarAnimal] -> [Animal] -> [Animal]
aplicarTranssAAnimales transformaciones animales = map (aplicarTransformaciones transformaciones) animales

tienenLasHabilidades :: [String] -> Animal -> Bool
tienenLasHabilidades habilidades unAnimal = any (flip elem habilidades) (capacidades unAnimal)

transformarYFiltrarAnimales :: [String] -> [TransformarAnimal] -> [Animal] -> [Animal]
transformarYFiltrarAnimales habilidades transformaciones animales = filtrarPorHabilidades habilidades . aplicarTranssAAnimales transformaciones $ animales

filtrarPorHabilidades :: [String] -> [Animal] -> [Animal]
filtrarPorHabilidades habilidades listaAnimales = filter (tienenLasHabilidades habilidades) listaAnimales

pinky :: Animal
pinky = Animal{
    ci = 2000,
    especie = "raton",
    capacidades = ["hacer asdf", "hacer usdf", "hacer esdf", "hablar"] ++ repeat "respirar"
}

