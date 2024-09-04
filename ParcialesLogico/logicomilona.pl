%   receta(Plato, Duracion, Ingredientes).
receta(empanadaDeCarneFrita, 20, [harina, carne, cebolla, picante, aceite]).
receta(empanadaDeCarneAlHorno, 20, [harina, carne, cebolla, picante]).
receta(lomoALaWellington, 125, [lomo, hojaldre, huevo, mostaza]).
receta(pastaTrufada, 40, [spaghetti, crema, trufa]).
receta(souffleDeQueso, 35, [harina, manteca, leche, queso]).
receta(tiramisu, 30, [vainillas, cafe, mascarpone]).
receta(rabas, 20, [calamar, harina, sal]).
receta(parriladaDelMar, 40, [salmon, langostino, mejillones]).
receta(sushi, 30, [arroz, salmon, sesamo, algaNori]).
receta(hamburguesa, 15, [carne, pan, cheddar, huevo, paneta, trufa]).
receta(padThai, 40, [fideos, langostino, vegetales]).

% elabora(Chef, Plato) 
elabora(guille, empanadaDeCarneFrita). 
elabora(guille, empanadaDeCarneAlHorno). 
elabora(vale, rabas). 
elabora(vale, tiramisu). 
elabora(vale, parrilladaDelMar). 
elabora(ale, hamburguesa). 
elabora(lu, sushi). 
elabora(mar, padThai). 
 
% cocinaEn(Restaurante, Chef) 
cocinaEn(pinpun, guille). 
cocinaEn(laPececita, vale). 
cocinaEn(laParolacha, vale). 
cocinaEn(sushiRock, lu). 
cocinaEn(olakease, lu). 
cocinaEn(guendis, ale). 
cocinaEn(cantin, mar).

% tieneEstilo(Restaurante, Estilo) 
tieneEstilo(pinpun, bodegon(parqueChas, 6000)). 
tieneEstilo(laPececita, bodegon(palermo, 20000)). 
tieneEstilo(laParolacha, italiano(15)). 
tieneEstilo(sushiRock, oriental(japon)). 
tieneEstilo(olakease, oriental(japon)). 
tieneEstilo(cantin, oriental(tailandia)). 
tieneEstilo(cajaTaco, mexicano([habanero, rocoto])). 
tieneEstilo(guendis, comidaRapida(5)).

%1.

esCrack(Chef):-
    elabora(Chef, padThai).

esCrack(Chef):-
    cocinaEn(Restaurante1, Chef),
    cocinaEn(Restaurante2, Chef),
    Restaurante1 \= Restaurante2.

%2.

chef(Chef):-
    elabora(Chef, _).

esOtaku(Chef):-
    chef(Chef),
    forall(cocinaEn(Restaurante, Chef), tieneEstilo(Restaurante, oriental(japon))).

%3.

plato(Plato):-
    elabora(_, Plato).

esTop(Plato):-
    plato(Plato),
    forall(elabora(Chef, Plato), esCrack(Chef)).

%4.

esDificil(souffleDeQueso).

esDificil(Plato):-
    receta(Plato, _, Ingredientes),
    member(trufa, Ingredientes).

esDificil(Plato):-
    receta(Plato, Duracion, _),
    Duracion > 120.

%5.

seMereceLaMichelin(Restaurante):-
    cocinaEn(Restaurante, Chef),
    esCrack(Chef),
    esMichelinero(Restaurante).

esMichelinero(Restaurante):-
    tieneEstilo(Restaurante, oriental(tailandia)). 

esMichelinero(Restaurante):-
    tieneEstilo(Restaurante, bodegon(palermo, _)). 

esMichelinero(Restaurante):-
    tieneEstilo(Restaurante, italiano(CantPastas)),
    CantPastas > 5.

esMichelinero(Restaurante):-
    tieneEstilo(Restaurante, mexicano(Ajies)),
    michelinMexicano(Ajies).

michelinMexicano(Ajies):-
    member(aji, Ajies),
    member(habanero, Ajies),
    member(rocoto, Ajies).

%6.
tieneMayorRepertorio(Restaurante1, Restaurante2):-
    cocinaEn(Restaurante1, Chef1),
    cocinaEn(Restaurante2, Chef2),
    elaboraMasPlatos(Chef1, Chef2).

% elabora(Chef, Plato) 
elaboraMasPlatos(Chef1, Chef2):-
    cantidadDePlatosElaborados(Chef1, Cantidad1),
    cantidadDePlatosElaborados(Chef2, Cantidad2)
    Cantidad1 > Cantidad2.

cantidadDePlatosElaborados(Chef, Cantidad):-
    findall(Plato, elabora(Chef, Plato), Platos),
    length(Platos, Cantidad).

%7.
calificacionGastronomica(Restaurante, Calificacion):-
    cocinaEn(Restaurante, Chef),
    cantidadDePlatosElaborados(Chef, Cantidad),
    Calificacion is 5 * Cantidad.