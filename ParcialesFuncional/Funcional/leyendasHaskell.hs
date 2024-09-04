{-
De cada investigador conocemos su nombre, su experiencia en investigaciones, su Pokemon compañero, su mochila y una serie de Pokemons capturados. 
-}
data Investigador = Investigador{
    nombreInvestigador :: String,
    experiencia :: Float,
    companieropkmn :: [Pokemon],
    mochila :: [Objeto],
    capturas :: [Pokemon]
}

data Pokemon = Pokemon{
    mote :: String,
    informacion :: String,
    nivel :: Int,
    ptosInvestigacion :: Float
}deriving(Show)

type ModificarPokemon = Pokemon -> Pokemon 
type Actividad = Investigador -> Investigador
type ModificarInvestigador = Actividad
type Objeto = Actividad

-- ====================================================================================

esRangoCielo :: Investigador -> Bool
esRangoCielo unInvestigador = 100 > experiencia unInvestigador

esRangoEstrella :: Investigador -> Bool
esRangoEstrella unInvestigador = 100 <= experiencia unInvestigador

esRangoConstelacion :: Investigador -> Bool
esRangoConstelacion unInvestigador = 500 <= experiencia unInvestigador

esRangoGalaxia :: Investigador -> Bool
esRangoGalaxia unInvestigador = 2000 <= experiencia unInvestigador

-- ====================================================================================

reemplazarPtosInves :: Float -> ModificarPokemon
reemplazarPtosInves valor unPkmn = unPkmn{ptosInvestigacion = valor}

modificarPtosInves:: (Float -> Float) -> ModificarPokemon
modificarPtosInves funcionParcial unPkmn = unPkmn{ptosInvestigacion = funcionParcial $ (ptosInvestigacion unPkmn)}

reemplazarExperiencia :: Float -> ModificarInvestigador
reemplazarExperiencia   valor           unInvestigador = unInvestigador{experiencia = valor}

modificarExperiencia :: (Float -> Float) -> ModificarInvestigador
modificarExperiencia    funcionParcial  unInvestigador = unInvestigador{experiencia = funcionParcial $ experiencia unInvestigador}

modificarPorcentajeDeExperiencia :: Float -> (Float -> Float -> Float) -> ModificarInvestigador
modificarPorcentajeDeExperiencia   valor    funcion unInvestigador = unInvestigador{experiencia = funcion (experiencia unInvestigador) ((valor/100) * experiencia unInvestigador)}

agregarItemAMochila :: Objeto -> ModificarInvestigador
agregarItemAMochila unItem unInvestigador = unInvestigador{mochila= unItem : mochila unInvestigador}

quitarItemAMochila :: Objeto -> ModificarInvestigador
quitarItemAMochila unItem unInvestigador = unInvestigador{mochila= tail $ mochila unInvestigador}

quitarNElementosAMochila :: Int -> ModificarInvestigador
quitarNElementosAMochila elementosAQuitar unInvestigador = unInvestigador{mochila= drop elementosAQuitar (mochila unInvestigador)}

agregarCompaniero :: Pokemon -> ModificarInvestigador
agregarCompaniero futuroComaniero unInvestigador = unInvestigador{companieropkmn = futuroComaniero : companieropkmn unInvestigador}

agregarAlEquipo :: Pokemon -> ModificarInvestigador
agregarAlEquipo unPKMN unInvestigador = unInvestigador{capturas = unPKMN : capturas unInvestigador}

pokemonAlfa :: ModificarPokemon
pokemonAlfa unAlfa = modificarPtosInves (2*) unAlfa

esAlfa :: Pokemon -> Bool
esAlfa unPKMN = ("Alfa" == ). take 4 $ mote unPKMN

--Ej1 
akari :: Investigador
akari = Investigador{
    nombreInvestigador = "Akari",
    experiencia = 1499,
    companieropkmn = [oshawott],
    mochila = [],
    capturas = []
}

oshawott :: Pokemon
oshawott = Pokemon{
    mote = "Oshawott",
    informacion = "una nutria que pelea con el caparazón de su pecho",
    nivel = 5,
    ptosInvestigacion = 3
}

-- Ej2

queRangoEs :: Investigador -> String
queRangoEs unInvestigador
    | esRangoCielo          unInvestigador = "Rango Cielo"
    | esRangoConstelacion   unInvestigador = "Rango Constelacion"
    | esRangoEstrella       unInvestigador = "Rango Estrella"
    | otherwise = "Rango Galaxia"

-- Ej3

-- %%%%%%% Items %%%%%%
bayas :: Objeto
bayas unInvestigador = modificarExperiencia ((** 2.0).(+1) $ ) unInvestigador

apricorns :: Objeto
apricorns unInvestigador = modificarExperiencia (*1.5) unInvestigador

guijarros :: Objeto
guijarros unInvestigador = modificarExperiencia (*2) unInvestigador

fragmentosDeHierro :: Float -> Objeto
fragmentosDeHierro cantidadDeFragmentos unInvestigador = modificarExperiencia (flip (/) cantidadDeFragmentos) unInvestigador

-- %%% Actividades %%% --

obtenerUnItem :: Objeto -> Actividad
obtenerUnItem unObjeto unInvestigador = unObjeto.agregarItemAMochila unObjeto $ unInvestigador

