rata(remy  , gusteaus).
rata(emile , malabar ).
rata(django, jeSuis  ).

sabeCocinar(linguini, ratatouile  , 3).
sabeCocinar(linguini, sopa        , 5).
sabeCocinar(colette , salmonAsado , 9).
sabeCocinar(horst   , ensaladaRusa, 8).

trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette ).
trabajaEn(gusteaus, horst   ).
trabajaEn(cafeDes2Moulins, amelie).

esRestaurante(R):- trabajaEn(R, _).
rata(Rata):-       rata(Rata  , _).
cocinero(C):-      trabajaEn(_, C).
cocinero(C):-      sabeCocinar(C, _, _).

%%% 1 %%%
inspeccionSatisfactoria(Restaurante):-
    esRestaurante(Restaurante),
    not(rata(_, Restaurante)).

%%% 2 %%%
chef(Empleado, Restaurante):-
    trabajaEn(Restaurante, Empleado),
    sabeCocinar(Restaurante, _, _).

%%% 3 %%%
chefcito(Rata):-
    trabajaEn(Restaurante, linguini),
    rata(Rata, Restaurante).

%%% 4 %%%
cocinaBien(remy, _).
cocinaBien(Chef, Plato):-
    sabeCocinar(Chef, Plato, Puntaje),
    Puntaje > 7.

%%% 5 %%%
encargadoDe(Chef, Plato, Restaurante):-
    trabajaEn(Restaurante, Chef),
    sabeCocinar(Chef, Plato, Exp).
    forall((trabajaEn(Restaurante, Ayudante), sabeCocinar(Ayudante, Plato  , ExpAyudante)), ExpAyudante <= Exp).

%%%%%%
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).
%%%%%%

%%% 6 %%%
saludable(Plato):-
    calorias(Plato, Calorias),
    calorias < 75.

calorias(Plato, Calorias):-
    plato(Plato, entrada(Ingredientes)),
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.

calorias(Plato, Calorias):-
    plato(Plato, principal(Guarnicion, Minutos)),
    caloriasDeGuarnicion(Guarnicion, CalGuar),
    Calorias is Minutos * 5 + CalGuar.

calorias(Plato, Calorias):-
    plato(Plato, postre(Calorias)).

caloriasDeGuarnicion(papasFritas, 50).
caloriasDeGuarnicion(pure       , 20).
caloriasDeGuarnicion(Guarnicion ,  0):-
    Guarnicion \= papasFritas,
    Guarnicion \= pure.

%%% 7 %%%
criticaPositiva(Restaurante, Critico):-
    inspeccionSatisfactoria(Restaurante),
    reseniaPositiva(Restaurante, Critico).

reseniaPositiva(Restaurante, antonEgo):-
    especialistaEn(Restaurante, ratatouile).

reseniaPositiva(Restaurante, cormillot):-
    forall((trabajaEn(Restaurante, Empleado), sabeCocinar(Empleado, Plato, _)), esSaludable(Plato)).

reseniaPositiva(Restaurante, christophe):-
    findall(Empleado, trabajaEn(Restaurante, Empleado), ListaDeEmpleado).
    length(ListaDeEmpleado, Cantidad),
    Cantidad > 3.

especialistaEn(Restaurante, Plato):-
    forall(trabajaEn(Restaurante, Empleado), cocinaBien(Empleado, Plato)).

esSaludable(Plato):-
    saludable(Plato),
    not(esEntrada(Plato)).

esSaludable(Plato):-
    saludable(Plato),
    tieneZanahoria(Plato).

esEntrada(Plato):-
    plato(Plato, entrada(_)).

tieneZanahoria(Plato):-
    plato(Plato, entrada(Ingredientes)),
    member(zanahoria, Ingredientes).