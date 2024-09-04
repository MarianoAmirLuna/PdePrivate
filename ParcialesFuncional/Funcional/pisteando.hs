
ferrari :: Auto
ferrari = Auto{
    marca = "Ferrari",
    modelo = "F50",
    desgaste = (0,0),
    maxVel = 65,
    timeRace = 0
}

lamborghini :: Auto
lamborghini = Auto {
    marca = "Lamborghini",
    modelo = "Diablo",
    desgaste = (7, 4),
    maxVel = 73,
    timeRace = 0
}

fiat :: Auto
fiat = Auto {
    marca = "Fiat",
    modelo = "600",
    desgaste = (80, 27),
    maxVel = 44,
    timeRace = 0
}

data Auto = Auto{
    marca :: String,
    modelo :: String,
    desgaste :: (Float, Float),
    maxVel :: Float,
    timeRace :: Float
}deriving(Show)

type ModificarAuto = Auto -> Auto

chasis :: Auto -> Float
chasis unAuto = fst $ (desgaste unAuto)

ruedas :: Auto -> Float
ruedas unAuto= snd $ (desgaste unAuto)

modificarChasis :: (Float -> Float) -> ModificarAuto
modificarChasis funcion unAuto = unAuto{desgaste = (funcion $ fst (desgaste unAuto), snd $ (desgaste unAuto))}

modificarRuedas :: (Float -> Float) -> ModificarAuto
modificarRuedas funcion unAuto = unAuto{desgaste = (fst $ (desgaste unAuto), funcion $ snd (desgaste unAuto))}

modificarTiempo :: (Float -> Float) -> ModificarAuto
modificarTiempo funcion unAuto = unAuto{timeRace = funcion $ (timeRace unAuto)}

--Ej2
estaEnBuenEstado :: Auto -> Bool
estaEnBuenEstado unAuto = 40> chasis unAuto && 60 > ruedas unAuto

noDaMas :: Auto -> Bool
noDaMas unAuto = 80 < chasis unAuto || 80 < ruedas unAuto

-- Ej3
repararAuto :: ModificarAuto
repararAuto unAuto = modificarRuedas (const 0) . modificarChasis ((-) (chasis unAuto * 0.85)) $ unAuto

-- Ej4
type Trayecto = ModificarAuto

curva :: Float -> Float -> ModificarAuto
curva angulo longitud unAuto = modificarRuedas (+desgasteDeCurva longitud angulo) . tiempoPorCurva longitud $ unAuto

desgasteDeCurva :: Float -> Float -> Float
desgasteDeCurva longitud angulo = 3 * (longitud / angulo)

tiempoPorCurva :: Float -> ModificarAuto
tiempoPorCurva longitud unAuto = modificarTiempo (+longitud / (0.5*(maxVel unAuto))) unAuto

curvaPeligrosa :: Trayecto
curvaPeligrosa = curva 60 300

curvaTranca :: Trayecto
curvaTranca = curva 110 550

recto :: Float -> ModificarAuto
recto longitud unAuto = tiempoPorRecta longitud . modificarChasis (+ 0.01* longitud) $ unAuto

tiempoPorRecta :: Float -> ModificarAuto
tiempoPorRecta longitud unAuto = modificarTiempo (+longitud / (maxVel unAuto)) unAuto

tramoRectoClassic :: Trayecto
tramoRectoClassic = tiempoPorRecta 750

tramito :: Trayecto
tramito = tiempoPorRecta 280

boxes :: Trayecto -> ModificarAuto
boxes tramoDeLasBox unAuto
    | estaEnBuenEstado unAuto   = tramoDeLasBox unAuto
    | otherwise                 = modificarTiempo (+10) . repararAuto $ unAuto

tramoMojado :: Trayecto -> ModificarAuto
tramoMojado trayecto unAuto = modificarTiempo(+ (tiempoDeTramo trayecto unAuto)*0.5) . trayecto $ unAuto

tiempoDeTramo :: Trayecto -> Auto -> Float
tiempoDeTramo trayecto unAuto = timeRace (trayecto unAuto) - (timeRace unAuto)

ripio :: Trayecto -> ModificarAuto
ripio trayecto unAuto = modificarTiempo(+tiempoDeTramo trayecto unAuto *2).trayecto.trayecto $ unAuto

obstruccion :: Float -> ModificarAuto
obstruccion longitudObstruida unAuto = modificarRuedas (+ longitudObstruida*2) unAuto

-- Ej5

pasarPorTramo :: Trayecto -> Auto -> Auto
pasarPorTramo unTrayecto unAuto
    | noDaMas unAuto = unAuto
    | otherwise = unTrayecto unAuto

-- Ej6

type Pista = [Trayecto]
superPista :: Pista
superPista =
    [tramoRectoClassic, curvaTranca, tramoMojado tramito, tramito, obstruccion 2 . curva 80 400, curva 115  650, recto 970, curvaPeligrosa, ripio tramito, boxes (recto 800)]

peganLaVuelta :: Pista -> [Auto] -> [Auto]
peganLaVuelta unaPista losAutos = filter (not. noDaMas). map (unAutoPegaLaVuelta unaPista) $ losAutos

unAutoPegaLaVuelta :: Pista -> Auto -> Auto
unAutoPegaLaVuelta unaPista unAuto = foldr pasarPorTramo unAuto unaPista

--unAutoPegaLaVuelta :: Pista -> Auto -> Auto
--unAutoPegaLaVuelta unaPista unAuto = foldr ($) unAuto unaPista

{-unAutoPegaLaVuelta ::Pista -> Auto -> Auto
unAutoPegaLaVuelta (x:xs) unAuto
    | not.noDaMas $ unAuto = unAutoPegaLaVuelta (xs)  (x unAuto) 
    | otherwise = unAuto-}

-- Ej7

data Carrera :: Carrera {
    pista :: Pista,
    nroDeVueltas :: Int
}deriving (Show)

tourBuenosAires :: Carrera
tourBuenosAires = Carrera{
    pista = superPista,
    nroDeVueltas = 20 
}







