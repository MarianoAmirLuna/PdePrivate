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
prisionero(tokyo, robo(10000000)).


%1. Dado el predicado controla/2:
%controla(Controlador, Controlado)

controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- prisionero(Otro,_), not(controla(Otro, Guardia)).

%Indicar, justificando, si es inversible y, en caso de no serlo, dar ejemplos
%de las consultas que NO podrían hacerse y corregir la implementación para que se pueda.

% La función de orden superior NOT no es inversible por lo que la variable Guardia al utilizarce por primera
%vez dentro de esta no es inversible. Ejemplo: controla(Guardia, red).

controlaBien(Guardia, Otro):- prisionero(Otro,_), guardia(Guardia), not(controla(Otro, Guardia)).

%2. conflictoDeIntereses/2: relaciona a dos personas distintas (ya sean guardias o prisioneros)
% si no se controlan mutuamente y existe algún tercero al cual ambos controlan.

conflictoDeIntereses(Persona1, Persona2):-
    controla(Persona2, Persona3),
    controla(Persona1, Persona3),
    Persona1 \= Persona2,
    not(controla(Persona1, Persona2)),
    not(controla(Persona2, Persona1)).

%3. peligroso/1: Se cumple para un preso que sólo cometió crímenes graves.
%Un robo nunca es grave.
%Un homicidio siempre es grave.
%Un delito de narcotráfico es grave cuando incluye al menos 5 drogas a la vez, o incluye metanfetaminas.

peligroso(NombrePreso):-
    prisionero(NombrePreso, _),
    forall(prisionero(NombrePreso, Crimen), grave(Crimen)).

grave(homicidio(_)).
grave(narcotráfico(ListaDeDrogas)):- member(metanfetaminas, ListaDeDrogas).
grave(narcotráfico(ListaDeDrogas)):- length(ListaDeDrogas, Cantidad), Cantidad >= 5.

%4. ladronDeGuanteBlanco/1: Aplica a un prisionero si sólo cometió robos y todos fueron por más de $100.000.

ladronDeGuanteBlanco(Prisionero):-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), seHaceElPiola(Crimen)).

seHaceElPiola(robo(Cantidad)):- Cantidad > 100000.

%5. condena/2: Relaciona a un prisionero con la cantidad de años de condena que debe cumplir.
%Esto se calcula como la suma de los años que le aporte cada crimen cometido, que se obtienen de la siguiente forma:
%   -La cantidad de dinero robado dividido 10.000.
%   -7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
%   -2 años por cada droga que haya traficado.

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

%capoDiTutiLiCapi/1: Se dice que un preso es el capo de todos los capos cuando nadie lo controla,
%pero todas las personas de la cárcel (guardias o prisioneros) son controlados por él, o por
%alguien a quien él controla (directa o indirectamente).

persona(Persona):- guardia(Persona).
persona(Persona):- prisionero(Persona, _).

hayControl(Capo, Persona):- controla(Capo, Persona).
hayControl(Capo, Persona):- controla(Capo, Tercero), hayControl(Tercero, Persona).

capoDiTutiLiCapi(Capo):-
    prisionero(Capo, _),
    not(controla(_, Capo)),
    forall((persona(Persona), Persona /= Capo), hayControl(Capo, Persona)).
    