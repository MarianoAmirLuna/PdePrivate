data Auto = Auto{
    marca ::    String,
    modelo ::   String,
    desgaste :: Desgaste,
    velMax ::   Float,
    tiempo ::   Float
} deriving (Eq, Show)

type Desgaste = (Float, Float)

chasis :: Desgaste -> Float
chasis = fst

chasisAuto :: Auto -> Float
chasisAuto = fst . desgaste

ruedas :: Desgaste -> Float
ruedas = snd

ruedasAuto :: Auto -> Float
ruedasAuto = snd . desgaste

estaEnBuenEstado :: Auto -> Bool
estaEnBuenEstado = estaBien . desgaste

noDaMas :: Auto -> Bool
noDaMas = noDa . desgaste

estaBien :: Desgaste -> Bool
estaBien elDesgaste = chasis elDesgaste < 40 && ruedas elDesgaste < 60

noDa :: Desgaste -> Bool
noDa elDesgaste = chasis elDesgaste < 80 || ruedas elDesgaste < 80

-- Punto 3
reparaAuto :: Auto -> Auto
reparaAuto unAuto = cambiarDesgasteEnChasis (((chasis . desgaste) unAuto +) . (* 0.15)) . cambiarDesgasteEnRuedas (*0) $ unAuto

cambiarDesgasteEnRuedas :: (Float -> Float) -> Auto -> Auto
cambiarDesgasteEnRuedas funcion unAuto = unAuto{desgaste = (chasisAuto unAuto, funcion . ruedasAuto $ unAuto)}

cambiarDesgasteEnChasis :: (Float -> Float) -> Auto -> Auto
cambiarDesgasteEnChasis funcion unAuto = unAuto{desgaste = (funcion . chasisAuto $ unAuto, ruedasAuto unAuto)}

-- Punto 4
type Pista = Auto -> Auto

curva :: Float -> Float -> Pista
curva angulo longitud unAuto = aumentarTiempo (2 * longitud / (velMax unAuto)) . cambiarDesgasteEnRuedas (3 * (longitud / angulo) +) $ unAuto

aumentarTiempo :: Float -> Pista
aumentarTiempo cantidad unAuto = unAuto{tiempo = cantidad + tiempo unAuto}

curvaPeligrosa :: Pista
curvaPeligrosa = curva 60 300

curvaTranca :: Pista
curvaTranca = curva 110 550

tramoRecto :: Float -> Pista
tramoRecto longitud unAuto = aumentarTiempo (longitud / (velMax unAuto)) . cambiarDesgasteEnChasis (longitud/100 +) $ unAuto

tramoRectoClassic :: Pista
tramoRectoClassic = tramoRecto 750

tramito :: Pista
tramito = tramoRecto 280

boxes :: Pista -> Pista
boxes unaPista unAuto
    | estaEnBuenEstado unAuto = unaPista unAuto
    | otherwise               = aumentarTiempo 10 . reparaAuto $ unAuto

mojado :: Pista -> Pista
mojado unaPista unAuto = aumentarTiempo (0.5 * diferenciaDeTiempo unaPista unAuto) . unaPista $ unAuto

diferenciaDeTiempo :: Pista -> Auto -> Float
diferenciaDeTiempo unaPista unAuto = ((tiempo . unaPista) unAuto -) . tiempo $ unAuto

ripio :: Pista -> Pista
ripio unaPista = unaPista . unaPista

obstruccion :: Float -> Pista -> Pista
obstruccion largo unaPista = cambiarDesgasteEnRuedas (2*largo+) . unaPista

--Punto 5
pasarPorTramo :: Auto -> Pista -> Auto
pasarPorTramo unAuto unaPista
    | not . noDaMas $ unAuto = unaPista unAuto
    | otherwise = unAuto

--Punto 6
type PistaPosta = [Pista]
superPista :: PistaPosta
superPista = [tramoRectoClassic, curvaTranca, mojado tramito, tramito, obstruccion 2 (curva 80 400), curva 115 650,
              tramoRecto 970, curvaPeligrosa, ripio tramito, boxes (tramoRecto 800)]

peganLaVuelta :: PistaPosta -> [Auto] -> [Auto]
peganLaVuelta unaGranPista = filter (not . noDaMas) . map (pegaUNAVuelta unaGranPista)

pegaUNAVuelta :: PistaPosta -> Auto -> Auto
pegaUNAVuelta unaGranPista unAuto = foldl pasarPorTramo unAuto unaGranPista

--Punto 7
data Carrera = Carrera{
    vueltas :: Int       ,
    pista   :: PistaPosta
}

tourBuenosAires :: Carrera
tourBuenosAires = Carrera 20 superPista

correr :: [Auto] -> Carrera -> [[Auto]]
correr autos unaCarrera = take (vueltas unaCarrera) . iterate (peganLaVuelta (pista unaCarrera)) $ autos
