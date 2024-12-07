comida(hamburguesa, 2000).
comida(panchito   , 1500).
comida(lomito     , 2500).
comida(caramelos  ,    0).

atraccion(autitosChocones , todaLaFamilia(chicosYadultos)).
atraccion(casaEmbrujada   , todaLaFamilia(chicosYadultos)).
atraccion(laberinto       , todaLaFamilia(chicosYadultos)).
atraccion(tobogan         , todaLaFamilia(chicos)).
atraccion(calesita        , todaLaFamilia(chicos)).
atraccion(barcoPirata     , intensa(14)).
atraccion(tazasChinas     , intensa(6 )).
atraccion(simulador3D     , intensa(2 )).
atraccion(abismoMortal    , montaniaRusa(3, 134)).
atraccion(paseoPorElBosque, montaniaRusa(0, 45)).
atraccion(torpedoSalpicon, acuatico()).

%visitante(Visitante, Edad, Dinero).
visitante(eusebio, 80, 3000).
visitante(carmela, 80,    0).
visitante(ernesto, 18, 3000).

%animo(Visitante, Hambre, Aburrimiento).
animo(eusebio, 50,  0).
animo(carmela,  0, 25).
animo(ernesto,  60, 25).

%grupo(Visitante, Grupo).
grupo(eusebio, viejitos).
grupo(carmela, viejitos).
grupo(ernesto, adolecente).

esMenor(V):-        visitante(V, Edad, _), Edad < 13.
esVisitante(V):-    visitante(V, _, _). 

%%% 2 %%%
bienestar(Visitante, felicidadPlena      ):-  sumaDeAnimos(Visitante, 0), grupo(Visitante, _).
bienestar(Visitante, podriaEstarMejor    ):-  sumaDeAnimos(Visitante, Animo), between(1, 50, Animo).
bienestar(Visitante, podriaEstarMejor    ):-  sumaDeAnimos(Visitante, 0), not(grupo(Visitante, _)).
bienestar(Visitante, necesitaEntretenerse):-  sumaDeAnimos(Visitante, Animo), between(51, 99, Animo).
bienestar(Visitante, seQuiereIrACasa     ):-  sumaDeAnimos(Visitante, Animo), Animo >= 100.

sumaDeAnimos(Visitante, Animo):-
    animo(Visitante, Hambre, Aburrimiento),
    Animo is Hambre + Aburrimiento.

%%% 3 %%%
puedeSatisfacerHambre(UnGrupo, Comida):-
    comida(Comida, _),    grupo(_, UnGrupo),
    forall(grupo(Visitante, UnGrupo), puedeComer(Visitante, Comida)).

puedeComer(Visitante, Comida):-
    visitante(Visitante, _, Dinero),
    comida(Comida, Precio),
    satisface(Comida, Visitante),
    Dinero >= Precio.


satisface(lomito     , _).
satisface(hamburguesa, Visitante):- visitante(Visitante, Hambre, _), Hambre < 50.
satisface(panchito   , Visitante):- esMenor(Visitante).
satisface(caramelos  , Visitante):-
    visitante(Visitante, _, Dinero),
    forall((comida(_, Precio), Precio \= 0), Dinero < Precio).

%%% 4 %%%
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