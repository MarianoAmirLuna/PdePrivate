%jockey(Nombre, Altura, Peso).
jockey(valdivieso, 155, 52).
jockey(leguisamo , 161, 49).
jockey(lezcano  , 149, 50).
jockey(baratucci , 153, 55).
jockey(falero    , 157, 52).

esJockey(Nombre):- jockey(Nombre, _, _).

%caballeria(Jockey, Caballeria).
caballeria(valdivieso, elTute     ).
caballeria(falero    , elTute     ).
caballeria(baratucci , elCharabon ).
caballeria(leguisamo , elCharabon ).
caballeria(leszcano  , lasHormigas).

%ganoPremio(Caballo, Premio).
ganoPremio(botafogo, nacional    ).
ganoPremio(botafogo, republica   ).
ganoPremio(oldMan  , republica   ).
ganoPremio(oldMan  , palermoDeOro).
ganoPremio(matBoy  , criadores   ).

%leGusta(Caballo, Jockey).
leGusta(botafogo, baratucci).
leGusta(botafogo, Jockey   ):- jockey(Jockey, _, Peso), Peso < 52.
leGusta(oldMan  , Jockey   ):- personaDeMuchasLetras(Jockey).
leGusta(matBoy  , Jockey   ):- jockey(Jockey, Altura, _), Altura > 170.
leGusta(energica, Jockey   ):- esJockey(Jockey), not(leGusta(botafogo, Jockey)).

personaDeMuchasLetras(Jockey    ):-
    esJockey(Jockey             ),
    atom_length(Jockey, Length  ),
    Length > 7.

masDeUnJockey(Caballo):- 
    leGusta(Caballo, Jockey1),
    leGusta(Caballo, Jockey2),
    Jockey1 \= Jockey2.

esPiolin(Jockey):-
    esJockey(Jockey),
    forall(ganoPremioImportante(Caballo), leGusta(Caballo, Jockey)).

ganoPremioImportante(Caballo):-
    ganoPremio(Caballo, Premio),
    esImportante(Premio).

esImportante(nacional ).
esImportante(republica).

ganador(Caballo):-
    resultado(Caballo, primero).

segundo(Caballo):-
    resultado(Caballo, primero).

segundo(Caballo):-
    resultado(Caballo, segundo).

exacta(Caballo1, Caballo2):-
    resultado(Caballo1, primero),
    resultado(Caballo2, segundo).

imperfecta(Caballo1, Caballo2):-
    exacta(Caballo1, Caballo2),
    exacta(Caballo2, Caballo1).
