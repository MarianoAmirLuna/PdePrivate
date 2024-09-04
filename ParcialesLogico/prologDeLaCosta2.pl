comida(hamburguesa, 2000).
comida(panchitosConPapas, 1500).
comida(lomito, 2500).

atraccion(autosChocones, tranquila(ambos)).
atraccion(casaEmbrujada, tranquila(ambos)).
atraccion(laberinto, tranquila(ambos)).
atraccion(tobogan, tranquila(chicos)).
atraccion(calesita, tranquila(chicos)).

atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador3D, intensa(2)).

atraccion(amr, montaniaRusa(3, 134)).
atraccion(paseoPorElBosque, montaniaRusa(0, 45)).

atraccion(torpedoSalpicon, acuatica()).
atraccion(eqhtumr, acuatica()).

visitante(eusebio, 80, 3000, grupo(viejitos)).
visitante(carmela, 80, 0, grupo(viejitos)).
visitante(abigail, 20, 1500, grupo()).
visitante(sebastian, 21, 3000, grupo()).

emocion(abigail, 15, 5).
emocion(sebastian, 20, 0).
emocion(eusebio, 50, 0).
emocion(carmela, 0, 25).

bienestar(Visitante, Sensacion):-
    emocion(Visitante, Hambre, Aburrimiento),
    sumaDeEmociones(Hambre, Aburrimiento, Sensacion, Grupo).

sumaDeEmociones(0, 0, felicidadPlena, Visitante):-
    not(visitante(Visitante, _, _, grupo())).

sumaDeEmociones(Hambre, Aburrimiento, podriaEstarMejor, _):-
    between(1, 50, Hambre + Aburrimiento).

sumaDeEmociones(0, 0, podriaEstarMejor, Visitante):-
    visitante(Visitante, _, _, grupo()).

sumaDeEmociones(Hambre, Aburrimiento, necesitaEntretenerse, _):-
    between(51, 99, Hambre + Aburrimiento).
    
sumaDeEmociones(Hambre, Aburrimiento, seQuiereIrACasa, _):-
    100 >= Hambre + Aburrimiento.

satisfacerHambre(Grupo, Comida):-
    puedeSatisfacer(Grupo, Comida).

puedeSatisfacer(Grupo, Comida):-
    comida(Comida, Precio),
    esGrupo(Grupo),
    forall(visitante(Visitante, _, _, Grupo), (puedePagar(Visitante, Precio), satisface(Visitante, Comida))).

puedePagar(Persona, Precio):-
    visitante(Persona, _, Plata, _),
    Plata >= Precio.
    
satisface(Visitante, hamburguesa):-
    emocion(Visitante, Hambre, _),
    Hambre < 50.

satisface(Visitante, panchitosConPapas):-
    esMenor(Visitante).

satisface(Visitante, lomito).

satisface(Visitante, caramelos):-
    comida(Comida, Precio),
    Comida \= caramelos,
    not(puedePagar(Visitante, Precio)).

esMenor(Visitante):-
    visitante(Visitante, Edad, _, _),
    Edad < 13.

esGrupo(Grupo):-
    visitante(_, _, _, Grupo).

lluviaDeHamburguesa(Visitante):-
    comida(hamburguesa, Precio),
    puedePagar(Visitante, Precio),
    atraccionHeavy(Visitante, Atraccion).

atraccionHeavy(Visitante, Atraccion):-
    atraccion(Atraccion, intensa(CL)),
    CL > 10.

atraccionHeavy(Visitante, tobogan).
atraccionHeavy(Visitante, Atraccion):-
    esAtraccionPeligrosa(Atraccion, Visitante).

esAtraccionPeligrosa(Atraccion, Visitante):-
    montaniaGirona(Atraccion),
    esVisitante(Visitante),
    not(bienestar(Visitante, necesitaEntretenerse)),
    not(esMenor(Visitante)).

esAtraccionPeligrosa(Atraccion, Visitante):-
    esMenor(Visitante),
    montaniaDuradera(Atraccion).
    
montaniaDuradera(Atraccion):-
    atraccion(Atraccion, montaniaRusa(_, Tiempo)),
    60 <= Tiempo.

montaniaGirona(Atraccion):-
    atraccion(Atraccion, montaniaRusa(Giros, _)),
    forall(atraccion(OtraAtraccion, montaniaRusa(UnosGiros, _)), UnosGiros <= Giros).

esVisitante(Visitante):-
    visitante(Visitante, _, _, _).


