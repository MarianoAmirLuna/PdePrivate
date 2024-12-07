% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).
tripulante(law, heart).
tripulante(bepo, heart).
tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% Ejemplo inventado para probar el punto 7:
tripulante(ema, piratasDePablo).
tripulante(pablo, piratasDePablo).
tripulante(ivan, piratasDePablo).

% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy, dressrosa, 100000000).
impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).
impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).
impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).
impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).
impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo, 240000000).
impactoEnRecompensa(law, dressrosa, 60000000).
impactoEnRecompensa(bepo,sabaody,500).
impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

tripulantesEnEvento(Tripulante, Evento):-
    impactoEnRecompensa(Tripulante, Evento, _).


tripulacionesEnElMismoEvento(UnaTripulacion, OtraTripulacion, Evento):-
    eventoPorTripulacion(UnaTripulacion, Evento ),
    eventoPorTripulacion(OtraTripulacion, Evento).

eventoPorTripulacion(Tripulacion, Evento):-
    tripulante(Miembro, Tripulacion         ),
    impactoEnRecompensa(Miembro, Evento, _  ).


pirataMasDetacadoPorEvento(Evento, PirataDestacado):-
    impactoEnRecompensa(PirataDestacado, Evento, MontoDestacado),
    forall(impactoEnRecompensa(Pirata, Evento, Monto), (Monto =< MontoDestacado)).

pasoDesapercibido(Pirata, Evento):-
    tripulante(Pirata, Tripulacion),
    tripulacionParticipoEnEvento(Tripulacion, Evento),
    not(impactoEnRecompensa(Pirata, Evento, _)).

tripulacionParticipoEnEvento(Tripulacion, Evento):-
    tripulante(Pirata, Tripulacion),
    impactoEnRecompensa(Pirata, Evento, _).



recompensaTripulacion(Tripulacion, RecompensaTotal):-
    tripulante(_, Triulacion),
    findall(RecompensaActual, (tripulante(Tripulante, Tripulacion), recompesaActual(Tripulante, RecompensaActual)), ListaDeRecompensas),
    sumlist(ListaDeRecompensas, RecompensaTotal).

recompesaActual(Tripulante, RecompensaActual):-
    tripulante(Tripulante   , _                                        ),
    findall(Monto           , impactoEnRecompensa(Tripulante, _, Monto) , ListaDeMontos ),
    sumlist(ListaDeMontos   , RecompensaActual                         ).

tripulantePeligroso(Tripulante):-
    recompesaActual(Tripulante, RecompensaActual),
    RecompensaActual > = 100000000.

tripulacionPeligrosa(Tripulacion):-
    losIntegrantesSonTemibles(Tripulacion).

losIntegrantesSonTemibles(Tripulacion):-
    forall(tripulante(Tripulante, Tripulacion), tripulantePeligroso(Tripulante)).

losIntegrantesSonTemibles(Tripulacion):-
    recompensaTripulacion(Tripulacion, RecompensaTotal),
    RecompensaTotal >= 500000000.

esFeroz(lobo).
esFeroz(lobo).
esFeroz(lobo).

frutaDelDiablo(paramecia).
frutaDelDiablo(logia    ).
frutaDelDiablo(zoan     ).

fruta(gomuGomu, tipoFruta(paramecia, false    )).
fruta(barBara , tipoFruta(paramecia, false    )).
fruta(opeOpe  , tipoFruta(paramecia, true   )).
fruta(hitoHito, tipoFruta(zoan     , humano  )).
fruta(nekoNeko, tipoFruta(zoan     , leopardo)).
fruta(mokuMoku, tipoFruta(logia    , true    )).

frutaPeligrosa(Fruta):-
    fruta(Fruta, Tipo),
    esPeligrosa(Tipo ).

esPeligrosa(tipoFruta(logia, _)).
esPeligrosa(tipoFruta(paramecia, true)).
esPeligrosa(tipoFruta(zoan, Transformacion)):-
    esFeroz(Transformacion).


comioFruta(luffy  , gomugomu).
comioFruta(buggy  , barabara).
comioFruta(law    , opeope  ).
comioFruta(chopper, hitohito).
comioFruta(lucci  , nekoneko).
comioFruta(smoker , mokumoku).

tripulantePeligroso(Tripulante):-
    comioFruta(Tripulante, Fruta      ),
    fruta(Fruta          , TipoDeFruta),
    esPeligrosa(TipoDeFruta           ).

piratasDeAsfalto(Tripulacion ):-
    tripulante(_, Tripulacion),
    forall(tripulante(Tripulante, Tripulacion), comioFruta(Tripulante  , _)).