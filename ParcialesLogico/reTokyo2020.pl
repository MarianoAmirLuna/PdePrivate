/* BASE DE CONOCIMIENTO */
/* 
De los ATLETAS se conoce:
    NOMBRE 
    EDAD
    PAIS QUE REPRESENTA

De las DISCIPLINAS se conoce:
    EQUIPO O INDIVIDUAL
    En caso de ser individual se sabe QUIEN COMPITE

De las MEDALLAS se conoce:
    MATERIAL
    QUIEN O QUIENES GANAN
    EN QUE DISCIPLINA

De los EVENTOS se conoce:
    DISCIPLINA 
    RONDA
    PARTICIPANTES
*/

% atleta(Nombre, Edad, PasiDeOrigen).
atleta(juan, 25, argentina).

%seDesempenia(Nombre, Disciplina).
seDesempenia(juan   , natacion400MetrosFemenino).
seDesempenia(juan   , voleyMasculino).
seDesempenia(ernesto, voleyMasculino).

%disciplina(Deporte).
disciplina(voleyMasculino).
disciplina(natacion400MetrosFemenino).

%compite(Disciplina, functor(Participante)).
compite(voleyMasculino           , equipo(argentina)).
compite(natacion400MetrosFemenino, individual(juan )).

%medalla(Material, Disciplina, Ganador).
medalla(bronce, voleyMasculino, equipo(argentina)).

%evento(Disciplina, Ronda, Participante).
evento(hockeyFemenino, final, argentina  ).
evento(hockeyFemenino, final, paisesBajos).

vinoAPasear(Atleta):-
    atleta(Nombre, _, _),
    not(compite(Nombre, _, _)).

medallaDelPais(Disciplina, Medalla, Pais):-
    medalla(Medalla, Disciplina, Ganador),
    paisDe(Ganador, Pais).

paisDe(equipo(Pais)            , Pais).
paisDe(individual(Participante), Pais):- atleta(Participante, _, Pais).

participoEn(Ronda, Disciplina, Atleta):-
    atletaEnRonda(Ronda, Disciplina, Atleta).

atletaEnRonda(Ronda, Disciplina, Atleta):-
    evento(Disciplina, Ronda, Atleta),
    not(atleta(_, _, Atleta)).

atletaEnRonda(Ronda, Disciplina, Atleta):-
    evento(Disciplina, Ronda, Nacion),
    atleta(Atleta, _, Nacion),
    seDesempenia(Atleta, Disciplina).

dominio(Pais, Disciplina):-
    medallasDelPais(Disciplina, Medalla, Pais),
    forall((medallasDelPais(Disciplina, OtraMedalla, OtroPais), Medalla \= OtraMedalla), Pais = OtroPais).

medallaRapida(Disciplina):-
    disciplina(Disciplina),
    forall(evento(Disciplina, Ronda, _), Ronda is final).

/*
Otra opcion más valida en mi opinion
medallaRapida(Disciplina):-
    evento(Disciplina, Ronda, _),
    not(evento(Disciplina, OtraRonda, _)),
    Ronda \= OtraRonda.
*/

esPais(P  ):- atleta(_, _, P).
esAtleta(A):- atleta(A, _, _).
pasiDeParticipante(equipo(Pais)      , Pais).
pasiDeParticipante(individual(Atleta), Pais):-  atleta(Atleta, _, Pais).

noEsElFuerte(Pais, Disciplina):-
    compite(Disciplina, Participante),
    participanteDiligente(Participante, Disciplina, Pais).

participanteDiligente(Participante, Disciplina, Pais):-
    noParticipoEn(Participante, Disciplina, Pais).

participanteDiligente(equipo(Pais), Disciplina, Pais):-
    participacionRapida(Disciplina, Pais).

participanteDiligente(individual(Atleta), Disciplina, Pais):-
    atleta(Atleta, _, Pais),
    participacionRapida(Disciplina, Atleta).

participacionRapida(Disciplina, Pais):-
    esPais(Pais),
    evento(Disciplina, faseDeGrupos, Pais),
    noVolvioAParticipar(Disciplina, Pais, faseDeGrupos).

participacionRapida(Disciplina, Atleta):-
    esAtleta(A),
    evento(Disciplina, 1, Atleta),
    noVolvioAParticipar(Disciplina, Atleta, 1).

noVolvioAParticipar(Disciplina, Participante, Ronda):-
    evento(Disciplina, Ronda, Atleta),
    evento(Disciplina, OtraRonda, Atleta),
    OtraRonda \= Ronda.

noParticipoEn(Participante, Disciplina, Pais):-
    