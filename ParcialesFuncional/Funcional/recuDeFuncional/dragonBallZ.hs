import Data.List
data Guerrero = Guerrero{
    nombre       :: String,
    ki           :: Float ,
    raza         :: String,
    fatiga       :: Float ,
    personalidad :: String
}  deriving (Eq, Show)

modificarFatiga :: (Float -> Float) -> Guerrero -> Guerrero
modificarFatiga funcion unGuerrero = unGuerrero{fatiga = funcion . fatiga $ unGuerrero}

modificarKi :: (Float -> Float) -> Guerrero -> Guerrero
modificarKi funcion unGuerrero = unGuerrero{ki = funcion . ki $ unGuerrero}

gohan :: Guerrero
gohan = Guerrero "Son Gohan" 10000 "Saiyajin" 0 "Perezosa"

--Punto 2
esPoderoso :: Guerrero -> Bool
esPoderoso unGuerrero = "Saiyajin" == (raza unGuerrero) || ki unGuerrero > 8000

-- Ejercicios --
type Ejercicio = Guerrero -> Guerrero

efectoEjercicio :: (Float -> Float) -> (Float -> Float) -> Guerrero -> Guerrero
efectoEjercicio funcionki funcionCansancio = modificarKi(funcionki) . modificarFatiga (funcionCansancio)

pressBanca :: Ejercicio
pressBanca = efectoEjercicio (90+) (100+)

flexionesDeBrazo :: Ejercicio
flexionesDeBrazo = modificarFatiga(50+)

saltosAlCajon :: Float -> Ejercicio
saltosAlCajon centimetros =  efectoEjercicio (+centimetros/10) (+centimetros/5)

esExperimentado :: Guerrero -> Bool
esExperimentado = (20000 <=) . ki

snatch :: Ejercicio
snatch unGuerrero
    | esExperimentado unGuerrero = efectoEjercicio (*1.1) (*1.05) $ unGuerrero 
    | otherwise                  = modificarFatiga (100+) unGuerrero

-- CANSANCIO --
diferenciaDeAtributo :: (Guerrero -> Float) -> Guerrero -> Ejercicio -> Float
diferenciaDeAtributo unAtributo unGuerrero unEjercicio = (flip (-) (unAtributo unGuerrero)) . unAtributo . unEjercicio $ unGuerrero

ejercicioCansado  :: Ejercicio -> Guerrero -> Guerrero
ejercicioCansado  unEjercicio unGuerrero = efectoEjercicio (+2*diferenciaDeAtributo ki unGuerrero unEjercicio) (+4*diferenciaDeAtributo fatiga unGuerrero unEjercicio) unGuerrero
ejercicioExhausto :: Ejercicio -> Guerrero -> Guerrero
ejercicioExhausto unEjercicio unGuerrero = efectoEjercicio ((*0.98) . flip (-) (diferenciaDeAtributo ki unGuerrero unEjercicio)) (1*) unGuerrero

estaCansado  :: Guerrero -> Bool 
estaCansado  unGuerrero = estaFatigado 0.44 unGuerrero

estaExhausto :: Guerrero -> Bool 
estaExhausto unGuerrero = estaFatigado 0.72 unGuerrero

estaFatigado :: Float -> Guerrero -> Bool
estaFatigado unParametro unGuerrero = unParametro * ki unGuerrero < fatiga unGuerrero

--Punto 3
realizarEjercicio :: Guerrero -> Ejercicio -> Guerrero
realizarEjercicio unGuerrero unEjercicio
    | estaExhausto unGuerrero = ejercicioExhausto unEjercicio unGuerrero
    | estaCansado  unGuerrero = ejercicioCansado  unEjercicio unGuerrero
    | otherwise               = unEjercicio unGuerrero

--RUTINA--
type Descanso = Guerrero -> Guerrero
type Rutina = [(Ejercicio, Descanso)]

--Punto 4
armarRutina :: Guerrero -> [Ejercicio] -> Rutina
armarRutina unGuerrero ejercicios
    | laPersonalidadEs "Sacada"   unGuerrero = intercalarDescanso 0 ejercicios
    | laPersonalidadEs "Perezosa" unGuerrero = intercalarDescanso 5 ejercicios
    | otherwise                              = []

laPersonalidadEs :: String -> Guerrero -> Bool
laPersonalidadEs suPersonalidad unGuerrero = suPersonalidad == personalidad unGuerrero

intercalarDescanso :: Float -> [Ejercicio] -> Rutina
intercalarDescanso undescanso ejercicios = map (\unEjercicio -> (unEjercicio, descansar undescanso)) ejercicios

-- Punto 6
descansar :: Float -> Guerrero -> Guerrero
descansar tiempo = modificarFatiga (max 0 . flip (-) (fibonacci tiempo))

fibonacci :: Float -> Float
fibonacci 0 = 1
fibonacci 1 = 1
fibonacci n = n + fibonacci (n - 1)

--Punto 5
realizarRutina :: Guerrero -> Rutina -> Guerrero
realizarRutina unGuerrero unaRutina = foldr hacerEjercicioYDescansar unGuerrero unaRutina

hacerEjercicioYDescansar :: (Ejercicio, Descanso) -> Guerrero -> Guerrero
hacerEjercicioYDescansar ejercicioYdescanso = descanso ejercicioYdescanso . ejercicio ejercicioYdescanso

descanso :: (Ejercicio, Descanso) -> Descanso
descanso = snd

ejercicio :: (Ejercicio, Descanso) -> Ejercicio
ejercicio = fst

-- Punto 7
--Funciones dadas en el parcial
-- Main*> :t takeWhile
-- takeWhile :: (a -> Bool) -> [a] -> [a]
-- Main*> takeWhile even [2,4,6,5,6,7,8,9]
-- [2,4,6]

-- Main*> :t genericLength
-- genericLength :: Num i => [a] -> i
-- Main*> genericLength [2,4,6,5,6,7,8,9]
-- 8
descansoOptimo :: Guerrero -> Float
descansoOptimo unGuerrero = genericLength . takeWhile (estaCansado . flip descansar unGuerrero) $ (iterate (1.0+) 0.0)
{-
Salidas de la terminal :
    ghci> descansoOptimo (Guerrero "Goku" 10 "Saiyajin" 5 "Perezosa")
    0.0
    ghci> descansoOptimo (Guerrero "Goku" 10 "Saiyajin" 6 "Perezosa")
    2.0
    ghci> descansoOptimo (Guerrero "Goku" 10 "Saiyajin" 10 "Perezosa")
    3.0
    ghci> descansoOptimo (Guerrero "Goku" 10 "Saiyajin" 11 "Perezosa")
    4.0
-}