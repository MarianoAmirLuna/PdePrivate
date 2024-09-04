creeEn(gabriel, campanita).
creeEn(gabriel, magoDeOz).
creeEn(gabriel, cavenaghi).
creeEn(juan, conejoDePascua).
creeEn(macarena, reyesMagos).
creeEn(macarena, magoCapria).
creeEn(macarena, campanita).

quiereSer(gabriel, suenioTipo(futbolista(arsenal))).
quiereSer(gabriel, suenioTipo(ganador(NumerosLoteria))):-
    member(Numero, NumerosLoteria),
    between(5, 9, Numero).

quiereSer(juan, suenioTipo(cantante(100000))).

quiereSer(macarena, suenioTipo(cantante(10000))).

dificultadDelSuenio(4, cantante(DiscosVendidos)):-
    not(cantanteExitoso(DiscosVendidos)).

dificultadDelSuenio(6, cantante(DiscosVendidos)):-
    cantanteExitoso(DiscosVendidos).

dificultadDelSuenio(Dificultad, ganador(NumerosApostados)):-
    length(NumerosApostados, Cantidad),
    Dificultad is Cantidad * 10.

dificultadDelSuenio(3, futbolista(Equipo)):-
    esEquipoChico(Equipo).

dificultadDelSuenio(16, futbolista(Equipo)):-
    not(esEquipoChico(Equipo)).

esEquipoChico(arsenal).
esEquipoChico(aldosivi).

cantanteExitoso(DiscosVendidos):-
    DiscosVendidos > 500000.

ambicioso(Persona):-
    esPersona(Persona),
    findall( Puntaje, puntajePorPersona(Persona, Puntaje), ListaDePuntajes),
    sumlist(ListaDePuntajes, Cantidad),
    Cantidad > 20.

puntajePorPersona(Persona, Puntaje):-
    quiereSer(Persona, suenioTipo(Suenio)),
    dificultadDelSuenio(Puntaje, Suenio).

esPersona(Persona):-
    quiereSer(Persona, _).

hayQuimica(Persona, Personaje):-
    creeEn(Persona, Personaje),
    esPuroDeCorazon(Persona, Personaje).

esPuroDeCorazon(Persona, campanita):-
    quiereSer(Persona, suenioTipo(Suenio)),
    dificultadDelSuenio(Dificultad, Suenio),
    Dificultad < 5.

esPuroDeCorazon(Persona, Personaje):-
    Personaje \= campanita,
    todosLosSueniosSonPuros(Persona),
    not(ambicioso(Persona)).

todosLosSueniosSonPuros(Persona):-
    esPersona(Persona),
    forall(quiereSer(Persona, suenioTipo(Suenio)), suenioPuro(Suenio)).

suenioPuro(futbolista(_)).

suenioPuro(cantante(DiscosVendidos)):-
    DiscosVendidos < 200000.

sonAmigos(campanita, reyesMagos).
sonAmigos(campanita, conejoDePascua).

sonAmigos(conejoDePascua, cavenaghi).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

puedeAlegrar(Persona, Personaje):-
    quiereSer(Persona, _),
    hayQuimica(Persona, Personaje),
    personajeNoEnfermo(Personaje).

personajeNoEnfermo(Personaje):-
    not(estaEnfermo(Personaje)).

personajeNoEnfermo(Personaje):-
    amigos(Personaje, Amigo),
    not(estaEnfermo(Amigo)).

esPersonaje(Personaje):-
    creeEn(_, Personaje).

amigos(Personaje, Amigo):-
    sonAmigos(Personaje, Amigo).

amigos(Personaje, Amigo):-
    sonAmigos(Personaje, Amigo1),
    amigos(Amigo1, Amigo).