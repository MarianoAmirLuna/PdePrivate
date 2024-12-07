% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).
% … y muchos más también

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai   , 199)).
tiene(aleP, unidad(espadachin, 10 )).
tiene(aleP, unidad(granjero  , 10 )).
tiene(aleP, recurso(800, 300, 100 )). %%recurso(Madera, Alimento, Oro)
tiene(aleP, edificio(casa    , 40 )).
tiene(aleP, edificio(castillo, 1  )).
tiene(juan, unidad(carreta   , 10 )).
% … y muchos más también

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(alabardero, costo(25, 35, 0 ), piquero   ).
militar(espadachin, costo(0 , 60, 20), infanteria).
militar(arquero   , costo(25, 0 , 45), arqueria  ).
militar(mangudai  , costo(55, 0 , 65), caballeria).
militar(samurai   , costo(0 , 60, 30), unica     ).
militar(keshik    , costo(0 , 80, 50), unica     ).
militar(tarcanos  , costo(0 , 60, 60), unica     ).
% … y muchos más tipos pertenecientes a estas categorías.

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador   , produce(23, 0, 0)).
aldeano(granjero  , produce(0, 32, 0)).
aldeano(minero    , produce(0, 0, 23)).
aldeano(cazador   , produce(0, 25, 0)).
aldeano(pescador  , produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).
% … y muchos más también

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa    , costo(30 , 0 , 0  )).
edificio(granja  , costo(0  , 60, 0  )).
edificio(herreria, costo(175, 0 , 0  )).
edificio(castillo, costo(650, 0 , 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).
% … y muchos más también

%   PUNTO 1   %
esUnAfano(Jugador1, Jugador2):-
    jugador(Jugador1, Rating1, _),
    jugador(Jugador2, Rating2, _),
    (Rating1 - Rating2) > 500.

%   PUNTO 2   %
esEfectivo(Unidad1, Unidad2):-
    militar(Unidad1, _, Categoria1),
    militar(Unidad2, _, Categoria2),
    leGana(Categoria1, Categoria2).

leGana(caballeria, arqueria  ).
leGana(arqueria  , infanteria).
leGana(infanteria, piquero  ).
leGana(piquero  , caballeria).
leGana(unica     , unica     ).

%   PUNTO 3   %
esJugador(J):- jugador(J, _, _).

unidadesDe(Jugador, TipoUnidad):- tiene(Jugador, unidad(TipoUnidad, _)).
categoriaBelica(Tipo, Categoria):- militar(Tipo, _, Categoria).

alarico(Jugador):-
    esJugador(Jugador),
    forall(unidadesDe(Jugador, TipoUnidad), categoriaBelica(TipoUnidad, infanteria)).

%   PUNTO 4   %
leonidas(Jugador):-
    esJugador(Jugador),
    forall(unidadesDe(Jugador, TipoUnidad), categoriaBelica(TipoUnidad, piquero)).

%   PUNTO 5   %
nomada(Jugador):-
    esJugador(Jugador),
    not(tiene(Jugador, edificio(casa, _))).
%No se modela tiene(Jugador, edificio(casa, 0) porque si no existe no esta en nuestra base de conocimiento.

%   PUNTO 6   %
cuantoCuesta(UnidadOEdificio, Costo):-
    costoDeProduccion(UnidadOEdificio, Costo),

costoDeProduccion(UnidadMilitar, Costo):-
    militar(UnidadMilitar, Costo, _).

costoDeProduccion(UnidadAldeano, costo(_, 50, _)):-
    aldeano(UnidadAldeano, _).

costoDeProduccion(Edificio, Costo):-
    edificio(Edificio, Costo).

costoDeProduccion(carreta     , costo(100, 0, 50)).
costoDeProduccion(urnaMercante, costo(100, 0, 50)).

%   PUNTO 7   %
produccion(Unidad, Produccion):-
    produccionSegunTipo(Unidad, Produccion).

produccionSegunTipo(Aldeano, Produccion):-
    aldeano(Aldeano, Produccion).

produccionSegunTipo(Unidad, Produccion):- produccionParticular(Unidad, Produccion).

produccionParticular(keshik      , produce(_, _, 10)).
produccionParticular(carreta     , produce(_, _, 32)).
produccionParticular(urnaMercante, produce(_, _, 32)).

%   PUNTO 8   %
produccionTotal(Jugador, Recurso, ProduccionTotal):-
    esJugador(Jugador),
    esRecurso(Recurso),
    findall(Total, produccionDe(Jugador, Recurso, Total), Totales),
    sumlist(Totales, ProduccionTotal).

produccionDe(Jugador, Recurso, Total) :-
    cantUnidadesDe(Jugador, Unidad, Cuanto),
    produccion(Unidad, ProduccionRecursosXMinuto),
    produccionSegunRecurso(Recurso, ProduccionRecursosXMinuto, Produce),
    Total is Produce * Cuanto.

produccionSegunRecurso(madera, produce(Total, _, _), Total).
produccionSegunRecurso(alimento, produce(_, Total, _), Total).
produccionSegunRecurso(oro, produce(_, _, Total), Total).

cantidadUnidad(unidad(_, Cuanto), Cuanto).

cantUnidadesDe(Jugador, Unidad, Cuanto):-
    tiene(Jugador, Unidad),
    cantidadUnidad(Unidad, Cuanto).

esRecurso(oro).
esRecurso(alimento).
esRecurso(madera).

%   PUNTO 9   %
estaPeleado(Jugador, OtroJugador):-
    esJugador(Jugador),
    esJugador(OtroJugador),
    not(esUnAfano(Jugador, OtroJugador)),
    not(esUnAfano(OtroJugador, Jugador)),
    cantidadDeUnidades(Jugador, Cantidad),
    cantidadDeUnidades(Jugador, Cantidad),
    calculoDeProduccion(Jugador, CalculoJugador),
    calculoDeProduccion(OtroJugador, CalculoOtroJugador),
    Dif is CalculoJugador - CalculoOtroJugador,
    abs(Dif, Diferencia),
    Diferencia < 100.

calculoDeProduccion(Jugador, CalculoProduccion):-
    esJugador(Jugador),
    produccionTotal(Jugador, oro, ProduccionOro),
    produccionTotal(Jugador, madera, ProduccionMadera),
    produccionTotal(Jugador, alimento, ProduccionAlimento),
    CalculoProduccion is (ProduccionOro * 5) + (ProduccionAlimento * 2) + (ProduccionMadera * 3).

cantidadDeUnidades(Jugador, Cantidad):-
    esJugador(Jugador),
    findall(CantidadUnidad, cantidadUnidadJugador(Jugador, CantidadUnidad), Cantidades),
    sumlist(Cantidades, Cantidad).

cantidadUnidadJugador(Jugador, CantidadUnidad):-
    tiene(Jugador, unidad(_, CantidadUnidad)).

/* PODRIA ESTAR MEJOR, SE PODRIA ABTRAER BASTANTE DEL estaPeleado(Jugador, OtroJugador) Y 
cantidadDeUnidades(Jugador, Cantidad) ESTA MAL CALCULADO, PERO ME DA PAJA CORREGIRLO.*/

