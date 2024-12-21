data Aspecto = Aspecto{
    tipoDeAspecto :: String,
    grado         :: Float
}deriving(Eq, Show)

type Situacion = [Aspecto]

-- Función que compara dos aspectos según su grado
mejorAspecto :: Aspecto -> Aspecto -> Bool
mejorAspecto mejor peor = grado mejor < grado peor

-- Función que verifica si dos aspectos tienen el mismo tipo
mismoAspecto :: Aspecto -> Aspecto -> Bool
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2

-- Función que busca un aspecto con el mismo tipo que el aspecto buscado en una lista
buscarAspecto :: Aspecto -> [Aspecto] -> Aspecto
buscarAspecto aspectoBuscado = head . filter (mismoAspecto aspectoBuscado)

-- Función que busca un aspecto de un tipo específico en una lista
buscarAspectoDeTipo :: String -> [Aspecto] -> Aspecto
buscarAspectoDeTipo tipo = buscarAspecto (Aspecto tipo 0)

-- Función que reemplaza un aspecto en una lista
reemplazarAspecto :: Aspecto -> [Aspecto] -> [Aspecto]
reemplazarAspecto aspectoBuscado situacion =
    aspectoBuscado : filter (not . mismoAspecto aspectoBuscado) situacion

--Punto 1
modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto funcion unAspecto = unAspecto{grado = funcion . grado $ unAspecto}

situacionMejor :: Situacion -> Situacion -> Bool
situacionMejor situacion1 situacion2 = all (\aspecto -> mejorAspecto aspecto . buscarAspecto aspecto $ situacion1) $ situacion2 

-- Ejemplos de aspectos
aspectoFuerzaAlta :: Aspecto
aspectoFuerzaAlta = Aspecto "Fuerza" 90

aspectoFuerzaBaja :: Aspecto
aspectoFuerzaBaja = Aspecto "Fuerza" 30

aspectoVelocidad :: Aspecto
aspectoVelocidad = Aspecto "Velocidad" 70

aspectoInteligencia :: Aspecto
aspectoInteligencia = Aspecto "Inteligencia" 50

-- Ejemplos de listas de aspectos
listaAspectos1 :: [Aspecto]
listaAspectos1 = [aspectoFuerzaBaja, aspectoInteligencia]

listaAspectos2 :: [Aspecto]
listaAspectos2 = [aspectoFuerzaAlta, aspectoVelocidad]

--Me aburrio el parcial