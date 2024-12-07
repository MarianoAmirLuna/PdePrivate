%trabaja(Persona, Trabajo, EnDonde).
trabaja(juan, programacion, acme).
trabaja(ana, testing, acme).
trabaja(ana, programacion, acme).
trabaja(marta, ceo, acme).
trabaja(carlos, programacion, narnia).
trabaja(carlos, docente, escuela).

%estudia(Persona, Titulo, Anios, Institucion).
estudia(juan,sistemas,5,utn).
estudia(tita,sistemas,3,utn).
estudia(ana,computacion,4, uba).
estudia(ana,computacion,3, utn).
estudia(carlos, medicina,7,umm).
estudia(cacho, medicina,5,uuu).

%habilita(Titulo, Trabajo).
habilita(sistemas   , programacion    ).
habilita(sistemas   , testing         ).
habilita(computacion, testing         ).
habilita(medicina   , urgenciasMedicas).
habilita(medicina   , cirugia         ).

estudioYtrabajo(Persona, Titulo, Trabajo):-
    estudia(Persona, Titulo , _, _),
    trabaja(Persona, Trabajo, _   ).

trabajaDeLoQueEstudio(Persona):-
    estudioYtrabajo(Persona, Titulo, Trabajo),
    habilita(Titulo        , Trabajo        ).

trabajaDeAlgoQueNoEstudio(Persona):-
    estudioYtrabajo(Persona, Titulo, Trabajo),
    not(habilita(Titulo    , Trabajo       )).


noTrabajaEnNadaDeLoQueEstudio(Persona):-
    estudia(Persona, _, _, _),
    forall(estudioYtrabajo(Persona, Titulo, Trabajo), not(habilita(Titulo, Trabajo))).



estudiantesTrabajadores(Institucion):-
    estudia(_, _, _, Institucion),
    forall(estudia(Persona, _, _, Institucion), trabaja(Persona, _, _)).

carreraComplicada(Carrera):-
    estudia(_, Carrera, _, _),
    forall(estudia(Persona, Carrera, _, _), not(trabajaDeLoQueEstudio(Persona))).

alumnosEnInstitucion(Lugar, Institucion):-
    estudia(_, _, _, Institucion),
    trabaja(_, _, Lugar),
    findall(Persona, (estudia(Persona, _, _, Institucion), trabaja(Persona, _, Lugar)), ListaDeAlumnosXInstitucion),
    length(ListaDeAlumnosXInstitucion, CantAlumnos),
    CantAlumnos >= 5.

esfuerzo(LugarDeTrabajo, Persona, CantAnios):-
    trabaja(Persona, _, LugarDeTrabajo),
    findall(Anios, estudia(Persona, _, Anios, _), ListaDeAniosEstudiados),
    sumlist(ListaDeAniosEstudiados, CantAnios).

esfuerzo(LugarDeTrabajo, Persona, 0):-
    trabaja(Persona, _, LugarDeTrabajo),
    not(estudia(Persona, _, _, _)).
