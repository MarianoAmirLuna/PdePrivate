data Pizza = Pizza{
    ingredientes :: [Ingrediente],
    tamanio :: Int,
    calorias :: Int
}deriving (Show, Eq)

type Ingrediente = String

{-
4  Porciones = individual
6  Porciones = chica
8  Porciones = grande
10 Porciones = gigante
-}

modificarCalorias :: (Int -> Int) -> Pizza -> Pizza
modificarCalorias funcion unaPizza = unaPizza{calorias = funcion . calorias $ unaPizza}

modificarIngrediente :: ([Ingrediente] -> [Ingrediente]) -> Pizza -> Pizza
modificarIngrediente funcion unaPizza = unaPizza{ingredientes = funcion . ingredientes $ unaPizza}

tieneIngrediente :: String -> Pizza -> Bool
tieneIngrediente ingrediente = elem ingrediente . ingredientes 

caloriasDeIngrediente :: Ingrediente -> Int
caloriasDeIngrediente = (2*) . length

menosCaloriasQue :: Int -> Pizza -> Bool
menosCaloriasQue caloriasMaximas = (caloriasMaximas >) . calorias 

cantidadDeIngredientes :: Pizza -> Int
cantidadDeIngredientes = length . ingredientes

modificarPorciones :: (Int -> Int) -> Pizza -> Pizza
modificarPorciones funcion unaPizza
    | tamanio unaPizza == 10 = unaPizza
    | otherwise              = unaPizza{tamanio = funcion . tamanio $ unaPizza}

--Punto 1
grandeDeMuzza :: Pizza
grandeDeMuzza = Pizza ["salsa", "mozzarella", "oregano"] 8 350

-- Punto 2
satisfaccion :: Pizza -> Int
satisfaccion unaPizza
    | tieneIngrediente "palmito" unaPizza   = 0
    | menosCaloriasQue 500 unaPizza         = nivelDeSatisfaccion unaPizza
    | otherwise                             = (flip div 2) . nivelDeSatisfaccion $ unaPizza

nivelDeSatisfaccion :: Pizza -> Int
nivelDeSatisfaccion = (80*) . cantidadDeIngredientes

-- Punto 3
valorPizza :: Pizza -> Int
valorPizza unaPizza = 120 * tamanio unaPizza * cantidadDeIngredientes unaPizza

--Punto 4
nuevoIngrediente :: Ingrediente -> Pizza -> Pizza
nuevoIngrediente unIngrediente = modificarCalorias (+caloriasDeIngrediente unIngrediente) . modificarIngrediente (unIngrediente :)

agrandar :: Pizza -> Pizza
agrandar = modificarPorciones (2+)

mezcladita :: Pizza -> Pizza -> Pizza
mezcladita unaPizza otraPizza = modificarCalorias (+mitadDeCalorias unaPizza) . mixDeIngredientes unaPizza $ otraPizza

mixDeIngredientes :: Pizza -> Pizza -> Pizza
mixDeIngredientes unaPizza otraPizza = flip modificarIngrediente otraPizza . ( ++) $ ingredientesAdicionales unaPizza otraPizza

ingredientesAdicionales :: Pizza -> Pizza -> [Ingrediente]
ingredientesAdicionales unaPizza otraPizza = filter (not . ingredienteEn otraPizza) $ ingredientes unaPizza

ingredienteEn :: Pizza -> Ingrediente -> Bool
ingredienteEn unaPizza unIngrediente = elem unIngrediente . ingredientes $ unaPizza

mitadDeCalorias :: Pizza -> Int
mitadDeCalorias = flip div 2 . calorias

--Punto 5
type Pedido = [Pizza]
satisfaccionPedido :: Pedido -> Int
satisfaccionPedido = sum . map satisfaccion

--Punto 6
type Pizeria = Pizza -> Pizza
pizzeriaLosHijoDePato :: Pizeria
pizzeriaLosHijoDePato = modificarIngrediente ("palmito":)

pizzeriaElResumen :: Pedido -> Pedido
pizzeriaElResumen (x:[]) = [x]
pizzeriaElResumen unPedido = zipWith (mezcladita) unPedido . drop 1 $ unPedido

pizzeriaEspecial :: Pizza -> Pizeria
pizzeriaEspecial saborPredilecto unaPiza = mezcladita saborPredilecto unaPiza

anchoasBasica :: Pizza
anchoasBasica = Pizza ["salsa", "anchoas"] 8 10

pizzeriaPesacadito :: Pizeria
pizzeriaPesacadito = pizzeriaEspecial anchoasBasica

pizzeriaGourmet :: Int -> Pedido -> Pedido
pizzeriaGourmet exquisitez = map agrandar . filter (esExquisita exquisitez)

esExquisita :: Int -> Pizza -> Bool
esExquisita exquisitez = (exquisitez <=) . satisfaccion

pizeriaLaJauja :: Pedido -> Pedido
pizeriaLaJauja = pizzeriaGourmet 399

--Punto 7
sonDignasDeCalleCorrientes :: Pedido -> [Pizeria] -> [Pizeria]
sonDignasDeCalleCorrientes unPedido pizerias = filter (mejoraSatisfaccion unPedido) pizerias

mejoraSatisfaccion :: Pedido -> Pizeria -> Bool
mejoraSatisfaccion unPedido unaPizeria = (>satisfaccionPedido unPedido) . satisfaccionPedido . map unaPizeria $ unPedido

--Punto 9
laPizeriaPredilecta :: [Pizeria] -> Pizeria
laPizeriaPredilecta pizerias = flip (foldr ($)) pizerias