%resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais).
resultado(paisesBajos, 3, estadosUnidos, 1).
resultado(australia  , 1, argentina    , 2).
resultado(polonia    , 3, francia      , 1).
resultado(inglaterra , 3, senegal      , 0).

% pronostico(Jugador, Pronostico)
pronostico(juan , gano(paisesBajos   , estadosUnidos, 3, 1)).         % 200 puntos
pronostico(juan , gano(argentina     , australia    , 3, 0)).         % 100 puntos
pronostico(juan , empataron(inglaterra, senegal        , 0)).         % 0   puntos
pronostico(gus  , gano(estadosUnidos , paisesBajos  , 1, 0)).         % 0   puntos
pronostico(gus  , gano(japon         , croacia      , 2, 0)).         % 0   puntos (aun no jugaron)             
pronostico(lucas, gano(paisesBajos   , estadosUnidos, 3, 1)).         % 200 puntos
pronostico(lucas, gano(argentina     , australia    , 2, 0)).         % 100 puntos
pronostico(lucas, gano(croacia       , japon        , 1, 0)).         % 0   puntos (aun no jugaron)

% Esto lo hago para que el predicado resultado sea simétrico
resultadoSimetrico(Pais1, Goles1, Pais2, Goles2) :- resultado(Pais1, Goles1, Pais2, Goles2).
resultadoSimetrico(Pais1, Goles1, Pais2, Goles2) :- resultado(Pais2, Goles2, Pais1, Goles1).

jugaron(UnPais, OtroPais, DiferenciaDeGoles):-
    resultadoSimetrico(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais),
    DiferenciaDeGoles is GolesDeUnPais - GolesDeOtroPais.

gano(UnPais, OtroPais):-
    jugaron(UnPais, OtroPais, DiferenciaDeGoles),
    DiferenciaDeGoles > 0.


% Un pronóstico es un functor de cualquiera de estas formas:
    % gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor).
    % empataron(UnPais, OtroPais, GolesDeCualquieraDeLosDos).
pronosticoValido(gano(UnPais, OtroPais, _  , _)):- jugaron(UnPais, OtroPais, _).
pronosticoValido(empataron(UnPais, OtroPais, _)):- jugaron(UnPais, OtroPais, _).

puntosPronostico(Pronostico, Puntos):-
    pronosticoValido(Pronostico),
    calcularPuntos(Pronostico, Puntos).

calcularPuntos(Pronostico, 200):-
    ganoOempato(Pronostico),
    cantidadDeGolesCorrecta(Pronostico).

calcularPuntos(Pronostico, 100):-
    ganoOempato(Pronostico),
    not(cantidadDeGolesCorrecta(Pronostico)).

calcularPuntos(Pronostico, 0):-
    not(ganoOempato(Pronostico)).

ganoOempato(gano(PaisGanador, PaisPerdedor, _, _)):-    gano(PaisGanador, PaisPerdedor).
ganoOempato(empataron(UnPais, OtroPais, _)):-           esEmpate(UnPais  , OtroPais       ).

cantidadDeGolesCorrecta(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor)):-
    resultadoSimetrico(PaisGanador, GolesGanador, PaisPerdedor, GolesPerdedor).
cantidadDeGolesCorrecta(empataron(UnPais, OtroPais, GolesdDeEmpate)):-
    resultadoSimetrico(UnPais, GolesdDeEmpate, OtroPais, GolesdDeEmpate).

esEmpate(Pais1, Pais2):-
    resultadoSimetrico(Pais1, GolesdDeEmpate, Pais2, GolesdDeEmpate).

invicto(Jugador):-
    pronostico(Jugador, _),
    forall((pronostico(Jugador, Pronostico), puntosPronostico(Pronostico, Puntos)), Puntos >= 100).

puntaje(Jugador, PuntosTotales):-
    pronostico(Jugador, _),
    findall(Puntos, (pronostico(Jugador, Pronostico), puntosPronostico(Pronostico, Puntos)), ListaDePuntos),
    sumlist(ListaDePuntos, PuntosTotales).

favorito(UnPais):-
    pronosticoGanadorOGoleador(UnPais).

pronosticoGanadorOGoleador(UnPais):-
    forall(jugaron(UnPais, _, DiferenciaDeGoles), DiferenciaDeGoles >= 3).

pronosticoGanadorOGoleador(UnPais):-
    forall(paisEnPronostico(UnPais, Pronostico), paisGanadorDelPronostico(UnPais, Pronostico)).

paisGanadorDelPronostico(UnPais, gano(UnPais, _, _, _)).

estaEnElPronostico(Pais, gano(Pais, OtroPais, Goles1, Goles2)) :-
    pronostico(_, gano(Pais, OtroPais, Goles1, Goles2)).
estaEnElPronostico(Pais, gano(OtroPais, Pais, Goles1, Goles2)) :-
    pronostico(_, gano(OtroPais, Pais, Goles1, Goles2)).
estaEnElPronostico(Pais, empataron(Pais, OtroPais, Goles)) :-
    pronostico(_, empataron(Pais, OtroPais, Goles)).
estaEnElPronostico(Pais, empataron(OtroPais, Pais, Goles)) :-
    pronostico(_, empataron(OtroPais, Pais, Goles)).