import Data.List (intersect)
--ej2.a
promedioFrecuenciaCardiaca lista = (fromIntegral.sum) lista / (fromIntegral.length) lista
mediciones = [80, 100, 120, 128, 130, 123, 125]

--ej2.b
frecuenciaCardiacaMinuto :: Int -> Int
frecuenciaCardiacaMinuto minuto
    | minuto == 0 = mediciones !! 0
    | minuto == 10 = mediciones !! 1
    | minuto == 20 = mediciones !! 2
    | minuto == 30 = mediciones !! 3
    | minuto == 40 = mediciones !! 4
    | minuto == 50 = mediciones !! 5
    | minuto == 60 = mediciones !! 6
    | otherwise = 0
--Ej2.c
frecuenciasHastaMomento :: Int -> [Int]
frecuenciasHastaMomento min = take (div min 10) mediciones

--ej3
esCapicua :: Eq a => [a] -> Bool
esCapicua lista = lista == reverse lista

{-4.Se tiene información detallada de la duración en minutos de las llamadas que se llevaron a cabo en un período determinado, discriminadas en horario normal y horario reducido. 
duracionLlamadas = 
(("horarioReducido",[20,10,25,15]),("horarioNormal",[10,5,8,2,9,10])). 
A       Definir la función cuandoHabloMasMinutos, devuelve en que horario se habló más cantidad de minutos, en el de tarifa normal o en el reducido. 
Main> cuandoHabloMasMinutos 
"horarioReducido"
B       Definir la función cuandoHizoMasLlamadas, devuelve en que franja horaria realizó más cantidad de llamadas, en el de tarifa normal o en el reducido. 
Main> cuandoHizoMasLlamadas 
"horarioNormal"

Nota: Utilizar composición en ambos casos 
-}
duracionLlamadas = (("horarioReducido",[20,10,25,15]),("horarioNormal",[10,5,8,2,9,10]))
cuandoHabloMasMinutos duracionLlamadas
    |(sum.snd.fst) duracionLlamadas > (sum.snd.snd) duracionLlamadas = "horario Reducido"
    |otherwise = "horario Normal"
cuandoHizoMasLlamadas duracionLlamadas
    | (length.snd.fst) duracionLlamadas < (length.snd.snd) duracionLlamadas = "horario normal"
    | otherwise = "horario Reducido"

--Orden Superior
--ej1
 --Definir la función existsAny/2, que dadas una función booleana y una tupla de tres elementos devuelve True si existe algún elemento de la tupla que haga verdadera la función. 
existsAny fbool ttupla = any fbool ttupla

--ej2
    --Definir la función mejor/3, que recibe dos funciones y un número, y devuelve el resultado de la función que dé un valor más alto.
mejor funcion1 funcion2 numero
    | funcion1 numero > funcion2 numero = funcion1 numero
    | funcion1 numero < funcion2 numero = funcion2 numero

--ej3
    --Definir la función aplicarPar/2, que recibe una función y un par, y devuelve el par que resulta de aplicar la función a los elementos del par.
aplicarPar :: (a -> b) -> [(a,a)] -> [(b,b)]
aplicarPar funcion dupla = map (\(x, y) -> (funcion x, funcion y)) dupla
--ej4
    --Definir la función parDeFns/3, que recibe dos funciones y un valor, y devuelve un par ordenado que es el resultado de aplicar las dos funciones al valor.
parDeFns :: (t -> a) -> (t -> b) -> t -> (a, b)
parDeFns funcion1 funcion2 valor = (funcion1 valor, funcion2 valor)

--Orden Superior + Listas
--ej1
    --Definir la función esMultiploDeAlguno/2, que recibe un número y una lista y devuelve True si el número es múltiplo de alguno de los números de la lista.
esMultiploDe :: Int -> Int -> Bool
esMultiploDe z y = ((mod y z) == 0)


esMultiploDeAlguno :: Int -> [Int] ->Bool
esMultiploDeAlguno numero lista = any (esMultiploDe numero) lista

--ej2
    --Armar una función promedios/1, que dada una lista de listas me devuelve la lista de los promedios de cada lista-elemento.
promedios :: [[Int]] -> [Float]
promedios listas = map promedioDeLista listas

promedioDeLista :: [Int] -> Float
promedioDeLista lista = fromIntegral (sum lista) / fromIntegral (length lista)

--ej4
    --Definir la función mejoresNotas, que dada la información de un curso devuelve la lista con la mejor nota de cada alumno.
mejoresNotas :: Ord a => [[a]] -> [a]
mejoresNotas lista = map maximum lista
--ej5
    --Definir la función aprobó/1, que dada la lista de las notas de un alumno devuelve True si el alumno aprobó.
    --Se dice que un alumno aprobó si todas sus notas son 6 o más.
aprobo listaNotas= all (6<=) listaNotas

--ej7
    --Definir la función divisores/1, que recibe un número y devuelve la lista de divisores.
divisores numero = filter (esMultiploDe numero ) [1..numero]

--ej8
    --Definir la función exists/2, que dadas una función booleana y una lista devuelve True si la función da True para algún elemento de la lista.
exist funcionB lista = any funcionB lista

--Ej9
    --Definir la función hayAlgunNegativo/2, que dada una lista de números y un (…algo…) devuelve True si hay algún nro. negativo. 
hayAlgunNegativo lista algo = any centinela lista 
centinela numero = numero < 0

--Ej 10
    --Definir la función aplicarFunciones/2, que dadas una lista de funciones y un valor cualquiera,
    --devuelve la lista del resultado de aplicar las funciones al valor.
aplicarFunciones listaFunciones valor = map (\f -> f valor) listaFunciones

--Ej 11
    --Definir la función sumaF/2, que dadas una lista de funciones y un número, devuelve la suma del resultado de aplicar las funciones al número.
sumaF listaFunciones numero = sum (aplicarFunciones listaFunciones numero)