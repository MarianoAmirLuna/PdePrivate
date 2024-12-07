%persona(Nombre, Edad, Genero).
persona(ana  , 25, femenino ).
persona(juan , 30, masculino).
persona(maria, 28, femenino ).
persona(pedro, 35, masculino).
persona(lucia, 22, femenino ).

%leInteresaGeneroA(Nombre, Genero).
leInteresaGeneroA(ana  , masculino).
leInteresaGeneroA(juan , femenino ).
leInteresaGeneroA(maria, masculino).
leInteresaGeneroA(pedro, femenino ).
leInteresaGeneroA(lucia, masculino).

%leInteresaEdadA(Nombre, EdadMin, EdadMax).
leInteresaEdadA(ana  , 28, 35).
leInteresaEdadA(juan , 20, 30).
leInteresaEdadA(maria, 25, 40).
leInteresaEdadA(pedro, 18, 28).
leInteresaEdadA(lucia, 30, 40).

%leGustaA(Nombre, Cosas).
leGustaA(ana, [leer, correr, cocinar]).
leGustaA(juan, [futbol, videojuegos, series]).
leGustaA(maria, [viajar, leer]).
leGustaA(pedro, [musica, videojuegos]).
leGustaA(lucia, [bailar, fotografia]).

%leDisgustaA(Nombre, Cosas).
leDisgustaA(ana, [videojuegos, bailar]).
leDisgustaA(juan, [cocinar, fotografia]).
leDisgustaA(maria, [correr, futbol]).
leDisgustaA(pedro, [leer, bailar]).
leDisgustaA(lucia, [videojuegos, futbol]).

%%% Separar los datos asociados a una persona en distintos predicados %%%

esPersona(Nombre):- persona(Nombre, _, _).

%%% El predicado Principal, en este caso "perfilIncompleto", debe aparece una sola vez %%%
%%% y llamar a un predicado auxiliar N veces                                           %%%

%%%%%%%%%
%%% 1 %%%
%%%%%%%%%

perfilIncompleto(Nombre):-  esPersona(Nombre),  not(perfilCompleto(Nombre)).
perfilIncompleto(Nombre):-  persona(Nombre, Edad, _), Edad < 18.

perfilCompleto(Nombre):-
    esPersona(Nombre),
    interesesCompletos(Nombre),
    gustosCompletos(Nombre).

interesesCompletos(Nombre):-
    leInteresaEdadA(Nombre, _, _),
    leInteresaGeneroA(Nombre, _ ).

gustosCompletos(Nombre):-
    leGustaA(Nombre, CosasQueLeGustan)      , criterioDeGustosMinimos(CosasQueLeGustan   ),
    leDisgustaA(Nombre, CosasQueLeDisgustan), criterioDeGustosMinimos(CosasQueLeDisgustan).

criterioDeGustosMinimos(ListaDeGustos):- lentgh(ListaDeGustos, Cantidad),    Cantidad > 5.

%%%%%%%%%
%%% 2 %%%
%%%%%%%%%

leInteresaTodosLosGeneros(Nombre):-
    forall(persona(_, _, Genero), leInteresaGeneroA(Nombre, Genero)).

laEdadNoImporta(Nombre):-
    leInteresaEdadA(Nombre, EdadMin, EdadMax),
    30 <= EdadMax - EdadMin.

almaLibre(Nombre):- laEdadNoImporta(Nombre),
almaLibre(Nombre):- esPersona(nombre),  leInteresaTodosLosGeneros(Nombre).


quiereLaHerencia(Nombre):-
    persona(Nombre, Edad, _),
    leInteresaEdadA(Nombre, EdadMin, _),
    EdadMin >= Edad + 30.


indeseable(Nombre):-
    esPersona(Nombre),
    not(esPretendienteDe(_, Nombre)).

%%%%%%%%%
%%% 3 %%%
%%%%%%%%%

esPretendienteDe(Pretendiente, Cortejada):-
    interesaElGenero(Pretendiente, Cortejada),
    interesaLaEdad(Pretendiente, Cortejada),
    existeAlMenosUnGustoEnComun(Pretendiente, Cortejada),
    Pretendiente \= Cortejada.

interesaElGenero(Pretendiente, Cortejada):-
    persona(Cortejada, _, Genero),
    leInteresaGeneroA(Pretendiente, Genero).

interesaLaEdad(Pretendiente, Cortejado):-
    leInteresaEdadA(Pretendiente, EdadMin, EdadMax),
    persona(Cortejado, EdadDelCortejado, _),
    between(EdadMin, EdadMax, EdadDelCortejado).

existeAlMenosUnGustoEnComun(Pretendiente, Cortejado):-
    unGustoDe(Pretendiente, UnGusto),
    unGustoDe(Cortejado   , UnGusto).

unGustoDe(Persona, UnGusto):-
    leGustaA(Persona, Gustos),
    member(UnGusto, Gustos).


hayMatch(Persona1, Persona2):-
    esPretendienteDe(Persona1, Persona2),
    esPretendienteDe(Persona2, Persona1).

trianguloAmoroso(Persona1, Persona2, Persona3):-
    casiMatch(Persona1, Persona2),
    casiMatch(Persona2, Persona3),
    casiMatch(Persona3, Persona1).

casiMatch(Persona1, Persona2):-
    pretendiente(Persona1, Persona2),
    not(pretendiente(Persona2, Persona1)).


unoParaElOtro(Persona1, Persona2):-
    hayMatch(Persona1, Persona2),
    gustosConsistentes(Persona1, Persona2),
    gustosConsistentes(Persona2, Persona1).

gustosConsistentes(Persona1, Persona2):-
    leGustaA(Persona1, Gustos),
    leDisgustaA(Persona2, Disgustos),
    forall(member(Gusto, Gustos), not(member(Gusto, Disgustos))).

%%%%%%%%%
%%% 4 %%%
%%%%%%%%%

%indiceDeAmor(Emisor, IdA, Receptor).

desbalance(Persona1, Persona2):-
    esPersona(Persona1),
    esPersona(Persona2),
    indiceDeAmorPromedio(Persona1, Persona2, IdAP1),
    indiceDeAmorPromedio(Persona2, Persona1, IdAP2),
    IdAP1 < IdAP2 * 2.

indiceDeAmorPromedio(Emisor, Receptor, IdAP):-
    findall(IdA, indiceDeAmor(Emisor, IdA, Receptor), ListaDeIndices),
    legth(ListaDeIndices, Cantidad), sumlist(ListaDeIndices, TotalDePuntos),
    IdAP is TotalDePuntos / Cantidad.

ghosteo(Persona1, Persona2):-
    indiceDeAmor(Persona1, _, Persona2),
    not(indiceDeAmor(Persona2, _, Persona1)).