% PUNTO 1
necesidad(respiracion, fisiologico).
necesidad(alimentacion, fisiologico).
necesidad(descanso, fisiologico).
necesidad(reproduccion, fisiologico).
necesidad(integridad, seguridad).
necesidad(empleo, seguridad).
necesidad(salud, seguridad).
necesidad(amistad, social).
necesidad(afecto, social).
necesidad(intimidad, social).
necesidad(confianza, reconocimiento).
necesidad(respeto, reconocimiento).
necesidad(exito, reconocimiento).
% un ejemplo cualquiera
necesidad(libertad, autorrealizacion).

nivelSuperior(autorrealizacion, reconocimiento).
nivelSuperior(reconocimiento, social).
nivelSuperior(social, seguridad).
nivelSuperior(seguridad, fisiologico).

% PUNTO 2
separacionEntre(NecesidadA,NecesidadB,Separacion):-
    necesidad(NecesidadA,NivelA),
    necesidad(NecesidadB,NivelB),
    separacionNiveles(NivelA, NivelB, Separacion).


separacionNiveles(Nivel,Nivel,0).
separacionNiveles(NivelA,NivelB,Separacion):-
    nivelSuperior(NivelB,NivelIntermedio),
    separacionNiveles(NivelA,NivelIntermedio,SepAnterior),
    Separacion is SepAnterior + 1.

% PUNTO 3
necesita(carla, alimentacion).
necesita(carla, descanso).
necesita(carla, empleo).
% no agrego empleo de juan porque por principio de universo cerrado quiero que de falso.
necesita(juan, afecto).
necesita(juan, exito).
necesita(camila, alimentacion).
necesita(camila, descanso).
necesita(roberto, amistad).
necesita(manuel, libertad).
necesita(charly, afecto).

% PUNTO 4
necesidadMayorJerarquia(Persona,Necesidad):-
    necesita(Persona,Necesidad),
    not((necesita(Persona,OtraNecesidad),mayorJerarquia(OtraNecesidad,Necesidad))).

mayorJerarquia(Necesidad1,Necesidad2):-
    separacionEntre(Necesidad2,Necesidad1,Separacion),
    Separacion > 0.

% PUNTO 5
persona(Persona):- necesita(Persona, _).
nivel(Nivel):- necesidad(_,Nivel).

nivelSatisfecho(Persona,Nivel):-
    persona(Persona),
    nivel(Nivel),
    not(nivelConNecesidades(Persona,Nivel)).

nivelConNecesidades(Persona,Nivel):-
    necesita(Persona,Necesidad),
    necesidad(Necesidad,OtroNivel),
    separacionNiveles(OtroNivel,Nivel,_).