data Criatura = Criatura{
    peligrosidad :: Int,
    comoDeshacerse :: Persona -> Bool
}

data Persona = Persona{
    edad :: Int,
    items :: [Item],
    experiencia :: Int
}deriving (Eq, Show)
type Item = String

-- ========================= Ejemplo Criaturas ========================= --
siempreDetras :: Criatura
siempreDetras = Criatura 0 (const False)

gnomos :: Int -> Criatura
gnomos cantidadGnomos = Criatura (2^cantidadGnomos) puedeDeshacerseGnomos

fantasma :: Int -> (Persona -> Bool) -> Criatura
fantasma categoria asuntoPendiente = Criatura (20*categoria) asuntoPendiente

puedeDeshacerseGnomos :: Persona -> Bool
puedeDeshacerseGnomos = tieneItem "Soplador de hojas"

-- ========================= Ejemplo Personas ========================= --
dipper :: Persona
dipper = Persona 12 ["Soplador de hojas", "Disfraz de Oveja"] 100

-- ========================= Funciones Utiles ========================= --
modificarEXP :: (Int -> Int) -> Persona -> Persona
modificarEXP funcion unaPersona = unaPersona{experiencia = funcion . experiencia $ unaPersona }

diferenciaEnAtributo :: (Persona -> Int) -> (Persona -> Persona) -> Persona -> Int
diferenciaEnAtributo atributo funcion unaPersona = (flip (-) . atributo $ unaPersona) . atributo . funcion $ unaPersona 

tieneItem :: String -> Persona -> Bool
tieneItem item = elem item . items
--Punto 2
enfrentarCriatura :: Criatura -> Persona -> Persona
enfrentarCriatura unacriatura unaPersona
    | comoDeshacerse unacriatura $ unaPersona = modificarEXP (+ peligrosidad unacriatura) unaPersona
    | otherwise                               = modificarEXP (+ 1) unaPersona

--Punto 3
experienciaResultante :: [Criatura] -> Persona -> Int
experienciaResultante criaturas = diferenciaEnAtributo experiencia (flip enfrentarCriaturas criaturas)

enfrentarCriaturas :: Persona -> [Criatura] -> Persona
enfrentarCriaturas unaPersona = foldr (enfrentarCriatura) unaPersona

-- Punto 3.b
asuntoPendiente1 :: Persona -> Bool
asuntoPendiente1 unaPersona = ((13>) . edad $ unaPersona) && tieneItem "Disfraz de Oveja" unaPersona

asuntoPendiente2 :: Persona -> Bool
asuntoPendiente2 = (10<=) . experiencia 

ejemploConsulta :: [Criatura]
ejemploConsulta = [siempreDetras, gnomos 10, fantasma 3 asuntoPendiente1, fantasma 1 asuntoPendiente2]

{-
ghci> experienciaResultante ejemploConsulta dipper
1105
ghci> experiencia . enfrentarCriaturas dipper $ ejemploConsulta
1205
-}

--PARTE 2
--Punto 1
zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf _ _ _ [] = []
zipWithIf _ _ [] _ = []
zipWithIf funcion condicion (x:xs) (y:ys)
    | not . condicion $ y = (y:) . zipWithIf funcion condicion (x:xs) $ (ys)
    | otherwise           = (funcion x y :) . zipWithIf funcion condicion (xs) $ (ys)

--Punto 2
--Falopeadas