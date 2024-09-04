data Vigilante = Vigilante{
    nombre :: String,
    habilidades :: [String],
    aparicion :: Int,
    estado :: Bool,
    agentesDelGobierno :: Bool
} deriving (Show, Eq)

elComediante = Vigilante "El Comediante" ["Fuerza"] 1942 True True
buhoNocturno0 = Vigilante "Buho Nocturno" ["Lucha", "Ingenierismo"] 1963 False False
rorschach = Vigilante "Rorschach" ["Perseverancia", "Deduccion", "Sigilo"] 1964 True False
espectroDeSeda0 = Vigilante "Espectro de Seda" ["Lucha", "Sigilo", "Fuerza"] 1962 False False
ozimandias = Vigilante "Ozimandias" ["Inteligencia", "Más Inteligencia Aún"] 1968 True False
buhoNocturno1 = Vigilante "Buho Nocturno" ["Lucha", "Inteligencia", "Fuerza"] 1939 True False
espectroDeSeda1 = Vigilante "Espectro de Seda" ["Lucha", "Sigilo"] 1940 True False

wachiturros :: [Vigilante]
wachiturros = [elComediante, buhoNocturno0, buhoNocturno1, rorschach, espectroDeSeda0, espectroDeSeda1, ozimandias]

type Evento = [Vigilante] -> [Vigilante]
destruccionNiuShork :: Evento
destruccionNiuShork avengersDeLaSalada = expulsar (not.estaRorschachYManha) avengersDeLaSalada ++ map jubilar (filter (estaManhattan) avengersDeLaSalada)
-- Preguntar : cómo componer la parte derecha del ++, si saco los parentesis Haskell no entiende la composicion
expulsar :: (a->Bool) -> [a] -> [a]
expulsar criterio laSuicideSquad = filter (criterio) laSuicideSquad

estaRorschachYManha :: Vigilante -> Bool
estaRorschachYManha elPibardo = "Rorschach"== (nombre elPibardo) || "Dr. Manhattan" == (nombre elPibardo)

estaManhattan :: Vigilante -> Bool
estaManhattan elPibe = "Dr. Manhattan" == (nombre elPibe)

jubilar :: Vigilante -> Vigilante
jubilar unSalame = unSalame{estado = False}
-- ===========================================================================================================
muerteDeUnVigilante :: Evento
muerteDeUnVigilante (x:xs)
    | any (mismoNombre x) xs = muerteDeUnVigilante.expulsar (not. mismoNombre x) $ (x:xs)
    | otherwise = muerteDeUnVigilante (xs)

mismoNombre :: Vigilante -> Vigilante -> Bool
mismoNombre unFlaco otroFlaco = (nombre unFlaco) == (nombre otroFlaco)

-- ============================================================================================================
{-
guerra de Vietnam: a los vigilantes que además son agentes del gobierno les agrega Cinismo como habilidad, a los restantes no.
-}

guerraDeVietnam :: Evento
guerraDeVietnam algunosCinicos = map (agregarHabilidad "Cinismo") . filter (agentesDelGobierno) $ algunosCinicos

agregarHabilidad :: String -> Vigilante -> Vigilante
agregarHabilidad habilidad unCinico = unCinico{habilidades = habilidad : (habilidades unCinico)}

-- ============================================================================================================
{-
accidente de laboratorio: en un año dado, aparece un nuevo vigilante, el Doctor Manhattan. Tiene una única habilidad que es
la manipulación de la materia a nivel atómico. 
-}

accidenteDeLaboratorio :: Int -> Vigilante
accidenteDeLaboratorio unAnio = Vigilante "Dr. Manhattan" ["Manipulación de la materia a nivel atómico"] unAnio True True

-- ============================================================================================================
{-
acta de Keene: se van del grupo los héroes viejos (para los que existe al menos un sucesor) mientras que el sucesor permanece.
-}
{-
actaDeKeene :: Evento
actaDeKeene (x:y:xs)
    |(x) = x
    |any (mismoNombre x) xs = (heroeMasReciente x (listaDeNombresIguales (x:xs)) $ ((:) . actaDeKeene . listaDeNombresDesIguales $ xs
    |otherwise =  actaDeKeene (y:xs)

elMasJoven :: Vigilante -> Vigilante -> Vigilante
elMasJoven heroe1 heroe2
    | aparicion heroe1 > (aparicion heroe2) = heroe2
    | otherwise = heroe1

listaDeNombresIguales :: [Vigilante] -> [Vigilante]
listaDeNombresIguales (x:xs) = filter (mismoNombre x) xs

listaDeNombresDesIguales :: [Vigilante] -> [Vigilante]
listaDeNombresDesIguales (x:xs) = filter (not.mismoNombre x) xs

heroeMasReciente :: Vigilante -> [Vigilante] -> Vigilante
heroeMasReciente heroeAnciano restoDeHeores = foldr1 elMasJoven restoDeHeores
-}

{-
1_  Codificar las funciones necesarias para representar el desarrollo de una historia, conformada por una
sucesión de eventos como los anteriores, que le sucede a un grupo de vigilantes. El objetivo es saber cómo
queda el grupo de vigilantes al terminar la historia.  
Mostrar cómo se puede utilizar las funciones anteriores para hacer que transcurra la siguiente historia:
-}

haciendoHistoria :: [Evento] -> Evento
haciendoHistoria unaSucesionDeEventos losVigilantes = foldr1 unaSucesionDeEventos losVigilantes

