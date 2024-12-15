esMultiploDeTres :: Int -> Bool
esMultiploDeTres x = ((mod x 3) == 0)

esMultiploDe :: Int -> Int -> Bool
esMultiploDe z y = ((mod y z) == 0)

cubo :: Num a => a -> a
cubo nro = (nro * nro * nro)

esBisiesto :: Int -> Bool
esBisiesto anio = (((mod anio 400) == 0) || ( ((mod anio 4) == 0) && ((mod anio 100) /= 0) )  )

celsiusToFahr:: Float -> Float
celsiusToFahr x = (9/5 * x) + 32

mcm:: Int -> Int -> Int
mcm a b = ( gcd a b )

dispersion x y z = (max (max x y) z) -  (min (min x y) z)
diasParejos x y z = (dispersion x y z) < 30
diasLocos x y z = (dispersion x y z) > 100
diasNormales x y z = (dispersion x y z) > 30 && (dispersion x y z) < 100

-- ej 1
siguiente :: Num a => a -> a
siguiente x = 1+x

-- ej 3
inversa :: Fractional a => a -> a
inversa x = 1/x

-- ej 7
esBisiestO :: Int -> Bool
esBisiestO x = (( esMultiploDe  400 x )  || ( esMultiploDe 4 x   && not ( esMultiploDe 100 x ) ))

-- ej 8
inversaRaizCuadrada :: Float -> Float
inversaRaizCuadrada x = (inversa . sqrt) $ x

--ej 9
incrementMCuadradoN m n = (n^2 + ) $ m

--ej 10
esResultadoPar :: Int -> Int -> Bool
esResultadoPar a b = (even . (^b)) $ a