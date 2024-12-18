import Text.Show.Functions()

data Mago = Mago{
    nombre    :: String,
    edad     :: Int,
    salud    :: Int,
    hechizos :: [Hechizo]
} deriving(Show)

modificarSalud :: (Int -> Int) -> Mago -> Mago
modificarSalud funcion unGuerrero = unGuerrero{salud = funcion . salud $ unGuerrero}

modificarHechizos :: ([Hechizo] -> [Hechizo]) -> Mago -> Mago
modificarHechizos funcion unMago = unMago{hechizos = funcion . hechizos $ unMago}
--Punto 1
type Hechizo = Mago -> Mago
curar :: Int -> Hechizo
curar cantidad = modificarSalud (cantidad+)

lanzarRayo :: Hechizo
lanzarRayo unMago
    | 10 < salud unMago = modificarSalud (flip (-) 10) unMago
    | otherwise         = modificarSalud (flip (-) . (flip div 2) . salud $ unMago) unMago

amnesia :: Int -> Hechizo
amnesia cantidad = modificarHechizos (drop cantidad)

confundir :: Hechizo
confundir unMago = ($ unMago) . head . hechizos $ unMago

--Punto 2
poder :: Mago -> Int
poder unMago = (salud unMago +) . (edad unMago *) . length . hechizos $ unMago

danio :: Hechizo -> Mago -> Int
danio unHechizo = diferencia salud unHechizo

diferencia :: (Mago -> Int) -> Hechizo -> Mago -> Int
diferencia atributo unHechizo unMago = (atributo unMago -) . atributo . unHechizo $ unMago

diferenciaDePoder :: Mago -> Mago -> Int
diferenciaDePoder unMago otroMago = abs . (poder unMago -) . poder $ otroMago

--Punto 3
data Academia = Academia{
    magos :: [Mago],
    examenDeIngreso :: Mago -> Bool
}deriving (Show)

hayMagosNoCalificados :: Academia -> Bool
hayMagosNoCalificados = any noEstaCalificado . magos

noEstaCalificado :: Mago -> Bool
noEstaCalificado unMago = ((0==) . cantidadDeHechizos) unMago && (not . seLlama "Ricenwind") unMago

seLlama :: String -> Mago -> Bool
seLlama unNombre unMago = (unNombre ==) . nombre $ unMago

cantidadDeHechizos :: Mago -> Int
cantidadDeHechizos = length . hechizos

todosLosViejosSonNionios :: Academia -> Bool
todosLosViejosSonNionios = all sonNionios . filter (sonViejos) . magos

sonViejos :: Mago -> Bool
sonViejos = (50<) . edad

sonNionios :: Mago -> Bool
sonNionios unMago = (salud unMago <) . length . hechizos $ unMago

noPasarianIngreso :: Academia -> [Mago]
noPasarianIngreso unaAcademia = filter (not . volveriaAPasar unaAcademia) . magos $ unaAcademia

volveriaAPasar :: Academia -> Mago -> Bool
volveriaAPasar unaAcademia = examenDeIngreso unaAcademia

edadTotalDeAplicados :: Academia -> Int
edadTotalDeAplicados = sum . map edad . filter (esAplicado) . magos

esAplicado :: Mago -> Bool
esAplicado = (10<) . length . hechizos

--Punto 4
maximoSegun :: Ord b => (c -> a -> b) -> c -> [a] -> a
maximoSegun criterio valor comparables = foldl1 (mayorSegun $ criterio valor) comparables

mayorSegun :: Ord b => (a -> b) -> a -> a -> a
mayorSegun evaluador comparable1 comparable2
    | evaluador comparable1 >= evaluador comparable2 = comparable1
    | otherwise = comparable2

mejorHechizoContra :: Mago -> Mago -> Hechizo
mejorHechizoContra magoAfectado magoAtacante = maximoSegun (flip danio) magoAfectado (hechizos magoAtacante)

mejorOponente :: Mago -> Academia -> Mago
mejorOponente unMago unaAcademia = maximoSegun (diferenciaDePoder) unMago (magos unaAcademia)

--Punto 5
{-
Definir la siguiente funcion sin utilizar recursividad:
noPuedeGanarle
Decimos que el segundo mago no puede ganarle al primero si, luego de hechizarlo con todos
los hechizos que conoce (uno atrás del otro) la salud del primer mago sigue siendo la misma.
-}
noPuedeGanarle :: Mago -> Mago -> Bool
noPuedeGanarle magoVictorioso magoPerdedor = (salud magoVictorioso ==) . salud . foldr ($) magoVictorioso $ (hechizos magoPerdedor)