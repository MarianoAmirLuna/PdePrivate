data Turista = Turista{
    cansancio :: Int,
    estres    :: Int,
    idiomas   :: [Idioma],
    viajaSolo :: Bool
}deriving(Eq, Show)
type Idioma = String
----Modificadores----
modificarCansancio :: (Int -> Int) -> Turista -> Turista
modificarCansancio funcion turista = turista{cansancio = funcion . cansancio $ turista}

modificarEstres :: (Int -> Int) -> Turista -> Turista
modificarEstres funcion turista = turista{estres = funcion . estres $ turista}

modificarIdiomas :: ([Idioma] -> [Idioma]) -> Turista -> Turista
modificarIdiomas funcion turista = turista{idiomas = funcion . idiomas $ turista}

---- Excursiones ----
type Excursion = Turista -> Turista
irALaPlaya :: Excursion
irALaPlaya unTurista
    |viajaSolo unTurista = modificarCansancio (flip (-)5) unTurista
    |otherwise           = modificarEstres (flip (-)1) unTurista

apreciarElementoPaisaje :: String -> Excursion
apreciarElementoPaisaje elemento = modificarEstres (flip (-) . length $ elemento)

salirAHablarIdioma :: Idioma -> Excursion
salirAHablarIdioma unIdioma = modificarIdiomas (unIdioma :)

caminar :: Int ->  Excursion
caminar minutos = modificarEstres (flip (-) (intensidadCaminata minutos)) . modificarCansancio (+intensidadCaminata minutos)

intensidadCaminata :: Int -> Int
intensidadCaminata = flip div 4

data TipoMarea = Fuerte | Moderada | Tranquila deriving (Show,Eq)

paseoEnBarco :: TipoMarea -> Excursion
paseoEnBarco tipoMarea unTurista
    | tipoMarea == Fuerte    = modificarCansancio (+10) . modificarEstres (+6) $ unTurista
    | tipoMarea == Moderada  = unTurista
    | otherwise              = apreciarElementoPaisaje "mar" . salirAHablarIdioma "aleman" . caminar 10 $ unTurista

--Punto 1
--Nada nuevo

--Punto 2
hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion unTurista = modificarEstres ( flip (-) (div 10 100)) . excursion $ unTurista

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun :: (Turista -> Int) -> Turista -> Excursion -> Int
deltaExcursionSegun atributo unTurista unaExcursion = deltaSegun atributo unTurista $ unaExcursion unTurista

deltaPositivo :: Int -> Turista -> Excursion -> Bool
deltaPositivo parametro unTurista = (parametro<) . abs . deltaExcursionSegun (length . idiomas) unTurista

excursionEducativa :: Turista -> Excursion -> Bool
excursionEducativa unTurista = deltaPositivo 0 unTurista

excursionDesestresante :: Turista -> [Excursion] -> [Excursion]
excursionDesestresante unTurista = filter (esDesestresante unTurista)

esDesestresante :: Turista -> Excursion -> Bool
esDesestresante unTurista = deltaPositivo 2 unTurista
--Punto 3
type Tour = [Excursion]

completo :: Tour
completo = [caminar 20, apreciarElementoPaisaje "cascada", caminar 40, salirAHablarIdioma "melmacquiano"]

ladoB :: Excursion -> Tour
ladoB excursionElegida = [paseoEnBarco Tranquila, excursionElegida, caminar 120]

islaVecina :: TipoMarea -> Excursion -> Tour
islaVecina marea excursion
    | marea == Fuerte = [paseoEnBarco marea, apreciarElementoPaisaje "lago", excursion, paseoEnBarco marea]
    | otherwise       = [paseoEnBarco marea, excursion, paseoEnBarco marea]

hacerTour :: Tour -> Turista -> Turista
hacerTour  unTour = flip (foldr (hacerExcursion)) unTour . modificarEstres (+ length unTour)

convincentePara :: Turista -> [Tour] -> Bool
convincentePara unTurista unosTours = any (desestresaA unTurista) unosTours

desestresaA :: Turista -> Tour -> Bool
desestresaA unTurista unTour = terminaAcompaniado unTurista unTour && any (esDesestresante unTurista) unTour

terminaAcompaniado :: Turista -> Tour -> Bool
terminaAcompaniado turista actividades = viajaSolo turista && (not . viajaSolo . hacerTour actividades $ turista)

-- ===================================================================== --
efectividadTour :: Tour -> [Turista] -> Int
efectividadTour tour turistas = sum . map (negate . espiritualidad tour) $ filter (tourConveniente tour) turistas

espiritualidad :: Tour -> Turista -> Int
espiritualidad tour turista = deltaSegun indiceEspiritualidad turista (hacerTour tour turista)

indiceEspiritualidad :: Turista -> Int
indiceEspiritualidad turista = cansancio turista + estres turista
