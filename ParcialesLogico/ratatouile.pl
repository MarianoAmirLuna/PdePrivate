rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa]) ).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

inspeccionSatisfactoria(Restaurante):-
    trabajaEn(Restaurante, _),
    not(rata(_, Restaurante)).

chef(Empleado, Reastaurante):-
    trabajaEn(Reastaurante, Empleado),
    cocina(Empleado, _, _).

chefcito(Rata):-
    rata(Rata, Restaurante),
    trabajaEn(Restaurante, linguini).

cocinaBien(Persona, Plato):-
    cocina(Persona, Plato, Experiencia),
    Experiencia > 7.

encargadoDe(Encargado, Plato, Reastaurante):-
    cocina(Encargado, Plato, MayorNivel),
    forall(restoDeCocineros(Encargado, Plato, Reastaurante, SusNiveles), SusNiveles < MayorNivel).

restoDeCocineros(Encargado, Plato, Restaurante, NivelesInferiores):-
    cocina(OtroCocinero, Plato, NivelesInferiores),
    Encargado /= OtroCocinero,
    trabajaEn(Restaurante, OtroCocinero).

saludable(Plato):-
    plato(Plato, entrada(Ingredientes)),
    length(Ingredientes, CantIngredientes),
    CantIngredientes * 15 < 75.

saludable(Plato):-
    plato(Plato, principal(Guarnicion, Coccion)),
    minutosSinGuarnicion(Guarnicion, CoccionGuarnicion),
    (Coccion - CoccionGuarnicion) * 5 < 75.

minutosSinGuarnicion(pure, 20).
minutosSinGuarnicion(papasFritas, 50).
minutosSinGuarnicion(ensalada, 0).

saludable(Plato):-
    plato(Plato, postre(Calorias)),
    Calorias < 75.

grupo(frutillasConCrema).

saludable(Plato):-
    plato(Plato, postre(Calorias)),
    grupo(Nombre),
    Nombre = Plato.

% Con forall se pueden mejorar algunos puntos

criticaPositiva(Restaurante, Critico):-
    inspeccionSatisfactoria(Reastaurante),
    cumpleElCriterio(Critico, Restaurante).

cumpleElCriterio(antonEgo, Restaurante):-
    trabajaEn(Restaurante, Empleado),
    cocinaBien(Empleado, ratatouille).

cumpleElCriterio(christophe, Restaurante):-
    trabajaEn(Restaurante, Empleado1),
    trabajaEn(Restaurante, Empleado2),
    trabajaEn(Restaurante, Empleado3),
    Empleado1 /= Empleado2 /= Empleado3.

cumpleElCriterio(cormillot, Restaurante):-
    trabajaEn(Restaurante, Empleado),
    cocina(Empleado, Plato, _),
    saludable(Plato),
    forall(esEntrada(Plato), contieneZanahoria(Plato)).

esEntrada(Plato):- plato(Plato, entrada(_)).

contieneZanahoria(Plato):-
    plato(Plato, entrada(ListaDeIngredientes)),
    member(zanahoria, ListaDeIngredientes).