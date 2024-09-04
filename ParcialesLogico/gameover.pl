% 1:
juego(marioBros, aventura(rescatarAPrincesa)).
juego(sonic, aventura(rescatarAnimales)).
juego(tetris, ingenio(200)).
juego(bomberman, ingenio(100)).
juego(bomberman, accion(cuadrilatero, 8)).

juegosMismoGenero(Juego1, Juego2):-
    juego(Juego1, GeneroFunctor1),
    juego(Juego2, GeneroFunctor2),
    genero(Genero, GeneroFunctor1),
    genero(Genero, GeneroFunctor2).


genero(aventura, aventura(_)).
genero(ingenio, ingenio(_)).
genero(accion, accion(_, _)).

generoDificil(aventura(_)).
generoDificil(ingenio(Nivel)):-
    Nivel > 100.

generoDificil(accion(_, Jugadores)):-
    betwenn(4, 8, Jugadores).

juegoDificil(Juego):-
    juego(Juego, _),
    forall(juego(Juego, Genero), generoDificil(Genero)).

juegosPopulares(Juego):-
    juego(Juego, _),
    not(juegoDificil(Juego)).

generoAExpandir(Genero):-
    juegosPorGenero(Genero, Cantidad),
    forall(juegosPorGenero(OtroGenero, OtraCantidad), Cantidad <= OtraCantidad).

juegosPorGenero(Genero, Cantidad):-
    juego(_, Genero),
    findall( Juego, juego(Juego, Genero), CantidadDeJuegos),
    length(CantidadDeJuegos, Cantidad).

personajeSecundarios(sonic, [tails, knuckles]).
personajeSecundarios(marioBros, [luigi, bowser, peach]).
personajeSecundarios(bomberman, [bombermanNegro, regulus, altair, pommy, orion]).

superMultijugador(Juego):-
    cantidadDePersonajes(Juego, Cantidad),
    forall(cantidadDePersonajes(OtroJuego, OtraCantidad), OtraCantidad <= Cantidad).
    
cantidadDePersonajes(Juego, Cantidad):-
    personajeSecundarios(Juego, Companieros),
    length(Companieros, CantidadMenosProta),
    Cantidad is CantidadMenosProta +1.

sucesor(marioBros, superMario).
sucesor(superMario, marioNintendo64).
sucesor(marioNintendo64, superMarioGalaxy).

esSaga(Juego1, Juego2):-
    sucesor(Juego2, Juego1).

esSaga(Juego1, Juego2):-
    sucesor(Juego1, Juego3),
    esSaga(Juego3, Juego2).