data Jugador = Jugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

bart = Jugador "Bart" "Homero" (Habilidad 25 60)
todd = Jugador "Todd" "Ned" (Habilidad 15 80)
rafa = Jugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = Tiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord b => (a -> b) -> a -> a -> a
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

-- Definición de los efectos de los tiros para cada tipo de palo
type EfectoTiro = Habilidad -> Tiro

putter :: EfectoTiro
putter habilidad = Tiro { velocidad = 10, precision = precisionJugador habilidad * 2, altura = 0 }

madera :: EfectoTiro
madera habilidad = Tiro { velocidad = 100, precision = div (precisionJugador habilidad) 2, altura = 5 }

hierro :: Int -> EfectoTiro
hierro variable habilidad = Tiro { velocidad = fuerzaJugador habilidad * variable, precision = div (precisionJugador habilidad) variable, altura = max 0 (variable - 3) }

-- Definición de la constante palos que contiene los efectos de cada palo
palos :: [EfectoTiro]
palos = [putter, madera] ++ map hierro [1..10]

{-
2_   Definir la función golpe que dados una persona y un palo, obtiene el tiro resultante de usar ese palo con las habilidades de la persona.
Por ejemplo si Bart usa un putter, se genera un tiro de velocidad = 10, precisión = 120 y altura = 0.

-}

golpe :: Jugador -> EfectoTiro -> Tiro
golpe unJugador unPalo = unPalo (habilidad unJugador)

{-
3_    Lo que nos interesa de los distintos obstáculos es si un tiro puede superarlo, y en el caso de poder superarlo,
cómo se ve afectado dicho tiro por el obstáculo. En principio necesitamos representar los siguientes obstáculos:
3.a   Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de
la velocidad del tiro. Al salir del túnel la velocidad del tiro se duplica, la precisión pasa a ser 100 y la altura 0.
3.b   Una laguna es superada si la velocidad del tiro es mayor a 80 y tiene una altura de entre 1 y 5 metros. Luego de
superar una laguna el tiro llega con la misma velocidad y precisión, pero una altura equivalente a la altura original
dividida por el largo de la laguna.
3.c   Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor
a 95. Al superar el hoyo, el tiro se detiene, quedando con todos sus componentes en 0.

Se desea saber cómo queda un tiro luego de intentar superar un obstáculo, teniendo en cuenta que en caso de no superarlo, se detiene, quedando con todos sus componentes en 0.
-}

type ModificarTiro = Tiro -> Tiro


tiroNulo :: Tiro
tiroNulo = tiroNulo { velocidad = 0, precision = 0, altura = 0 }

cambiaVelocidad :: (Int -> Int) -> ModificarTiro
cambiaVelocidad funcion unTiro = unTiro{velocidad = funcion $ velocidad unTiro}

cambiaAltura :: (Int -> Int) -> ModificarTiro
cambiaAltura funcion unTiro = unTiro{altura = funcion $ altura unTiro}

cambiaPrecision :: (Int -> Int) -> ModificarTiro
cambiaPrecision funcion unTiro = unTiro{precision = funcion $ precision unTiro}

data Obstaculo = Obstaculo{
  condicion     :: Tiro -> Bool,
  consecuencia  :: ModificarTiro
}

superarObstaculo :: Obstaculo -> ModificarTiro
superarObstaculo unObstaculo unTiro
  | (condicion unObstaculo) unTiro = (consecuencia unObstaculo) unTiro
  | otherwise = tiroNulo

tunelConRampa :: Obstaculo
tunelConRampa = Obstaculo condicionRampa consecuenciaRampa

condicionRampa :: Tiro -> Bool
condicionRampa unTiro = precision unTiro > 90 && altura unTiro == 0

consecuenciaRampa :: ModificarTiro
consecuenciaRampa unTiro = cambiaAltura(const 0) . cambiaPrecision (const 100) . cambiaVelocidad (*2) $ unTiro

laguna :: Int -> Obstaculo
laguna largoLaguna = Obstaculo condicionLaguna (consecuenciaLaguna largoLaguna)

consecuenciaLaguna :: Int -> ModificarTiro
consecuenciaLaguna largoLaguna tiro = cambiaAltura (flip div largoLaguna) tiro

condicionLaguna :: Tiro -> Bool
condicionLaguna unTiro = velocidad unTiro > 80 && elem (altura unTiro) [1..5]

hoyo :: Obstaculo
hoyo = Obstaculo condicionHoyo consecuenciaHoyo

condicionHoyo :: Tiro -> Bool
condicionHoyo unTiro = elem (velocidad unTiro) [5..20] && altura unTiro == 0 && (precision unTiro) > 95

consecuenciaHoyo :: ModificarTiro
consecuenciaHoyo unTiro = cambiaAltura(const 0) . cambiaPrecision (const 100) . cambiaVelocidad (*2) $ unTiro

{-
4_  
  a.  Definir palosUtiles que dada una persona y un obstáculo, permita determinar qué palos le sirven para superarlo.
  b.  Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.
Por ejemplo, para un tiro de velocidad = 10, precisión = 95 y altura = 0, y una lista con dos túneles con rampita seguidos
de un hoyo, el resultado sería 2 ya que la velocidad al salir del segundo túnel es de 40, por ende no supera el hoyo.
BONUS: resolver este problema sin recursividad, teniendo en cuenta que existe una función takeWhile :: (a -> Bool) -> [a] -> [a]
que podría ser de utilidad.
  c.  Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite
superar más obstáculos con un solo tiro.
-}

palosUtiles :: Jugador -> Obstaculo -> [EfectoTiro]
palosUtiles unJugador algunObstaculo = filter ((condicion algunObstaculo).(golpe unJugador)) palos

