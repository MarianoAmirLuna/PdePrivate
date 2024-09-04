% jugador(Nombre, ListaDeItems, NivelDeHambre).
jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 8).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, pollo, pollo], 8).

% lugar(Bioma, ListaDeJugadores, NivelDeOscuridad).
lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

% comestible(comida).
comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

% #####
% ##1##
% #####

% a. relaciona un jugador con un item que posee. tieneItem/2
tieneItem(Jugador, Item):-
    jugador(Jugador, ListaDeItems, _),
    member(Item, ListaDeItems).

%b. saber si un jugador se preocupa por su salud, esto es si
%   tiene entre sus items más de un tipo de comestible.
%   (Tratar de resolver sin findall) sePreocupaPorSuSalud/1
sePreocupaPorSuSalud(Jugador):-
    comestible(Comida1),
    comestible(Comida2),
    Comida1 \= Comida2,
    tieneItem(Jugador, Comida1),
    tieneItem(Jugador, Comida2).

%c. Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), y la cantidad
%   que tiene de ese ítem. Si no posee el ítem, la cantidad es 0. cantidadDeltem/3
esJugador(J):- jugador(J, _, _).
existeItem(I):- tieneItem(_, I).

% Si el jugador tiene el ítem, cuenta cuántos tiene
cantidadDelItem(Jugador, Item, CantItem) :-
    esJugador(Jugador),
    existeItem(Item),
    cuantosItems(Jugador, Item, CantItem).

% Cuenta cuántas veces aparece el ítem en la lista de ítems del jugador
cuantosItems(Jugador, Item, 0) :-
    jugador(Jugador, ItemsDelJugador, _),
    not(member(Item, ItemsDelJugador)).

cuantosItems(Jugador, Item, CantItem) :-
    jugador(Jugador, ItemsDelJugador, _),
    findall(Item, member(Item, ItemsDelJugador), Lista),
    length(Lista, CantItem).

%d. Relacionar un jugador con un ítem, si de entre todos los jugadores, es el que más cantidad
%   tiene de ese ítem. tieneMasDe/2

tieneMasDe(Jugador, Item):-
    cantidadDelItem(Jugador, Item, CantItem1),
    forall((cuantosItems(OtroJugador, Item, CantItem2), OtroJugador /= Jugador), CantItem2 < CantItem1).

% #####
% ##2##
% #####

/*
a. Obtener los lugares en los que hay monstruos. Se sabe que los
monstruos aparecen en los lugares cuyo nivel de oscuridad es mas de 6.
hayMonstruos/1
*/

hayMonstruos(Bioma):-
    lugar(Bioma, _, NivelDeOscuridad),
    NivelDeOscuridad > 6.

/*
b. Saber si un jugador corre peligro. Un jugador corre peligro si se
encuentra en un lugar donde hay monstruos; o si esta hambriento
(hambre < 4) y no cuenta con ítems comestibles. correPeligro/1
*/

correPeligro(Jugador):-
    hayMonstruos(Bioma),
    lugar(Bioma, ListaDeJugadores, _),
    member(Jugador, ListaDeJugadores).

estaHambriento(Jugador):-
    jugador(Jugador, ListaDeItems, NivelDeHambre),
    NivelDeHambre < 4.

correPeligro(Jugador):-
    estaHambriento(Jugador),
    comestible(Comida),
    not(tieneItem(Jugador, Comida)).

/*
c. Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
- Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
- Si hay monstruos, es 100.
- Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad *
10. nivelPeligrosidad/2

?- nivelPeligrosidad (playa, Peligrosidad).
Peligrosidad = 50.
*/

porcentajePeligrosidad(ListaDeJugadores, Nivel):-
    findall(Jugador, (member(Jugador, ListaDeJugadores), estaHambriento(Jugador)), ListaDeHambrientos),
    length(ListaDeJugadores, PoblacionTotal),
    length(ListaDeHambrientos, Hambrientos),
    Nivel is (Hambrientos * 100) / PoblacionTotal. 
    
nivelPeligrosidad(Bioma, Nivel):-
    not(hayMonstruos(Bioma)),
    lugar(Bioma, ListaDeJugadores, _),
    porcentajePeligrosidad(ListaDeJugadores, Nivel).

nivelPeligrosidad(Bioma, 100):-
    hayMonstruos(Bioma).

nivelPeligrosidad(Bioma, Nivel):-
    lugar(Bioma, [], NivelDeOscuridad),
    Nivel is NivelDeOscuridad * 10.

% #####
% ##3##
% #####

/*
El aspecto mas popular del juego es la construccion. Se pueden construir nuevos ítems a partir
de otros, cada uno tiene ciertos requisitos para poder construirse:

    -Puede requerir una cierta cantidad de un ítem simple, que es
    aquel que el jugador tiene o puede recolectar. Por ejemplo, 8
    unidades de piedra.

    -Puede requerir un ítem compuesto, que se debe construir a
    partir de otros (una única unidad).

Con la siguiente informacion, se pide relacionar un jugador
con un ítem que puede construir. puedeConstruir/2


?- puedeConstruir (stuart, horno).
true.
?- puedeConstruir (steve, antorcha).
true.

Aclaracion: Considerar a los componentes de los ítems compuestos y a los items simples como
excluyentes, es decir no puede haber mas de un ítem que requiera el mismo elemento.
*/

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item (palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

puedeConstruir(Jugador, ItemAConstruir):-
    esJugador(Jugador),
    item(ItemAConstruir, Receta),
    forall(member(Item, Receta), dispone(Jugador, Item)).

dispone(Jugador, itemSimple(Item, Cantidad)):-
    cuantosItems(Jugador, Item, CantItem),
    CantItem >= Cantidad.

dispone(Jugador, itemCompuesto(Item)):-
    puedeConstruir(Jugador, Item).

loTieneOLoPuedeConstruir(Elemento) :- tieneItem(Jugador, Elemento).
loTieneOLoPuedeConstruir(Elemento) :-
    esJugador(Jugador),
    not(tieneItem(Jugador, Elemento)),
    puedeConstruir(Jugador, Elemento).