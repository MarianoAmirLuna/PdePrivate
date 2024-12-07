esJuego(Nombre, accion()).
esJuego(Nombre, rol(UsuariosActivos)).
esJuego(Nombre, puzzle(Niveles, Dificultad)).

genero(Juego, accion):- esJuego(Juego, accion()     ).
genero(Juego, rol   ):- esJuego(Juego, rol(_)       ).
genero(Juego, puzzle):- esJuego(Juego, puzzle(_, _) ).

precio(Juego, Precio).
oferta(Juego, Porcentaje).

cuantoSale(Juego, PrecioFinal):-
    precio(Juego, PrecioOriginal        ),
    oferta(Juego, PorcentajeDescuento   ),
    PrecioFinal is (PrecioOriginal - PrecioOriginal * PorcentajeDescuento).

cuantoSale(Juego, PrecioFinal):-
    precio(Juego, PrecioFinal),
    not(oferta(Juego, _)).

tieneBuenDescuento(Juego):-
    oferta(Juego, Porcentaje),
    Porcentaje >= 0.5.

esPopular(Juego):-  esJuego(Juego, accion(              )).
esPopular(Juego):-  esJuego(Juego, rol(UsuariosActivos  )), UsuariosActivos > 1000000.
esPopular(Juego):-  esJuego(Juego, puzzle(25, _         )).
esPopular(Juego):-  esJuego(Juego, puzzle(_ , facil     )).
esPopular(minecraft    ).
esPopular(counterStrike).

esUsuario(Nombre                                    ):- usuarioPosee(Nombre, _).
usuarioPosee(Nombre, UnJuegoEnBibloteca             ).
usuarioPiensaPoseer(Nombre, comprar(Receptor, Juego)).
piensaComprarse(Comprador, Juego                    ):- usuarioPiensaPoseer(Comprador, comprar(Comprador, Juego)).

adictoALosDescuentos(Comprador):-
    esUsuario(Nombre),
    forall(piensaComprarse(Comprador, Juego), tieneBuenDescuento(Juego)).

fanatico(Jugador, Genero):-
    usuarioPosee(Jugador, UnJuego1),
    usuarioPosee(Jugador, UnJuego2),
    esJuego(UnJuego1    , Genero  ),
    esJuego(UnJuego2    , Genero  ),
    UnJuego1 \= UnJuego2           .

monotematico(Jugador):-
    usuarioPosee(Jugador, UnJuego   ),
    genero(UnJuego      , GeneroBase),
    forall((usuarioPosee(Jugador, OtroJuego), genero(OtroJuego, Genero), OtroJuego \= UnJuego), Genero = GeneroBase).

buenosAmigos(UnJugador, OtroJugador):-
    regalarJuegoPopular(UnJugador   , OtroJugador),
    regalarJuegoPopular(OtroJugador , UnJugador  ).

regalarJuegoPopular(Comprador, Receptor):-
    usuarioPiensaPoseer(Comprador, comprar(Receptor, UnJuego)),
    esPopular(UnJuego).

cuantoGastara(UnJugador, CantidadDePlata):-
    esUsuario(Nombre),
    findall(PrecioFinal, (usuarioPiensaPoseer(UnJugador, comprar(_, Juego)), cuantoSale(Juego, PrecioFinal)), ListasDePrecios),
    sumlist(ListasDePrecios, CantidadDePlata).