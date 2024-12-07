% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotráfico([metanfetaminas])).
prisionero(alex, narcotráfico([heroína])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotráfico([heroína, opio])).
prisionero(dayanara, narcotráfico([metanfetaminas])).


controla(piper, alex).
controla(bennett, dayanara).
% controla(Guardia, Otro):- prisionero(Otro,_), not(controla(Otro, Guardia)).

controla(Guardia, Otro):-
    prisionero(Otro,_),
    guardia(Guardia),
    not(controla(Otro, Guardia)).

conflictoDeIntereses(Persona1, Persona2):-
    controla(Persona1, Persona3),
    controla(Persona2, Persona3),
    not(controlMutuo(Persona1, Persona2)).

controlMutuo(Persona1, Persona2):-
    controla(Persona1, Persona2),
    controla(Persona2, Persona1).



peligroso(NombrePreso):-
    prisionero(NombrePreso, _),
    forall(prisionero(NombrePreso, Crimen), grave(Crimen)).

grave(homicidio(_)).
grave(narcotráfico(ListaDeDrogas)):- member(metanfetaminas, ListaDeDrogas).
grave(narcotráfico(ListaDeDrogas)):- length(ListaDeDrogas, Cantidad), Cantidad >= 5.

ladronDeGuanteBlanco(Prisionero):-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), seHaceElPiola(Crimen)).

seHaceElPiola(robo(Cantidad)):- Cantidad > 100000.


pena(robo(Monto), Pena):-
    Pena is Monto/10000.

pena(homicidio(Alguien), Pena):-
    not(guardia(Alguien)),
    Pena is 7.

pena(homicidio(Alguien), Pena):-
    guardia(Alguien),
    Pena is 9.

pena(narcotráfico(ListaDeDrogas), Pena):-
    length(ListaDeDrogas, CantidadDeDrogas),
    Pena is CantidadDeDrogas * 2.

condena(Prisionero, Pena):-
    prisionero(Prisionero, _),
    findall(PenaParcial, (prisionero(Prisionero, Crimen), pena(Crimen, PenaParcial)), ListaDePenas),
    sumlist(ListaDePenas, Pena).
