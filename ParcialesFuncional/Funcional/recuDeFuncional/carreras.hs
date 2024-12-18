data Auto = Auto{
    color     :: String,
    velocidad :: Int,
    distancia :: Int
}deriving(Show, Eq)

type Carrera = [Auto]

--Punto 1
sonDistintos :: Auto -> Auto -> Bool
sonDistintos unAuto otroAuto = color unAuto /= color otroAuto

distanciaEntreDosVehiculos :: Auto -> Auto -> Int
distanciaEntreDosVehiculos unAuto otroAuto = abs(distancia unAuto - distancia otroAuto)

leGanaA :: Auto -> Auto -> Bool
leGanaA unAuto otroAuto = not(estaCerca unAuto otroAuto) && (distancia unAuto > distancia otroAuto)

estaCerca :: Auto -> Auto -> Bool
estaCerca unAuto otroAuto = (sonDistintos unAuto otroAuto &&) . (10 > ) . distanciaEntreDosVehiculos unAuto $ otroAuto

vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo unAuto unaCarrera = all (\otroAuto -> leGanaA unAuto otroAuto) . filter (/= unAuto) $ unaCarrera

puesto :: Auto -> Carrera -> Int
puesto unAuto unaCarrera = (1+) . length . filter (flip leGanaA unAuto) $ unaCarrera

-- Punto 2

correr :: Int -> Auto -> Auto
correr tiempo unAuto = unAuto{distancia = tiempo * velocidad unAuto + distancia unAuto}

type ModificadorDeVelocidad = Int -> Int
alterarVelocidad :: ModificadorDeVelocidad -> Auto -> Auto
alterarVelocidad modificador auto = auto { velocidad = (modificador . velocidad) auto}

bajarLaVelocidad :: Int -> Auto -> Auto
bajarLaVelocidad cantidad = alterarVelocidad (max 0 . flip (-) cantidad)

--Punto 3
type PowerUp = Auto -> Carrera -> Carrera
afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

terremoto :: PowerUp
terremoto unAuto = afectarALosQueCumplen (estaCerca unAuto) (bajarLaVelocidad 50)

miguelitos :: Int -> PowerUp
miguelitos quitarVelocidad unAuto = afectarALosQueCumplen (leGanaA unAuto) (bajarLaVelocidad quitarVelocidad)

jetPack :: Int -> PowerUp
jetPack tiempo unAuto = afectarALosQueCumplen (== unAuto) (alterarVelocidad (\_ -> velocidad unAuto) . correr tiempo . alterarVelocidad (2*))

--Punto 4
type Evento = Carrera -> Carrera
type Puesto = (Int, String)

simularCarrera :: Carrera -> [Evento] -> [Puesto]
simularCarrera unaCarrera = puestosYcolores . foldr ($) unaCarrera

puestosYcolores :: Carrera -> [Puesto]
puestosYcolores unaCarrera = map (\unAuto -> (puesto unAuto unaCarrera, color unAuto)) unaCarrera

correnTodos :: Int -> Carrera -> Carrera
correnTodos unTiempo unaCarrera = map (correr unTiempo) unaCarrera
{-
usaPowerUp
Se utiliza where y find, siendo estas funciones que no se vieron en la cursada

usaPowerUp :: PowerUp -> Color -> Evento
usaPowerUp powerUp colorBuscado carrera =
    powerUp autoQueGatillaElPoder carrera
    where autoQueGatillaElPoder = find ((== colorBuscado).color) carrera

find :: (c -> Bool) -> [c] -> c
find cond = head . filter cond

ejemploDeUsoSimularCarrera =
    simularCarrera autosDeEjemplo [
        correnTodos 30,
        usaPowerUp (jetPack 3) "azul",
        usaPowerUp terremoto "blanco",
        correnTodos 40,
        usaPowerUp (miguelitos 20) "blanco",
        usaPowerUp (jetPack 6) "negro",
        correnTodos 10
    ]
-}

