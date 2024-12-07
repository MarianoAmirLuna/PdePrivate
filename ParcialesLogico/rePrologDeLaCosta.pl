%visitante(Nombre    , Edad  , Dinero      ).
%grupoFamiliar(Nombre, Grupo               ).
%sentimiento(Nombre  , Hambre, Aburrimiento).

visitante(eusebio    , 80, 3000  ).
grupoFamiliar(eusebio, viejitos  ).
sentimiento(eusebio  , hambre(50)).

visitante(carmela    , 80, 0           ).
grupoFamiliar(carmela, viejitos        ).
sentimiento(carmela  , aburrimiento(25)).

esChico(Visitante):-
    visitante(Visitante, Edad, _),
    Edad < 13.

atraccion(autosChocones, tranquila(chicosYadultos)).
atraccion(casaEmbrujada, tranquila(chicosYadultos)).
atraccion(laberinto    , tranquila(chicosYadultos)).
atraccion(tobogan      , tranquila(chicos)).
atraccion(calesita     , tranquila(chicos)).

atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6) ).
atraccion(simulador3D, intensa(2) ).

atraccion(abismoMortalRecargada, montaniaRusa(3, 134)).
atraccion(paseoPorElBosque     , montaniaRusa(0, 45) ).

atraccion(torpedoSalpicon, acuatica()).
atraccion(eqhtumr        , acuatica()).

totalDeSentimiento(Visitante, Total):-
    sentimiento(Nombre  , Hambre, Aburrimiento),
    Total is Hambre + Aburrimiento.

sentimientosEntre(Visitante, Min, Max):-
    totalDeSentimiento(Visitante, Total),
    between(Min, Max, Total).

bienestar(Visitante, felicidad):-
    totalDeSentimiento(Visitante, 0),
    not(grupoFamiliar(Visitante, _)).

bienestar(Visitante, podriaEstarMejor):-
    sentimientosEntre(Visitante, 1, 50).

bienestar(Visitante, podriaEstarMejor):-
    totalDeSentimiento(Visitante, 0),
    grupoFamiliar(Visitante, _).

bienestar(Visitante, necesitaEntretenerse):-
    sentimientosEntre(Visitante, 51, 99).

bienestar(Visitante, seQuiereIrACasa):-
    totalDeSentimiento(Visitante, Total),
    Total >= 100.

precioComida(hamburguesa , 2000).
precioComida(panchoYpapas, 1500).
precioComida(lomito      , 2500).
precioComida(caramelos   ,    0).

comidaMasBarata(PrecioFinal):-
    precioComida(Comida , PrecioFinal),
    forall(precioComida(OtraComida , Precio), PrecioFinal <= Precio).

satisface(hamburguesa , Persona):- sentimiento(Persona, Hambre, _), Hambre < 50.
satisface(panchoYpapas, Persona):- esChico(Persona).
satisface(lomito      , Persona):- visitante(Persona, _, _).
satisface(caramelos   , Persona):- visitante(Persona, _, Dinero), comidaMasBarata(Precio), Dinero < Precio.

comer(Persona, Comida):-
    satisface(Comida   , Persona  ),
    precioComida(Comida, Precio   ),
    visitante(Persona  , _, Dinero),
    Dinero >= Precio.

leQuitanHambreATodos(Grupo, Comida):-
    forall(grupoFamiliar(Persona, Grupo), comer(Comida, Persona)).

atraccionVomitona(_, tobogan).
atraccionVomitona(Visitante, Atraccion):-   atraccion(Atraccion, intensa(CL)), CL > 10.
atraccionVomitona(Visitante, Atraccion):-   montaniaRusaPeligrosa(Visitante, Atraccion).

montaniaRusaPeligrosa(Visitante, Atraccion):-
    atraccion(Atraccion, montaniaRusa(MayorCantGiros, _)),
    not(esChico(Visitante)),
    not(bienestar(Visitante, necesitaEntretenerse)),
    forall(atraccion(OtraAtraccion, montaniaRusa(Giros, _)), Giros <= MayorCantGiros).

montaniaRusaPeligrosa(Visitante, Atraccion):-
    esChico(Visitante),
    atraccion(Atraccion, montaniaRusa(_, Duracion)),
    Duracion > 60.

lluviaDeHambuerguesa(Visitante, Atraccion):-
    comer(Visitante, hamburguesa),
    atraccionVomitona(Visitante, Atraccion).

