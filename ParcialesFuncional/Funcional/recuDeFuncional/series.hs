data Serie = Seria{
    nombreSerie            :: String  ,
    actores                :: [Actor],
    presupuesto            :: Int     ,
    estimacionDeTemporadas :: Int     ,
    ratingPromedio         :: Float   ,
    estaCancelado          :: Bool
} deriving(Show,Eq)
data Actor = Actor{
    nombreActor   :: String,
    sueldo        :: Int,
    restricciones :: [String]
} deriving(Show,Eq)

modificarCasting :: ([Actor] -> [Actor]) -> Serie -> Serie
modificarCasting funcion unaSerie = unaSerie{actores = funcion . actores $ unaSerie}

modificarTemporadas :: (Int -> Int) -> Serie -> Serie
modificarTemporadas funcion unaSerie = unaSerie{estimacionDeTemporadas = funcion . estimacionDeTemporadas $ unaSerie}

cancelar :: Serie -> Serie
cancelar unaSerie = unaSerie{estaCancelado = True}

--Punto 1
estaEnRojo :: Serie -> Bool
estaEnRojo unaSerie = (>presupuesto unaSerie). sum . map sueldo $ (actores unaSerie) 

esProblematica :: Serie -> Bool
esProblematica = (3<) . length . filter (masDeXRestricciones 1) . actores

masDeXRestricciones :: Int -> Actor -> Bool
masDeXRestricciones minimo = (minimo<).length . restricciones

--Punto 2
type Productor = Serie -> Serie
productorFavoritista :: Actor -> Actor -> Productor
productorFavoritista actorFavorito otroActorFavorito = modificarCasting (([actorFavorito, otroActorFavorito]++) . drop 2)

timBurton :: Productor
timBurton = productorFavoritista (Actor "Johnny Depp" 20000000 []) (Actor "Helena Bonham" 15000000 [])

gatoPardeitor :: Productor
gatoPardeitor = id

estireitor :: Productor
estireitor = modificarTemporadas (2*)

desepereitor :: [Productor] -> Productor
desepereitor productores serie = foldr ($) serie productores

canceleitor :: Float -> Productor
canceleitor cifraCancelatoria unaSerie
    | cifraCancelatoria >= ratingPromedio unaSerie || estaEnRojo unaSerie = cancelar unaSerie
    | otherwise                                                           = unaSerie

--Punto 3
bienestar :: Serie -> Int
bienestar unaSerie
    | not . estaCancelado $ unaSerie       = 0
    | 4 < estimacionDeTemporadas unaSerie  = 5
    | 4 >= estimacionDeTemporadas unaSerie = (2*) . (10 -) . estimacionDeTemporadas $ unaSerie
    | (10 >) . length . actores $ unaSerie = 3
    | otherwise                            = (10 -) . length . filter (masDeXRestricciones 2) . actores $ unaSerie

--Punto 4
--MeDaPaja


