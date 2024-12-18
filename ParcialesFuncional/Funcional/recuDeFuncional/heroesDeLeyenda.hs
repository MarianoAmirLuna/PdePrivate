data Heroe = Heroe{
    nombreHeroe    :: String,
    epiteto        :: String,
    reconocimiento :: Int,
    artefactos     :: [Artefacto],
    labor          :: [Tarea]
}

data Artefacto = Artefacto{
    nombreArtefacto :: String,
    rareza :: Int
} deriving (Show, Eq)

type Tarea = Heroe -> Heroe

--Punto 2
pasarALaHistoria :: Heroe -> Heroe
pasarALaHistoria = otorgarEpitetoYArtefacto

otorgarEpitetoYArtefacto :: Heroe -> Heroe
otorgarEpitetoYArtefacto unHeroe
    | 1000 < reconocimiento unHeroe                                =                                                       cambiarEpiteto "El mitico"      unHeroe
    | 500 <= reconocimiento unHeroe                                = otorgarArtefacto (Artefacto "Lanza del Olimpo" 100) . cambiarEpiteto "El magnifico" $ unHeroe
    | 500 > reconocimiento unHeroe && 100 < reconocimiento unHeroe = otorgarArtefacto (Artefacto "Xiphos" 50)            . cambiarEpiteto "Hoplita"      $ unHeroe
    | otherwise                                                    = unHeroe

cambiarEpiteto :: String -> Tarea
cambiarEpiteto unEpiteto unHeroe = unHeroe{epiteto = unEpiteto}

ganarReconocimiento :: Int -> Tarea
ganarReconocimiento unValor unHeroe = unHeroe{reconocimiento = unValor + reconocimiento unHeroe}

otorgarArtefacto :: Artefacto -> Tarea
otorgarArtefacto unArtefacto unHeroe = unHeroe{artefactos = unArtefacto : artefactos unHeroe}

perderArtefacto :: ([Artefacto] -> [Artefacto]) -> Tarea
perderArtefacto modificador unHeroe = unHeroe{artefactos = modificador . artefactos $ unHeroe}

multiplicarRareza :: Int -> Artefacto -> Artefacto
multiplicarRareza unValor unArtefacto = unArtefacto{rareza = (*unValor) . rareza $ unArtefacto}

--Punto 3
encontrarUnArtefacto :: Artefacto -> Tarea
encontrarUnArtefacto unArtefacto = ganarReconocimiento (rareza unArtefacto) . otorgarArtefacto unArtefacto

escalarOlimpo :: Tarea
escalarOlimpo = obtenerArtefactosOlimpicos . ganarReconocimiento 500 . otorgarArtefacto relampagoZ

obtenerArtefactosOlimpicos :: Heroe -> Heroe
obtenerArtefactosOlimpicos unHeroe = unHeroe{artefactos = filter ((1000 <=) . rareza) . map (multiplicarRareza 3) . artefactos $ unHeroe}

ayudarACruzarLaCalle :: Int -> Tarea
ayudarACruzarLaCalle cuadrasCruzadas = cambiarEpiteto ("Gros" ++ replicate cuadrasCruzadas 'o')

matarUnaBestia :: Bestia -> Tarea
matarUnaBestia unaBestia unHeroe
    | (debilidad unaBestia) unHeroe         = cambiarEpiteto ("El asesino de " ++ (nombreBestia unaBestia)) unHeroe
    | otherwise                             = cambiarEpiteto "El cobarde" . perderArtefacto (drop 1) $ unHeroe

data Bestia = Bestia{
    nombreBestia :: String,
    debilidad    :: Debilidad
}

type Debilidad = Heroe -> Bool

relampagoZ :: Artefacto
relampagoZ = Artefacto "Relampago de Zeus" 500

--Punto 4
heracles :: Heroe
heracles = Heroe "Heracles" "Guardian del olimpo" 700 [(Artefacto "Pistola" 1000), relampagoZ] [matarUnaBestia leonDeNemea]

--Punto 5
leonDeNemea :: Bestia
leonDeNemea = Bestia "Leon de Nemea" ((20<=) . length . epiteto)

--Punto 6
hacer :: Tarea -> Heroe -> Heroe
hacer unaTarea = agregarTarea unaTarea

agregarTarea :: Tarea -> Heroe -> Heroe
agregarTarea unaTarea unHeroe = unHeroe{labor = unaTarea : labor unHeroe}
--Punto 7
presumir :: Heroe -> Heroe -> (Heroe, Heroe)
presumir unHeroe otroHeroe
    | gana unHeroe otroHeroe = (unHeroe, otroHeroe)
    | gana otroHeroe unHeroe = (otroHeroe, unHeroe)
    | otherwise              = presumir (realizarTareasDe unHeroe otroHeroe) (realizarTareasDe otroHeroe unHeroe)

realizarTareasDe :: Heroe -> Heroe -> Heroe
realizarTareasDe unHeroe otroHeroe = realizarLabor (labor otroHeroe) unHeroe

gana :: Heroe -> Heroe -> Bool
gana unHeroe otroHeroe = reconocimientoMayor unHeroe otroHeroe  || mayorRarezas unHeroe otroHeroe 

reconocimientoMayor :: Heroe -> Heroe -> Bool
reconocimientoMayor unHeroe otroHeroe = reconocimiento unHeroe > reconocimiento otroHeroe

mayorRarezas :: Heroe -> Heroe -> Bool
mayorRarezas unHeroe otroHeroe =  reconocimiento unHeroe == reconocimiento otroHeroe && rarezaDe unHeroe > rarezaDe otroHeroe

rarezaDe :: Heroe -> Int
rarezaDe = sum . (map rareza) . artefactos

--Punto 9
realizarLabor :: [Tarea] -> Heroe -> Heroe
realizarLabor labores unHeroe = foldr hacer unHeroe labores