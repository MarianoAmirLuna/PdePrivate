trabaja(dodain, turno(lunes, 9, 15)).
trabaja(dodain, turno(miercoles, 9, 15)).
trabaja(dodain, turno(viernes, 9, 15)).
trabaja(lucas, turno(martes, 10, 20)).
trabaja(juanC, turno(sabado, 18, 22)).
trabaja(juanC, turno(domingo, 18, 22)).
trabaja(juanFdS, turno(jueves, 10, 20)).
trabaja(juanFdS, turno(viernes, 12, 20)).
trabaja(leoC, turno(miercoles, 14, 18)).
trabaja(leoC, turno(lunes, 14, 18)).
trabaja(martu, turno(miercoles, 23, 24)).

trabaja(vale, Turno):-
    trabaja(dodain, Turno).

trabaja(vale, Turno):-
    trabaja(juanC, Turno).

esLaburador(Alguien):-
    trabaja(Alguien, _).

trabaja(Alguien, Turno):-
    esLaburador(Alguien),
    not(trabaja(leoC, Turno)).

% Malu al pensar y no estar trabajando no se la relaciona con ningun horario.

atiende(Dia, Hora, Trabajador):-
    trabaja(Trabajador, turno(Dia, HoraTemprana, HoraTardia)),
    between(HoraTemprana, HoraTardia, Hora).

atiendeSolo(Dia, Hora, Trabajador):-
    atiende(Dia, Hora, Trabajador),
    esLaburador(OtroTrabajador),
    Trabajador \= OtroTrabajador,
    not(atiende(Dia, Hora, OtroTrabajador)).

posibleAtencion(Dia, Trabajador):-
    atiende(Dia, _, Trabajador).

ventas(dodain, [golosinas(1200), cigarrillos([jockey]), golosinas(50)], fecha(lunes, 10, agosto)).
ventas(dodain, [bebidas(8, alcoholica), bebidas(1, noAlcoholica), golosinas(10)], fecha(miercoles, 12, agosto)).

ventas(martu, [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])], fecha(miercoles, 12, agosto)).

ventas(lucas, [golosinas(600)], fecha(martes, 11, agosto)).
ventas(lucas, [bebidas(2, noAlcoholica), cigarrillos([derby])], fecha(martes, 18, agosto)).

vendedorSuertudo(Vendedor):-
    esVendedor(Vendedor),
    forall(ventas(Vendedor, ListaDeVentas, Fecha), primeraVentaImportante(ListaDeVentas)).

esVendedor(Vendedor):-
    ventas(Vendedor, _, _).

primeraVentaImportante(ListaDeVentas):-
    member(Venta, ListaDeVentas),
    esImportante(Venta).

esImportante(golosinas(Precio)):-
    Precio > 100.

esImportante(cigarrillos(ListaDePuchos)):-
    length(ListaDePuchos, Cantidad),
    Cantidad > 2.

esImportante(bebidas(_, alcoholica)).

esImportante(bebidas(Cantidad, _)):-
    Cantidad > 5.
