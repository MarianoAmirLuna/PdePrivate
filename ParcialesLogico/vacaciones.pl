viajero(Persona):- viajaA(Persona, _).

%viajaA(Viajero, Ubicacion).
viajaA(dodain, pehuenia).
viajaA(dodain, andes).
viajaA(dodain, esquel).
viajaA(dodain, sarmiento).
viajaA(dodain, camarones).
viajaA(dodain, playasDoradas).

viajaA(alf, bariloche).
viajaA(alf, andes).
viajaA(alf, bolson).

viajaA(nico, marDelPlata).
viajaA(nico, marDelPlata).

viajaA(vale, calafate).
viajaA(vale, bolson).

viajaA(martu, Ubicacion):-
    viajaA(nico, Ubicacion).

viajaA(martu, Ubicacion):-
    viajaA(alf, Ubicacion).

%%%ATRACCIONES%%%
destino(bolson).
destino(bariloche).
destino(andes).
destino(pehuenia).
destino(esquel).
destino(sarmiento).
destino(camarones).
destino(playasDoradas).
destino(calafate).

/*
parqueNacional(Nombre).
cerro(Nombre, Altura).
cuerpoDeAgua(Nombre, SePuedePescar, TemperaturaDelAgua).
playa(DiferenciaDeMarea).
excursion(Nombre).
*/

%atraccion(Nombre       , tipoAtraccion()       ).
atraccion(losAlerces    , parqueNacional()      ).
atraccion(trochita      , excursion(trochita)   ).
atraccion(trevelin      , excursion(trevelin)   ).
atraccion(bateMahuida   , cerro(2000)           ).
atraccion(moquehue      , cuerpoDeAgua(true, 14)).
atraccion(alumine       , cuerpoDeAgua(true, 19)).

%tieneAtraccion(Ubicacion, Atraccion).
tieneAtraccion(esquel       , losAlerces ).
tieneAtraccion(esquel       , trochita   ).
tieneAtraccion(esquel       , trevelin   ).
tieneAtraccion(pehuenia     , bateMahuida).
tieneAtraccion(pehuenia     , moquehue   ).
tieneAtraccion(pehuenia     , alumine    ).

vacionesCopadas(Persona):-
    viajaA(Persona, Ubicacion),
    forall(Ubicacion, tieneAtraccionCopada(Ubicacion)).

tieneAtraccionCopada(Ubicacion):-
    tieneAtraccion(Ubicacion, Atraccion),
    atraccion(Atraccion, TipoAtraccion ),
    esCopada(TipoAtraccion             ).

esCopada(cuerpoDeAgua(_   , TemperaturaDelAgua)):-    mayorQue(TemperaturaDelAgua, 20).
esCopada(cuerpoDeAgua(true, _)                 ).
esCopada(cerro(Altura)                         ):-    mayorQue(Altura, 2000).
esCopada(playa(DiferenciaDeMarea)              ):-    not(mayorQue(DiferenciaDeMarea, 5)).
esCopada(excursion(Nombre)                     ):-    length(Nombre, Tamanio), mayorQue(Tamanio, 7).
esCopada(parqueNacional()                      ).

mayorQue(Cosa, Cantidad):-
    Cosa > Cantidad.


noSeCruzaron(Persona1, Persona2):-
    viajero(Persona1),
    viajero(Persona2),
    forall((viajaA(Persona1, Ubicacion1), viajaA(Persona2, Ubicacion2)), Ubicacion1 \= Ubicacion2).

% costo(Destino, Costo).
costo(sarmiento     , 100).
costo(esquel        , 150).
costo(pehuenia      , 180).
costo(andes         , 150).
costo(camarones     , 135).
costo(playasDoradas , 170).
costo(bariloche     , 140).
costo(calafate      , 240).
costo(bolson      , 145).
costo(marDelPlata   , 140).

viajeGasolero(Persona):-
    viajero(Persona),
    forall(viajaA(Persona, Ubicacion), destinoGasolero(Ubicacion)).

destinoGasolero(Ubicacion):-
    costo(Ubicacion, Costo  ),
    not(mayorQue(Costo, 160)).