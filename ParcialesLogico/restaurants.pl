restaurante(panchoMayo , 2, barracas   ).
restaurante(finoli     , 3, villaCrespo).
restaurante(superFinoli, 5, villaCrespo).

%carta(Precio, Plato).
%pasos(Pasos , Precio, Vinos, Comensales).
menu(panchoMayo , carta(1000, pancho     )).
menu(panchoMayo , carta( 200, hamburguesa)).
menu(finoli     , carta(2000, hamburguesa)).
menu(finoli     , pasos(15, 15000, [chateauMessi, francescoliSangiovese, susanaBalboaMalbec], 6)).
menu(noTanFinoli, pasos( 2,  3000,                                     [guinoPin, juanaDama], 3)).

%vino(Vino, PaísDeOrigen, CostoPorBotella).
vino( chateauMessi            , francia  , 5000).
vino( francescoliSangiovese   , italia   , 1000).
vino( susanaBalboaMalbec      , argentina, 1200).
vino( christineLagardeCabernet, argentina, 5200).
vino( guinoPin                , argentina, 500 ).
vino( juanaDama               , argentina, 1000).

restauranteEstrellasMayorA(Restaurante, CantStar, Barrio):-
    restaurante(Restaurante, Stars, Barrio),
    Stars >= CantStar.

restauranteSinStars(Restaurante):-
    menu(Restaurante     , _),
    not(restaurante(Restaurante, _, _)).

estaMalOrganizado(Restaurante):-
    menu(Restaurante , Menu),
    menuMalOrganizado(Restaurante , Menu).

menuMalOrganizado(Restaurante, carta(Precio, Plato)):-
    menu(Restaurante , carta(OtroPrecio, Plato)),
    OtroPrecio \= Precio.

menuMalOrganizado(_, pasos(Pasos , _, Vinos, _)):-
    length(Vinos, CantVinos),
    CantVinos < Pasos.

esCopiaBarata(RestauranteO, RestauranteB):-
    esRestaurante(RestauranteO),    esRestaurante(RestauranteB),
    forall(platoALaCartaDe(RestauranteO, Plato, PrecioC), (platoALaCartaDe(RestauranteB, Plato, PrecioB), PrecioC > PrecioB)),
    tieneMenosEstrellas(RestauranteB, RestauranteO).

platoALaCartaDe(Restaurante, Plato, Precio):-
    menu(Restaurante, carta(Precio, Plato)).

tieneMenosEstrellas(Restaurante1, Restaurante2):-
    restaurante(Restaurante1, Estrellas1, _),
    restaurante(Restaurante2, Estrellas2, _),
    Estrellas1 < Estrellas2.

esRestaurante(Restaurante):-    menu(Restaurante , _).

precioPromedioPorPersona(Restaurante, PrecioPromedio):-
    esRestaurante(Restaurante),
    findall(Precio, (menu(Restaurante, Menu), precioPromedio(Menu, Precio)), ListaDePrecios),
    length(ListaDePrecios, CantPrecios),
    sumlist(ListaDePrecios, PrecioTotal),
    PrecioPromedio is (PrecioTotal/CantPrecios).

precioPromedio(carta(Precio, _), Precio).
precioPromedio(pasos(_ , Precio, Vinos, Comensales), PrecioFinal):-
    precioDeLosVinos(Vinos, PrecioVino),
    PrecioFinal is (Precio + PrecioVino)/Comensales.

precioDeLosVinos([], 0).
precioDeLosVinos([Vino|Cola], PrecioVino):-
    vino(Vino, PaisDeOrigen, CostoPorBotella),
    impuesto(CostoPorBotella, PaisDeOrigen, PrecioFinal),
    precioDeLosVinos(Cola, PrecioCola),
    PrecioVino is PrecioFinal + PrecioCola.

impuesto(Costo, argentina, Costo).
impuesto(Costo, Pais, PrecioFinal):-
    Pais \= argentina,
    PrecioFinal is Costo * 1.35.