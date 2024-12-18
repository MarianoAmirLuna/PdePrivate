data Personaje = Personaje{
    nombre      :: String,
    edad        :: Int,
    planeta     :: String,
    energia     :: Int,
    habilidades :: [String]
}deriving (Show, Eq)

data Guantelete = Guantelete{
    material :: String,
    gemas    :: [Gema]
}

type Gema    = Personaje -> Personaje
type Universo = [Personaje]

puedeChasquear :: Guantelete -> Bool
puedeChasquear guantelete = tieneMaterial "uru" guantelete && tieneTodasLasGemas guantelete

tieneMaterial :: String -> Guantelete -> Bool
tieneMaterial unMaterial = (== unMaterial) . material

tieneTodasLasGemas :: Guantelete -> Bool
tieneTodasLasGemas = (==6) . length . gemas

chasquearUniverso :: Guantelete -> Universo -> Universo
chasquearUniverso unGuantelete unUniverso
    | puedeChasquear unGuantelete = flip take unUniverso . flip div 2 . length $ unUniverso
    | otherwise = unUniverso

--Punto 2
aptoParaPendex :: Universo -> Bool
aptoParaPendex = any ((< 45) . edad)

totalEnergia :: Universo -> Int
totalEnergia = sum . map energia . filter ((>1) . length . habilidades)

--Punto 3
--AFECTAR PERSONAJES --
modificarEdad :: Int -> Personaje -> Personaje
modificarEdad unValor unPersonaje = unPersonaje{edad = unValor}

cambiarPlaneta :: String -> Personaje -> Personaje
cambiarPlaneta unPlaneta unPersonaje = unPersonaje{planeta = unPlaneta}

quitarEnergia :: Int -> Personaje -> Personaje
quitarEnergia unValor unPersonaje = unPersonaje{energia = energia unPersonaje - unValor}

quitarHabilidades :: Int -> Personaje -> Personaje
quitarHabilidades unaCantidad unPersonaje = unPersonaje{habilidades = drop unaCantidad (habilidades unPersonaje)}

quitarCiertaHabilidad :: String -> Personaje -> Personaje
quitarCiertaHabilidad unaHabilidad unPersonaje = unPersonaje{habilidades = filter (/= unaHabilidad) (habilidades unPersonaje)}

todasLasHabilidades :: Personaje -> Int
todasLasHabilidades = length . habilidades

mitadDeEdad :: Personaje -> Int
mitadDeEdad = flip div 2 . edad

-- GEMAS --
mente :: Int -> Gema
mente unValor = quitarEnergia unValor

alma :: String -> Gema
alma unaHabilidad unPersonaje
    | elem unaHabilidad (habilidades unPersonaje) = quitarEnergia 10 . quitarCiertaHabilidad unaHabilidad $ unPersonaje
    | otherwise                                   = quitarEnergia 10 unPersonaje

espacio :: String -> Gema
espacio unPlaneta = quitarEnergia 20 . cambiarPlaneta unPlaneta

poder :: Gema
poder unPersonaje
    | 2 >= todasLasHabilidades unPersonaje = quitarEnergia (energia unPersonaje) . quitarHabilidades (todasLasHabilidades unPersonaje) $ unPersonaje
    | otherwise                            = quitarEnergia (energia unPersonaje) unPersonaje

tiempo :: Gema
tiempo unPersonaje
    | ((<=18) . mitadDeEdad) unPersonaje = modificarEdad (mitadDeEdad unPersonaje) unPersonaje
    | otherwise                          = flip modificarEdad unPersonaje . abs . (18-) . edad $ unPersonaje

loca :: Gema -> Gema
loca unaGema = unaGema . unaGema

--Punto 4
--guanteleteDeGoma = tiempo . alma "usar Mjolnir" . loca (alma "programación en Haskell")

--Punto 5
utilizar :: [Gema] -> Personaje -> Personaje
utilizar unasGemas unEnemigo = foldl (\enemigo gema-> gema enemigo) unEnemigo unasGemas
--utilizar unasGemas unEnemigo = foldr ($) unEnemigo unasGemas

--Punto 6
gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa unGuantelete unPersonaje = mayorPerdidaDeEnergia unPersonaje $ gemas unGuantelete

mayorPerdidaDeEnergia :: Personaje -> [Gema] -> Gema
mayorPerdidaDeEnergia _ [unaGema] = unaGema
mayorPerdidaDeEnergia unPersonaje (x:y:xs)
    | energia (x unPersonaje) < energia (y unPersonaje) = mayorPerdidaDeEnergia unPersonaje (x:xs)
    | otherwise                                         = mayorPerdidaDeEnergia unPersonaje (y:xs)