admirarElPaisaje :: Actividad
admirarElPaisaje unInvestigador = quitarNElementosAMochila 3 . modificarPorcentajeDeExperiencia 5 (-) $ unInvestigador

capturarPokemon :: Pokemon -> Actividad
capturarPokemon unPokemon unInvestigador
    | ptosInvestigacion unPokemon > 20.0 = modificarExperiencia (ptosInvestigacion unPokemon +) . agregarCompaniero unPokemon $ unInvestigador
    | otherwise = modificarExperiencia (ptosInvestigacion unPokemon +) . agregarAlEquipo unPokemon $ unInvestigador

combatirPokemon :: Pokemon -> Actividad
combatirPokemon unPokemon unInvestigador
    |   elInvestigadorGana unInvestigador unPokemon = modificarExperiencia (+ 0.5* ptosInvestigacion unPokemon) unInvestigador
    |   otherwise = unInvestigador

elInvestigadorGana :: Investigador -> Pokemon -> Bool
elInvestigadorGana unInvestigador unPKMN = any (> nivel unPKMN ). map nivel $ companieropkmn unInvestigador

-- Ej4

type Expedicion = [Actividad]


realizarExpedicion :: Expedicion -> [Investigador] ->  [Investigador]
realizarExpedicion laExpedicion unGrupo = map (haceExpedicion laExpedicion) unGrupo

haceExpedicion :: Expedicion -> ModificarInvestigador
haceExpedicion [] unPibe = unPibe
haceExpedicion (x:xs) unPibe = haceExpedicion (xs) (x unPibe)

-- %%% Reportes %%% --
type Exploradores = Expedicion -> [Investigador]

reporte :: Exploradores -> (Investigador -> Bool) -> (Investigador -> a) -> [a]
reporte unaExpedicion unosInvestigadores laCondicion laConsecuencia = map laConsecuencia . filter laCondicion . realizarExpedicion unaExpedicion $ unosInvestigadores

investigadoresAlfa :: Exploradores -> [String]
investigadoresAlfa unaExpedicion unosInvestigadores = reporte unaExpedicion unosInvestigadores condicionDeInvestAlfa nombreInvestigador

investigadoresGalacticos :: Exploradores -> [Float]
investigadoresGalacticos unaExpedicion unosInvestigadores = reporte unaExpedicion unosInvestigadores esRangoGalaxia experiencia

companierosAfterExpedicion :: Exploradores -> [[Pokemon]]
companierosAfterExpedicion unaExpedicion unosInvestigadores = reporte unaExpedicion unosInvestigadores companierosBebes companierosParaReportar

ultimos3PokemonesPares :: Exploradores -> [[Pokemon]]
ultimos3PokemonesPares unaExpedicion unosInvestigadores = reporte unaExpedicion unosInvestigadores hayNivelesPares ultimosTresPokemones

{-
pantallazo de las funciones

investigadoresAlfa :: Expedicion -> [Investigador] -> [String]
investigadoresAlfa unaExpedicion unosInvestigadores = map nombreInvestigador . filter condicionDeInvestAlfa . realizarExpedicion unaExpedicion $ unosInvestigadores

investigadoresGalacticos :: Expedicion -> [Investigador] -> [Float]
investigadoresGalacticos unaExpedicion unosInvestigadores = map experiencia . filter esRangoGalaxia . realizarExpedicion unaExpedicion $ unosInvestigadores

companierosAfterExpedicion :: Expedicion -> [Investigador] -> [[Pokemon]]
companierosAfterExpedicion unaExpedicion unosInvestigadores = map companierosParaReportar . filter companierosBebes . realizarExpedicion unaExpedicion $ unosInvestigadores

ultimos3PokemonesPares :: Expedicion -> [Investigador] -> [[Pokemon]]
ultimos3PokemonesPares unaExpedicion unosInvestigadores = map ultimosTresPokemones . filter hayNivelesPares . realizarExpedicion unaExpedicion $ unosInvestigadores
-}

-- %%% Condiciones para reportes %%% --

condicionDeInvestAlfa :: Investigador -> Bool
condicionDeInvestAlfa unInvestigador = (3 < ).length.filter esAlfa $ companieropkmn unInvestigador

companierosBebes :: Investigador -> Bool
companierosBebes unInvestigador = any (10<= ) . map nivel $ companieropkmn unInvestigador

hayNivelesPares :: Investigador -> Bool
hayNivelesPares unInvestigador = any even. map nivel $ capturas unInvestigador

-- %%% Consecuencias de las condiciones %%% --

companierosParaReportar :: Investigador -> [Pokemon]
companierosParaReportar unInvestigador = filter ((10<=).nivel) $ companieropkmn unInvestigador

ultimosTresPokemones :: Investigador -> [Pokemon]
ultimosTresPokemones unInvestigador = take 3 . reverse $ capturas unInvestigador

{- Ej5
    Se podria hacer solo el reporte "investigadoresGalacticos" ya que no depende de la cantidad de pokemones del investigador. El resto 
    de reportes podrian dar un resultado si no fuera porque la funcion filter evalua infinitamente, es decir no converge a un resultado.
-}