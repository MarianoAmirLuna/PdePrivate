%atiende(Kioskero, Dia, HoraComienzo, HoraFin).
atiende(dodain,     lunes,   9, 15).
atiende(dodain, miercoles,   9, 15).
atiende(dodain,   viernes,   9, 15).
atiende(lucas ,    martes,  10, 20).
atiende(juanC ,    sabado,  18, 22).
atiende(juanC ,   domingo,  18, 22).
atiende(juanF ,    jueves,  10, 20).
atiende(juanF ,   viernes,  12, 20).
atiende(leoC  ,     lunes,  14, 18).
atiende(leoC  , miercoles,  14, 18).
atiende(martu , miercoles,  23, 24).

%%% 1 %%%
atiende(vale  , Dia, HoraComienzo, HoraFin):- atiende(dodain, Dia, HoraComienzo, HoraFin).
atiende(vale  , Dia, HoraComienzo, HoraFin):- atiende(juanC , Dia, HoraComienzo, HoraFin).

kioskero(K):- atiende(K, _,  _, _).

%%% 2 %%%
quienAtiende(Dia, Hora, Kioskero):-
    atiende(Kioskero, Dia, HoraComienzo, HoraFin),
    between(HoraComienzo, HoraFin, Hora).

%%% 3 %%%
foreverAlone(Dia, Hora, Kioskero):-
    kioskero(Kioskero), kioskero(OtroKioskero),
    quienAtiende(Dia, Hora, Kioskero),
    Kioskero \= OtroKioskero,
    not(quienAtiende(Dia, Hora, OtroKioskero)).

%%% 4 %%%
atiende(Dia, Kioskero):-
    atiende(Kioskero, Dia, _, _).

%%% 5 %%%

vendio(dodain, fecha(10, agosto), [golosinas(1200), cigarros([jockey]), golosinas(50)]).
vendio(dodain, fecha(12, agosto), [bebida(true, 8 ), bebida(false, 1), golosinas(10)]).
vendio(martu , fecha(12, agosto), [golosinas(1000), cigarros([chesterfield, colorado, parisiennes])]).
vendio(lucas , fecha(11, agosto), [golosinas(600)]).
vendio(lucas , fecha(18, agosto), [bebida(false, 2 ), cigarros([derby])]).

suertuda(Vendedor):-
    vendio(Vendedor, _, _),
    forall(vendio(Vendedor, _, [Venta|_]), esImportante(Venta)).

esImportante(golosinas(Cantidad)):- Cantidad > 100.
esImportante(bebida(true , _       )).
esImportante(bebida(false, Cantidad)):- Cantidad > 5.
esImportante(cigarros(Marcas)):- length(Marcas, Cantidad), Cantidad > 2.
