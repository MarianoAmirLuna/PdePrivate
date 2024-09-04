aeropuertos(aep, ubicadoEn(argentina, buenosAires)).
aeropuertos(eze, ubicadoEn(argentina, buenosAires)).
aeropuertos(gru, ubicadoEn(brasil, saoPaulo)).
aeropuertos(scl, ubicadoEn(chile, santiagoDeChile)).

%ciudadTipo(Ciudad, paradisiaca).
%ciudadTipo(Ciudad, negocios).
%ciudadTipo(Ciudad, importanciaCultural[LugaresAVisitar]).

ciudadTipo(ubicadoEn(filipinas, palawan), paradisiaca).
ciudadTipo(ubicadoEn(usa, chicago), negocios).
ciudadTipo(ubicadoEn(qatar, doha), negocios).
ciudadTipo(ubicadoEn(francia, paris), importanciaCultural([torreEiffel, arcodelTriunfo, museoLouvre, catedralDeNotreDame])).
ciudadTipo(ubicadoEn(argentina, buenosAires), importanciaCultural([obelisco, congreso, cabildo])).

ruta(aerolineasProlog, viaja(aep, gru), 75000).
ruta(aerolineasProlog, viaja(gru, scl), 65000).

deCabotaje(Aerolinea):-
    ruta(Aerolinea, viaja(Aeropuerto1, Aeropuerto2), _),
    sonDelMismoPais(Aeropuerto1, Aeropuerto2).

sonDelMismoPais(Aeropuerto1, Aeropuerto2):-
    aeropuertos(Aeropuerto1, ubicadoEn(Pais, _)),
    aeropuertos(Aeropuerto2, ubicadoEn(Pais, _)),
    Aeropuerto2 \= Aeropuerto1.

viajeDeIda(Ciudad):-
    ruta(_, viaja(_, Ciudad), _),
    not(ruta(_, viaja(Ciudad, _), _)).

relativamenteDirecta(Aeropuerto1, Aeropuerto2):-
    ruta(_, viaja(Aeropuerto1, Aeropuerto2), _).

relativamenteDirecta(Aeropuerto1, Aeropuerto2):-
    ruta(Aeropuerto, viaja(Aeropuerto1, Aeropuerto3), _),
    ruta(Aeropuerto, viaja(Aeropuerto3, Aeropuerto2), _).

%viajero(Nombre, Dinero, Millas).
viajero(eduardo, 50000, 750).

%viveEn(Nombre, Pais).
viveEn(eduardo, ubicadoEn(argentina, buenosAires)).

puedeViajar(Persona, CiudadOrigen, CiudadDestino):-
    viajero(Persona, Dinero, _),
    desdeHasta(CiudadOrigen, CiudadDestino, Precio),
    Dinero >= Precio.

puedeViajar(Persona, CiudadOrigen, CiudadDestino):-
    viajero(Persona, _, Millas),
    ciudadesDelMismoPais(CiudadOrigen, CiudadDestino),
    desdeHasta(CiudadOrigen, CiudadDestino, Precio),
    Millas >= 500.

puedeViajar(Persona, CiudadOrigen, CiudadDestino):-
    viajero(Persona, _, Millas),
    desdeHasta(CiudadOrigen, CiudadDestino, Precio),
    not(ciudadesDelMismoPais(CiudadOrigen, CiudadDestino)),
    Precio * 0.2 >= Millas.

ciudadesDelMismoPais(CiudadOrigen, CiudadDestino):-
    ubicadoEn(Pais1, CiudadOrigen),
    ubicadoEn(Pais2, CiudadDestino),
    Pais2 = Pais1.

desdeHasta(CiudadOrigen, CiudadDestino, Precio).
    aeropuertos(Partida, CiudadOrigen),
    aeropuertos(Llegada, CiudadDestino),
    ruta(_, viaja(Partida, Llegada), Precio).

quiereViajar(Persona):-
    economiaEstable(Persona),
    viaja(Persona).

viaja(Persona):-
    ciudadActual(Persona, CiudadOrigen),
    puedeViajar(Persona, CiudadOrigen, CiudadDestino),
    ciudadesAdecuadas(CiudadDestino).

ciudadActual(Persona, CiudadOrigen):-
    viveEn(Persona, ubicadoEn(_, CiudadOrigen)).

economiaEstable(Persona):-
    viajero(Persona, Dinero, Millas),
    Dinero >= 5000,
    Millas >= 100.

ciudadesAdecuadas(Ciudad):-
    ciudadTipo(Ciudad, paradisiaca).

ciudadesAdecuadas(Ciudad):-
    ciudadTipo(Ciudad, importanciaCultural(LugaresAVisitar)),
    length(LugaresAVisitar, Cantidad),
    Cantidad >= 4.

ciudadesAdecuadas(qatar).

ahorrarUnPocoMas(Persona, CiudadDestino):-
    quiereIr(Persona, CiudadDestino, Costo),
    forall((quiereIr(Persona, OtraCiudad, OtroCosto), OtraCiudad \= CiudadDestino), Costo < OtraCiudad).

quiereIr(Persona, CiudadDestino, Costo):-
    ciudadActual(Persona, CiudadOrigen),
    pasajero(Persona, Dinero, _),
    aeropuertoDe(CiudadOrigen, Aeropuerto1),
    aeropuertoDe(CiudadDestino, Aeropuerto2),
    ruta(_, viaja(Aeropuerto1, Aeropuerto2), Costo),
    Costo > Dinero.

aeropuertoDe(Ciudad, Aeropuerto):-
    aeropuertos(Aeropuerto, ubicadoEn(_, Ciudad)).