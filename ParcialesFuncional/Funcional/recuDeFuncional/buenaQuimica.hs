data Producto = Producto{
    peligrosidad :: Int,
    componentes  :: [String],
    descripcion  :: String
} deriving (Eq, Show)

-- EJEMPLOS --
nafta               :: Producto
nafta = Producto 7 ["Petroleo", "Etanol"] ""

bolitasDeNaftalina  :: Producto
bolitasDeNaftalina = Producto 10 ["Petroleo", "Etanol", "Sustancia blanca"] ""

paradigmetileno     :: Producto
paradigmetileno = Producto 2 ["funcionol", "Logicol", "objetol"] ""

escalonetina        :: Producto
escalonetina = Producto 99 ["dibumartineico", "dimariol", "depaultinina"] ""

--Punto 1
tienenBuenaQuimica :: Producto -> Producto -> Bool
tienenBuenaQuimica unProducto otroProducto = compartenComponetes (componentes unProducto) (componentes otroProducto) && descripcionIncluida unProducto otroProducto

compartenComponetes :: [String] -> [String] -> Bool
compartenComponetes [] _ = False
compartenComponetes (x:xs) otroProducto
    | (not . any (== x)) otroProducto = compartenComponetes (xs) otroProducto
    | otherwise                       = any (== x) otroProducto

descripcionIncluida :: Producto -> Producto -> Bool
descripcionIncluida unProducto otroProducto = (descripcion unProducto) == (descripcion otroProducto)

-- SENSORES --
type Sensor = Producto -> Bool
contiene :: String -> [String] -> Bool
contiene unString listaDeStrings = elem unString listaDeStrings

esIlegal :: [String] -> Sensor
esIlegal listadoProhibido unProducto = contiene (descripcion unProducto) listadoProhibido

contienePetroleo :: Sensor
contienePetroleo unProducto = contiene "Petroleo" (componentes unProducto)

peligrosidadAdecuada :: Int -> Sensor
peligrosidadAdecuada maximoPermitido = (maximoPermitido <) . peligrosidad

antiFuncionol :: Sensor
antiFuncionol = elem "funcionol" . componentes

