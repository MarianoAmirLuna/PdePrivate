%%% MODELADO DE INFORMACIÓN:
%% atleta(Nombre, Edad, PaisQueRepresenta).
atleta(juanPerez, 28, argentina).

%% disciplina(Nombre).
disciplina(voleyMasculino).
disciplina(carrera100MetrosLlanos).

%% competencia(Nombre, Categoria).
competencia(voleyMasculino, equipo(argentina)).
competencia(carrera400MetrosConVallasFemenino, individual(dalilahMuhammad)).

%% medalla(Material, Disciplina, Premiado/s).
medalla(bronce, voleyMasculino, equipo(argentina)).

%% evento(Disciplina, Ronda, Participante/s).
evento(hockeyFemenino, final, equipo(argentina)).
evento(hockeyFemenino, final, equipo(paisesBajos)).

vinoAPasear(Atleta):-
    atleta(Atleta, _, _),
    not(competencia(_, individual(Atleta))).

medallasDelPais(Disciplina, Medalla, Pais):-
    medalla(Medalla, Disciplina, equipo(Pais)).

medallasDelPais(Disciplina, Medalla, Pais):-
    medalla(Medalla, Disciplina, individual(Atleta)),
    atleta(Atleta, _, Pais).

participoEn(Ronda, Disciplina, Atleta):-
    evento(Disciplina, Ronda, individual(Atleta)).

participoEn(Ronda, Disciplina, Atleta):-
    evento(Disciplina, Ronda, equipo(Pais)),
    atleta(Atleta, _, Pais),
    competencia(Disciplina, individual(Atleta)).

dominio(Pais, Disciplina):-
    medallasDelPais(Disciplina, Medalla, Pais),
    forall((medallasDelPais(Disciplina, OtraMedalla, OtroPais), Medalla \= OtraMedalla), Pais = OtroPais).

medallaRapida(Disciplina):-
    evento(Disciplina, Ronda, _),
    not(evento(Disciplina, OtraRonda, _)),
    Ronda \= OtraRonda.

noEsElFuerte(Pais, Disciplina):-
    noParticipo(Pais, Disciplina).

noEsElFuerte(Pais, Disciplina):-
    participoAlInicio(Pais, Disciplina).

participoAlInicio(Pais, Disciplina):-
    atleta(Atleta, _, Pais),
    competencia(Disciplina, individual(Atleta)),
    participoEn(1, Disciplina, Atleta).

participoAlInicio(Pais, Disciplina):-
    atleta(Atleta, _, Pais),
    competencia(Disciplina, equipo(Pais)),
    participoEn(faseDeGrupos, Disciplina, Atleta).

noParticipo(Pais, Disciplina):-
    identidad(Pais, Disciplina),
    not(competencia(Disciplina, equipo(Pais))).

noParticipo(Pais, Disciplina):-
    atleta(Atleta, _, Pais),
    identidad(Pais, Disciplina),
    not(competencia(Disciplina, individual(Atleta))).

identidad(Pais, Disciplina):-
    atleta(_, _, Pais),
    competencia(Disciplina, _).

medallasEfectivas(CantPuntos, Pais):-
    identidad(Pais, _),
    findall( Puntos, (medallasDelPais(_, Medalla, Pais), puntosDeMedalla(Medalla, Puntos)), ListaDePuntos),
    sumlist(ListaDePuntos, CantPuntos).

puntosDeMedalla(oro, 3).
puntosDeMedalla(plata, 2).
puntosDeMedalla(bronce, 1).

laEspecialidad(Atleta):-
    atleta(Nombre, _, _),
    not(vinoAPasear(Atleta)),
    forall(competencia(Disciplina, individual(Atleta)), obtuvoBuenaPuntuacion(Atleta, Disciplina)).

obtuvoBuenaPuntuacion(Atleta, Disciplina):-
    atleta(Nombre, _, Pais),
    competencia(Disciplina, individual(Atleta)).
    ganoOroOPlata(Pais, Disciplina),

ganoOroOPlata(Pais, Disciplina):-
    medallasDelPais(Disciplina, oro, Pais).

ganoOroOPlata(Pais, Disciplina):-
    medallasDelPais(Disciplina, plata, Pais).