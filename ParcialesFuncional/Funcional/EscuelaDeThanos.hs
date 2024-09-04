import Text.Show.Functions
import Data.List
--Ej1 :Modelar Personaje, Guantelete y Universo como tipos de dato e implementar el chasquido de un universo.
data Personaje = Personaje{
    edad :: Int,
    energia :: Int,
    habilidades :: [String],
    nombre :: String,
    planetaEnResidencia :: String
} deriving (Show)

data Guantelete = Guantelete{
    material :: String,
    gemas :: [Gema]
} deriving (Show)

type Universo = [Personaje]

spiderman :: Personaje
spiderman = Personaje {
    edad = 25,
    energia = 100,
    habilidades = ["Agilidad", "Sentido arácnido", "Lanzatelarañas", "Combate cuerpo a cuerpo"],
    nombre = "Peter Parker",
    planetaEnResidencia = "Tierra"
}

thor :: Personaje
thor = Personaje {
    edad = 1500,
    energia = 1000,
    habilidades = ["usar Mjolnir", "Fuerza sobrehumana", "Durabilidad asgardiana", "Manipulación de la tormenta"],
    nombre = "Thor Odinson",
    planetaEnResidencia = "Asgard"
}

--                                              Gemas
type Gema = Personaje -> Personaje
laMente :: Int -> Gema
laMente valorADebilitar enemigo = quitarEnergia valorADebilitar enemigo

elEspacio :: String -> Gema
elEspacio tpAPlaneta enemigo = (teletransportar tpAPlaneta).(quitarEnergia 20) $ enemigo

elAlma :: String ->Gema
elAlma habilidadAEliminar delEnemigo = quitarEnergia 10 . quitarHabilidadEspecifica habilidadAEliminar $ delEnemigo

elPoder :: Gema
elPoder enemigo = quitarHabilidad . quitarEnergia (energia enemigo) $ enemigo

elTiempo :: Gema
elTiempo enemigo
    |(18<=).reducirEdad $ enemigo = quitarEnergia 50 . flip rejuvenecer enemigo . reducirEdad $ enemigo
    |otherwise = rejuvenecer 18 . quitarEnergia 50 $ enemigo

laGemaLoca :: Gema -> Gema
laGemaLoca otraGema enemigo = otraGema.otraGema $ enemigo

--                                              Poderes
quitarEnergia :: Int -> Gema
quitarEnergia energiaADebilitar enemigo = enemigo {energia = (energia enemigo) - energiaADebilitar}

teletransportar :: String -> Gema
teletransportar planeta enemigo = enemigo{planetaEnResidencia = planeta}

quitarHabilidadEspecifica :: String -> Gema
quitarHabilidadEspecifica unaHabilidad enemigo = enemigo{habilidades = filter (/= unaHabilidad) (habilidades enemigo) }

quitarHabilidad :: Gema
quitarHabilidad enemigo
    |(2>=).length.habilidades $ enemigo = enemigo {habilidades = []}
    |otherwise = enemigo

reducirEdad :: Personaje -> Int
reducirEdad enemigo = div (edad enemigo) 2

rejuvenecer :: Int -> Gema
rejuvenecer nuevaEdad enemigo = enemigo{edad = nuevaEdad}

--                                              Guantelete
cantidadAEliminar :: Universo -> Int
cantidadAEliminar laPoblacion = (flip div 2.length) $ laPoblacion

eliminarLaMitad :: Universo -> Universo
eliminarLaMitad elUniverso = take (cantidadAEliminar elUniverso) elUniverso

matarALaMitadDeLaPoblacion :: Universo -> Universo
matarALaMitadDeLaPoblacion universoAfectado = eliminarLaMitad universoAfectado

chasquearUniverso :: Guantelete -> Universo -> Universo
chasquearUniverso elGuante algunUniverso
    | ((6==).length.gemas) elGuante && "Uro" == material elGuante = matarALaMitadDeLaPoblacion algunUniverso
    | otherwise = algunUniverso

{-El 2
Resolver utilizando únicamente orden superior.
Saber si un universo es apto para péndex, que ocurre si alguno de los personajes que lo integran tienen menos de 45 años.
Saber la energía total de un universo que es la sumatoria de todas las energías de sus integrantes que tienen más de una habilidad.
-}

hayPendex :: [Int] -> Bool
hayPendex listaDeEdades = any (45>=) listaDeEdades

obtenerEdades :: Universo -> [Int]
obtenerEdades unUniverso = map edad unUniverso

aptoParaPendex :: Universo -> Bool
aptoParaPendex unUniverso = hayPendex.obtenerEdades $ unUniverso

obtenerEnergiaDe :: Universo -> [Int]
obtenerEnergiaDe elUniverso = map energia elUniverso

energiaTotal :: Universo -> Int
energiaTotal unUniverso = sum.obtenerEnergiaDe $ unUniverso

{-
Ej 4
Dar un ejemplo de un guantelete de goma con las gemas tiempo, alma que quita la habilidad de "usar Mjolnir" y
la gema loca que manipula el poder del alma tratando de eliminar la "programación en Haskell".
-}
guanteleteDeGoma :: Guantelete
guanteleteDeGoma = Guantelete{
    material = "Goma",
    gemas = [elTiempo, elAlma "usar Mjolnir", laGemaLoca (elAlma "programación en Haskell") ]
}

{-
Ej 5:  No se puede utilizar recursividad. Generar la función utilizar  que dado una lista de gemas y
un enemigo ejecuta el poder de cada una de las gemas que lo componen contra el personaje dado.
Indicar cómo se produce el "efecto de lado" sobre la víctima.
-}

utilizar :: [Gema] -> Gema
utilizar gemasAAplicar victima = foldl (flip ($)) victima gemasAAplicar 

{-
 Ej 6: Resolver utilizando recursividad. Definir la función gemaMasPoderosa que dado un guantelete y
 una persona obtiene la gema del infinito que produce la pérdida más grande de energía sobre la víctima. 
-}

torturar :: Guantelete -> Personaje -> Gema
torturar elGuante victima = gemaMasPoderosa victima $ gemas elGuante

gemaMasPoderosa :: Personaje -> [Gema] -> Gema
gemaMasPoderosa _ [x] = x
gemaMasPoderosa torturado (x:y:xs)
    | (energia.x) torturado < (energia.y) torturado = gemaMasPoderosa torturado (y:xs)
    |otherwise = gemaMasPoderosa torturado (x:xs)



