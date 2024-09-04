data Perrito = Perrito{
    raza :: String,
    juguetesFav :: [String],
    tiempoEnGuarderia :: Int,
    energia :: Float
}deriving (Show)

data Guarderia = Guarderia{
    nombre :: String,
    entrenamiento :: Rutina
}

type Rutina = [(Ejercicio, MinutosDelEjercicio)]
type MinutosDelEjercicio = Int
type Ejercicio = Perrito -> Perrito
type ModificarPerro = Perrito -> Perrito

perritoEjemplo :: Perrito
perritoEjemplo = Perrito {
    raza = "Labrador",
    juguetesFav = ["Pelota", "Hueso"],
    tiempoEnGuarderia = 120,
    energia = 11
}

reemplazarTiempoEnGuarderia :: Int -> ModificarPerro
reemplazarTiempoEnGuarderia valor unPerro = unPerro{tiempoEnGuarderia = valor}

modificarTiempoEnGuarderia :: (Int -> Int) -> ModificarPerro
modificarTiempoEnGuarderia funcionParcial unPerro = unPerro{tiempoEnGuarderia = funcionParcial $ (tiempoEnGuarderia unPerro)}

reemplazarEnergia :: Float -> ModificarPerro
reemplazarEnergia valor unPerro = unPerro{energia = valor}

modificarEnergia :: (Float -> Float) -> ModificarPerro
modificarEnergia funcionParcial unPerro = unPerro{energia = funcionParcial $ (energia unPerro)}

agregarJuguete :: String -> ModificarPerro
agregarJuguete juguete unPerro = unPerro{juguetesFav = juguete : (juguetesFav unPerro)}

quitarJuguete :: ModificarPerro
quitarJuguete unPerro = unPerro{juguetesFav = tail.juguetesFav $ unPerro}

tieneJuguete :: String -> Perrito -> Bool
tieneJuguete elJugueteEnCuestion unPerro = elem elJugueteEnCuestion (juguetesFav unPerro)

jugar :: Ejercicio
jugar unPichicho 
    | energia unPichicho >= 10 = modificarEnergia (flip (-)10) unPichicho
    | otherwise = reemplazarEnergia 0 unPichicho

ladrar :: Float -> Ejercicio
ladrar ladridos unPerro = modificarEnergia (0.5*ladridos+) unPerro

regalar :: String -> Ejercicio
regalar unJuguete unPerro = agregarJuguete unJuguete unPerro

diaDeSpa :: Ejercicio
diaDeSpa unPerro
    | condicionDeSpa unPerro = agregarJuguete " peine de goma " . reemplazarEnergia 100 $ unPerro
    | otherwise = unPerro

esRazaExtravagante :: Perrito -> Bool
esRazaExtravagante unPerro = "dalmata" == raza unPerro || "pomeriana" == raza unPerro

condicionDeSpa :: Perrito -> Bool
condicionDeSpa unPerro = tiempoEnGuarderia unPerro > 50 || esRazaExtravagante unPerro

diaDeCampo :: Ejercicio
diaDeCampo unPerro = jugar . quitarJuguete $ unPerro

zara :: Perrito
zara = Perrito{
    raza = "dalmata",
    juguetesFav = ["pelota", "mantita"],
    tiempoEnGuarderia = 90,
    energia = 80
}

rutinaPdePerritos :: Rutina
rutinaPdePerritos = [(jugar, 30), (ladrar 18, 20), (regalar "pelota", 0), (diaDeSpa, 120), (diaDeCampo, 720)]

guarderiaPdePerritos :: Guarderia
guarderiaPdePerritos = Guarderia{
    nombre = "Guardería P de Perritos",
    entrenamiento = rutinaPdePerritos
}

puedeEstarEnGuarderia :: Perrito -> Guarderia -> Bool
puedeEstarEnGuarderia unPerro unaGuarderia = tiempoEnGuarderia unPerro > (sum . map snd $ entrenamiento unaGuarderia)

esPerroResponsable :: Perrito -> Bool
esPerroResponsable unPerro = (3 <).length.juguetesFav.diaDeCampo $ unPerro

realizarRutina :: Guarderia -> Perrito -> Perrito
realizarRutina unaGuarderia unCanino
    | puedeEstarEnGuarderia unCanino unaGuarderia = aplicarEjercicios (obtenerEjercicios unaGuarderia) unCanino
    | otherwise = unCanino

obtenerEjercicios :: Guarderia -> [Ejercicio]
obtenerEjercicios unaGuarderia = map fst (entrenamiento unaGuarderia)

aplicarEjercicios :: [Ejercicio] -> Perrito -> Perrito
aplicarEjercicios [] unPerro = unPerro
aplicarEjercicios (x:xs) unPerro = aplicarEjercicios (xs) (x $ unPerro)

perrosCansado :: Guarderia -> [Perrito] -> [Perrito]
perrosCansado unaGuarderia algunosPerros = reportarPerrosCansados.map (realizarRutina unaGuarderia) $ algunosPerros

reportarPerrosCansados :: [Perrito] -> [Perrito]
reportarPerrosCansados mixDePerros = filter condicionDeCansancio mixDePerros

condicionDeCansancio :: Perrito -> Bool
condicionDeCansancio unPerro = 5 > energia unPerro

pi :: Perrito
pi = Perrito{
    raza = "labrador",
    juguetesFav = enumerar "soguita",
    tiempoEnGuarderia = 314,
    energia = 159
}

fusionarStrinEInt :: Int -> String -> String
fusionarStrinEInt unNumero unString = unString ++ show unNumero

enumerar :: String -> [String]
enumerar juguete = zipWith fusionarStrinEInt [1..] (repeat juguete)

{-
1_      Sí, debido a que la raza es finita y no esta infinitamente evaluando
2.a_    No converge a un valor ya que evalua los infinitos elementos de la lista esperando encontrar un "hueso"
2.b_    Evalua hasta encontrar la "pelota" y finaliza la evaluacion
2.c_    Evalua hasta encontrar la "soguita 31112" y finaliza
ghci> elem "soguita31112" (enumerar "soguita")
True
3_      Sí, debido a que ningun ejercicio requiere evaluar la cantidad de juguetesFav o si tiene alguno en partícular
4_      Se le agregaria un hueso sin importar que la lista sea infinita

-}