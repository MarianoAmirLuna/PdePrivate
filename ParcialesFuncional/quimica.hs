import Text.Show.Functions
import Data.List

data Sustancia =
    Sencilla {
        nombre :: String,
        simbolo_quimico :: String,
        numero_atomico :: Int,
        grupo :: Grupo
    }
    | Compuesta {
        nombre :: String,
        componentes :: [Componente],
        grupo :: Grupo
    } deriving (Show)

data Grupo = Metal | NoMetal | Halogeno | GasNoble deriving (Show, Eq)

data Componente = Componente{
    sustancia :: Sustancia,
    cantidad_moleculas :: Int
} deriving (Show)

hidrogeno :: Sustancia
hidrogeno = Sencilla{
    nombre = "Hidrogeno",
    simbolo_quimico = "H",
    numero_atomico = 1,
    grupo = NoMetal
}
oxigeno :: Sustancia
oxigeno = Sencilla{
    nombre = "Oxigeno",
    simbolo_quimico = "O",
    numero_atomico = 8,
    grupo = NoMetal
}
agua :: Sustancia
agua = Compuesta {
    nombre = "Agua",
    componentes = [Componente hidrogeno 2, Componente oxigeno 1],
    grupo = NoMetal
}

data Criterio = Electricidad | Calor deriving (Show)
conduceBien :: Criterio -> Sustancia -> Bool
conduceBien _ (Sencilla _ _ _ Metal) = True
conduceBien _ (Compuesta _ _ Metal) = True
conduceBien Electricidad (Sencilla _ _ _ GasNoble) = True
conduceBien Calor (Compuesta _ _ Halogeno) = True
conduceBien _ _ = False


nombreDeLaFuncion :: String -> String
nombreDeLaFuncion nombre
    | (esVocal (last nombre))==False = nombre ++ "uro"
    | otherwise = nombreDeLaFuncion (init nombre)

esVocal palabras
    | palabras == 'a' = True
    | palabras == 'e' = True
    | palabras == 'i' = True
    | palabras == 'o' = True
    | palabras == 'u' = True
    | otherwise = False

combinar :: String -> String -> String
combinar nombre1 nombre2 = nombreDeLaFuncion (nombre1) ++ "de" ++ nombre2

mezclar :: Sustancia a => [a] -> Sustancia
mezclar ListaComponentes = Compuesta {
    nombre =  show (map (\nombreDeLaFuncion -> nombreDeLaFuncion (nombre1) ++ "de" ) ListaComponentes),
    componentes = ListaComponentes,
    grupo = NoMetal
}