tasacion(juan, 150000).
tasacion(nico, 80000).
tasacion(alf, 75000).
tasacion(julian, 140000).
tasacion(vale, 95000).
tasacion(fer, 60000).

%EXPLOCION COMBINATORIA%
sublista([], []).
sublista([_|Cola], Sublista):-                  sublista(Cola, Sublista).
sublista([Cabeza|Cola], [Cabeza|Sublista]):-    sublista(Cola, Sublista).
%EXPLOCION COMBINATORIA%

sePuedeComprar(Dinero, Propiedades, Vuelto):-
    findall(P, (tasacion(P, C), C =< Dinero), LP),
    sublista(LP, Propiedades),
    length(Propiedades, Cant),
    Cant > 0,
    findall(C, (member(P, Propiedades), tasacion(P, C)), LC),
    sumlist(LC, Total),
    Total < Dinero,
    Vuelto is Dinero - Total.
%   Claramente se puede abstraer muchas cosas pero en esencia (7 PALABRAS) es esto,
%puede parece mal debido a que hay 2 findall, peron en el recuperatorio se dijo explicitamente
%que habia que hacer 1 findall, 1 sublista, 1 findall, 1 sumlist. Yo idee esta solucion y me da las respuestas
%correctas