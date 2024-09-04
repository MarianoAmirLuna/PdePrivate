-- Ej   1.a Tenemos personas, de las que se conocen sus habilidades (strings) y si son buenas o
--      no. Dar un sinónimo de tipo y una constante de ejemplo.

-- Ej   1.b Tenemos tambien Power Rangers, de los que conocemos su color, sus habilidades y
--      su nivel de pelea. Nuevamente, dar un sinónimo de tipo y una constante de ejemplo.

data Persona = Persona {
    habilidadesP :: [String],
    esBuena :: Bool
} deriving (Show, Eq)

data PowerRanger = PowerRanger{
    color :: String,
    habilidadesPR :: [String],
    lvPelea :: Int
} deriving (Show, Eq)

--Ejemplos

oscar = Persona {
    habilidadesP = ["Correr", "Saltar", "Luchar"],
    esBuena = True
}

jason :: Persona
jason = Persona { habilidadesP = ["Liderazgo", "Combate", "Dedicación"], esBuena = True }

skull :: Persona
skull = Persona { habilidadesP = ["Travesuras", "Ineptitud"], esBuena = False }

kimberly :: Persona
kimberly = Persona { habilidadesP = ["Agilidad", "Inteligencia"], esBuena = True }

bulk :: Persona
bulk = Persona { habilidadesP = ["Fuerza", "Resistencia"], esBuena = False }

juan :: PowerRanger
juan = PowerRanger { color = "Rojo", habilidadesPR = ["Liderazgo", "Combate", "Dedicacion"], lvPelea = 90 }

maria :: PowerRanger
maria = PowerRanger { color = "Rosa", habilidadesPR = ["Agilidad", "Inteligencia", "Empatia"], lvPelea = 85 }

zack :: PowerRanger
zack = PowerRanger { color = "Negro", habilidadesPR = ["Fuerza", "Velocidad", "Determinacion"], lvPelea = 88 }

trini :: PowerRanger
trini = PowerRanger { color = "Amarillo", habilidadesPR = ["Reflejos", "Astucia", "Disciplina"], lvPelea = 84 }

billy :: PowerRanger
billy = PowerRanger { color = "Azul", habilidadesPR = ["Inteligencia", "Tacticas", "Resolucion"], lvPelea = 82 }


-- Ej   2 convertirEnPowerRanger: dado un color y una persona, convierte a la persona en un
--      ranger de ese color.

convertirEnPowerRanger :: String -> Persona -> PowerRanger
convertirEnPowerRanger color persona = PowerRanger{color= color, habilidadesPR= potenciarHabilidadP persona, lvPelea = aumentarLV persona}

potenciarHabilidadP :: Persona -> [String]
potenciarHabilidadP unaPersona = map ("Super"++) $ habilidadesP unaPersona

aumentarLV :: Persona -> Int
aumentarLV unaPersona = foldr (+) 0 (largoDelNombreDeUnaHabilidad (habilidadesP unaPersona))

largoDelNombreDeUnaHabilidad :: [String] -> [Int]
largoDelNombreDeUnaHabilidad listaDeHabilidades = map length listaDeHabilidades

{-
3. formarEquipoRanger: dada una lista de colores y una lista de personas, genera un
equipo (una lista de Power Rangers) de los colores dados.
El equipo ranger está conformado por las personas buenas, transformadas en ranger, una
para cada color que haya. Por ejemplo, asumiendo que bulk y skull son personas malas, la
siguiente consulta:
formarEquipoRanger ["rojo", "rosa", "azul"] [jason, skull, kimberly, bulk]
Genera a un equipo con jason convertido en ranger rojo, y kimberlyconvertida en ranger
rosa. Nadie se convierte en ranger azul.
-}

formarEquipoRanger :: [String] -> [Persona] -> [PowerRanger]
formarEquipoRanger colores candidatos = zipWith convertirEnPowerRanger colores (filtrarBuenasPersonas candidatos)

filtrarBuenasPersonas :: [Persona] -> [Persona]
filtrarBuenasPersonas todosLosCandidatos = filter esBuena todosLosCandidatos

{-
4.  a. findOrElse: Dada una condición, un valor y una lista, devuelve el primer elemento
que cumpla la condición, o el valor dado si ninguno la cumple.
4.  b. rangerLider: Dado un equipo de rangers, devuelve aquel que debe liderar el equipo:
este es siempre el ranger rojo, o en su defecto, la cabeza del equipo.
-}

findOrElse :: (a -> Bool) -> a -> [a] -> a 
findOrElse condicion valor listaDeValores
    | algunoVerdadero condicion listaDeValores = head.filter condicion $ listaDeValores
    | otherwise = valor

algunoVerdadero :: (a -> Bool) -> [a] -> Bool
algunoVerdadero condicion listaDeValores = any condicion listaDeValores
-- ====================================================================================

rangerLider :: [PowerRanger] -> PowerRanger
rangerLider equipoRanger = findOrElse (("rojo"==).color) (head equipoRanger) equipoRanger

{-
5. a. maximumBy: dada una lista, y una función que tome un elemento y devuelva un valor
ordenable, encuentra el máximo de la misma.
5. b. rangerMásPoderoso: devuelve el ranger de un equipo dado que tiene mayor nivel de
pelea.
-}

-- aplico la funcion a la lista [a] 
maximumBy :: Ord b => [a] -> (a->b) -> a
maximumBy (x:y:xs) funcion
    | funcion x < funcion y = maximumBy (y:xs) funcion
    | otherwise = maximumBy (x:xs) funcion
-- ====================================================================================

rangerMásPoderoso :: [PowerRanger] -> PowerRanger
rangerMásPoderoso equipoRanger = maximumBy equipoRanger lvPelea

{-
7. Alfa 5 es un robot que si bien no sabe pelear, podemos
considerarlo como un ranger honorífico. Su color es metálico, su
habilidad de pelea es cero, y tiene dos habilidades: reparar
cosas y decir "ay ay ay ay ay ay..."" (Sí, infinitos ay )
7. a. Escribir la constante alfa5
7. b. Usando alfa5, si fuera posible, dar un ejemplo de aplicacion
de una función de las definidas anteriormente que termine y otra
que no.
-}

alfa5 = PowerRanger{
    color = "metalico",
    habilidadesPR = "reparar cosas" : repeat "ay",
    lvPelea = 0
}

{-
8. Existe otro escuadrón que combate contra el mal: las chicas
superpoderosas, de las que sabemos su color y cantidad de
pelo.

Al igual que los Power Rangers, su lider es la roja, o la
cabeza del equipo. Desarrollar la función chicaLider, sin
repetir lógica respecto del código ya desarrollado.
Si fuera necesario modificar funciones ya desarrolladas,
escribir sus nuevas versiones.
-}

data ChicasSuperpoderosas = ChicasSuperpoderosas{
    colorCS :: String,
    cantidadDePelo :: Int
} deriving(Show)

-- rangerLider :: [PowerRanger] -> PowerRanger
-- rangerLider equipoRanger = findOrElse (("rojo"==).color) (head equipoRanger) equipoRanger
