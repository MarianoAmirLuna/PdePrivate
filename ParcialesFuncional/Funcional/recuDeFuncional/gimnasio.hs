data Gimnasta = Gimnasta{
    peso         :: Int,
    tonificacion :: Int
}deriving (Show, Eq)

data Rutina = Rutina {
 nombre :: String,
 duracionTotal :: Int,
 ejercicios :: [Ejercicio]
}
type Ejercicio = Int -> Gimnasta -> Gimnasta

{-
ENUNCIADO
    De cada gimnasta nos interesa saber su peso y su coeficiente de tonificación (cdt).

    Los profesionales del gimnasio preparan rutinas de ejercicios pensadas para
las necesidades de cada gimnasta. Una rutina es una lista de ejercicios que
el gimnasta realiza durante unos minutos para quemar calorías y tonificar 
sus músculos.
-}

{-
1_  Modelar a los Gimnastas y las operaciones necesarias para hacerlos ganar
tonificación y quemar calorías considerando que por cada 500 calorías quema-
das se baja 1 kg de peso.
-}

tonificar :: Int -> Gimnasta -> Gimnasta
tonificar n unGimnasta = unGimnasta{ tonificacion = tonificacion unGimnasta + n}

quemarCalorias :: Int -> Gimnasta -> Gimnasta
quemarCalorias caloriasQuemadas unGymRat = unGymRat{ peso = peso unGymRat - kilosPerdidos caloriasQuemadas}

kilosPerdidos calorias = div calorias 500

{-
2_  Modelar los siguientes ejercicios del gimnasio:
    a.  La cinta es una de las máquinas más populares entre los socios
    que quieren perder peso. Los gimnastas simplemente corren sobre la
    cinta y queman calorías en función de la velocidad promedio alcan-
    zada (quemando 10 calorías por la velocidad promedio por minuto).
        La cinta puede utilizarse para realizar dos ejercicios diferentes:

            i.La caminata es un ejercicio en cinta con velocidad constante de 5 km/h.
            ii.El pique arranca en 20 km/h y cada minuto incrementa la velocidad en
            1 km/h, con lo cual la velocidad promedio depende de los minutos de entre-
            namiento.
    
    b.  Las pesas son el equipo preferido de los que no quieren perder
    peso, sino ganar musculatura. Una sesión de levantamiento de pesas
    de más de 10 minutos hace que el gimnasta gane una tonificación e-
    quivalente a los kilos levantados. Por otro lado, una sesión de me-
    nos de 10 minutos es demasiado corta, y no causa ningún efecto en
    el gimnasta.
    
    c.  La colina es un ejercicio que consiste en ascender y descender
    sobre una superficie inclinada y quema 2 calorías por minuto multi-
    plicado por la inclinación con la que se haya montado la superficie.

    Los gimnastas más experimentados suelen preferir otra versión de es-
    te ejercicio: la montaña, que consiste en 2 colinas sucesivas (asig-
    nando a cada una la mitad del tiempo total), donde la segunda colina
    se configura con una inclinación de 5 grados más que la inclinación
    de la primera. Además de la pérdida de peso por las calorías quemadas
    en las colinas, la montaña incrementa en 3 unidades la tonificación
    del gimnasta.
-}

cinta :: Int -> Ejercicio
cinta velocidadPromedio minutos = quemarCalorias (velocidadPromedio * minutos * 10)

caminata :: Ejercicio
caminata = cinta 5

pique :: Ejercicio
pique tiempo = cinta tiempo (div tiempo 2 + 20)

pesas :: Int -> Ejercicio
pesas peso tiempo
    | tiempo >= 10  = tonificar peso
    | otherwise     = id

colina :: Int -> Ejercicio
colina inclinacion tiempo = quemarCalorias (inclinacion * tiempo * 2)

montania :: Int -> Ejercicio
montania inclinacion tiempoTotal = tonificar 3 . colina (inclinacion + 5) (tiempoTotal `div` 2) . colina inclinacion (tiempoTotal `div` 2)

{-
3_  Dado un gimnasta y una Rutina de Ejercicios implementar una función realizarRutina,
que dada una rutina y un gimnasta retorna el gimnasta resultante de realizar todos los
ejercicios de la rutina, repartiendo el tiempo total de la rutina en partes iguales. Mos-
trar un ejemplo de uso con una rutina que incluya todos los ejercicios del punto anterior.
-}

realizarRutina :: Gimnasta -> Rutina -> Gimnasta
realizarRutina unGymRat unaRutina = foldl (\gymbro ejercicio -> ejercicio (tiempoEquitativo unaRutina) gymbro) unGymRat (ejercicios unaRutina)

tiempoEquitativo :: Rutina -> Int
tiempoEquitativo unaRutina = div (duracionTotal unaRutina) . length . ejercicios $ unaRutina

{-
4_  Definir las operaciones necesarias para hacer las siguientes consultas a partir de una lista de rutinas:
        a.  ¿Qué cantidad de ejercicios tiene la rutina con más ejercicios?
  
        b.  ¿Cuáles son los nombres de las rutinas que hacen que un gimnas-
        ta dado gane tonificación?
  
        c.  ¿Hay alguna rutina peligrosa para cierto gimnasta? Decimos que
        una rutina es peligrosa para alguien si lo hace perder más de la mi-
        tad de su peso.
-}

rutinaConMasEjercicios :: [Rutina] -> Int
rutinaConMasEjercicios = maximum . map (length . ejercicios)

rutinaTonificadora ::Gimnasta -> [Rutina] -> [String]
rutinaTonificadora unGymRat = map nombre . filter (\rutina -> (tonificacion unGymRat /=) . tonificacion . realizarRutina $ unGymRat)

esPeligrosa :: Gimnasta -> Rutina -> Bool
esPeligrosa unGimnasta = (div (peso unGimnasta) 2 >=) . peso . realizarRutina unGimnasta

tieneRutinasPeligrosas :: Gimnasta -> [Rutina] -> Bool
tieneRutinasPeligrosas gimnasta = any (\rutina-> esPeligrosa gimnasta rutina) 