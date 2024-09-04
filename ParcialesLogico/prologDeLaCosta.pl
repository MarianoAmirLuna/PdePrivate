%   Enunciado: https://docs.google.com/document/d/107Nr9xqhqGqGBLCqv-VKJR3wQAoGj131YBe7ygzJ7EY/edit

%visitante(Nombre, Dinero, Edad).
%pertenece(Nombre, GrupoFamiliar).
%seSiente(Nombre, Hambre, Aburrimiento).

visitante(eusebio, 3000, 80).
visitante(carmela, 0, 80 ).
visitante(carlos, 25000, 25).
visitante(melisa, 35000, 35).

seSiente(eusebio, 50, 0).
seSiente(carmela, 0, 25).
seSiente(carlos, 5, 0).
seSiente(melisa, 20, 5).

pertenece(eusebio, viejitos).
pertenece(carmela, viejitos).
pertenece(carlos, solitarios).
pertenece(melisa, solitarios).


esVisitante(Nombre):-
    visitante(Nombre, _, _).

esMenor(Nombre):-
    visitante(Nombre, Edad, _),
    Edad < 13.

comida(hamburguesa, 2000).
comida(panchoyPapas, 1500).
comida(lomito, 2500).
comida(caramelos, 0).

atraccion(autitosChocadores, tranquila(adultosYchicos)).
atraccion(casaEmbrujada, tranquila(adultosYchicos)).
atraccion(laberinto, tranquila(adultosYchicos)).
atraccion(tobogan, tranquila(chicos)).
atraccion(calesita, tranquila(chicos)).

atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador3D, intensa(2)).

atraccion(abismoMortalRecargada, montaniaRusa(3, 134)).
atraccion(paseoPorElBosque, montaniaRusa(0, 45)).

atraccion(elTorpedoSalpicon, acuatica).
atraccion(esperoQueHayasTraidoUnaMudaDeRopa, acuatica).

esVerano(septiembre).
esVerano(octubre).
esVerano(noviembre).
esVerano(diciembre).
esVerano(enero).
esVerano(febrero).
esVerano(marzo).

/*
2. Saber el estado de bienestar de un visitante.
    -Si su hambre y aburrimiento son 0, siente felicidad plena.
    -Si suman entre 1 y 50, podría estar mejor.
    -Si suman entre 51 y 99, necesita entretenerse.
    -Si suma 100 o más, se quiere ir a casa.

Hay una excepción para los visitantes que vienen solos al parque:
nunca pueden sentir felicidad plena, sino que podrían estar mejor también cuando su hambre y aburrimiento suman 0.
*/

felicidadPlena(Visitante):-
    seSiente(Visitante, 0, 0),
    not(pertenece(Visitante, solitarios)).

couldBeBetter(Visitante):-
    pertenece(Visitante, solitarios),
    seSiente(Visitante, 0, 0).

couldBeBetter(Visitante):-
    sentimientosEntre(Visitante, 1, 50).

necesitaEntretenerse(Visitante):-
    sentimientosEntre(Visitante, 51, 99).

seQuiereIrACasa(Visitante):-
    sentimientosEntre(Visitante, 100, 999).

sentimientosEntre(Visitante, Min, Max):-
    seSiente(Visitante, Hambre, Aburrimiento),
    between(Min, Max, Hambre + Aburrimiento).

/*
3.  Saber si un grupo familiar puede satisfacer su hambre con cierta comida.
    Para que esto ocurra, cada integrante del grupo debe tener dinero suficiente
    como para comprarse esa comida y esa comida, a la vez, debe poder quitarle el
    hambre a cada persona. La hamburguesa satisface a quienes tienen menos de 50
    de hambre; el panchito con papas sólo le quita el hambre a los chicos; y el
    lomito completo llena siempre a todo el mundo. Los caramelos son un caso
    particular: sólo satisfacen a las personas que no tienen dinero suficiente
    para pagar ninguna otra comida.
*/

esComida(Comida):-
    comida(Comida, _).

unGrupo(Grupo):-
    pertenece(_, Grupo).

puedeSatisfacer(Grupo, Comida) :-
    esComida(Comida),
    unGrupo(Grupo),
    forall(pertenece(Visitante, Grupo), (satisface(Comida, Visitante), puedePagarse(Visitante, Comida))).

satisface(hamburguesa, Visitante):-
    seSiente(Visitante, Hambre, _),
    Hambre < 50.

satisface(panchoyPapas, Visitante):-
    esMenor(Visitante).

satisface(lomito, _).

satisface(caramelos, Visitante):-
    visitante(Visitante, Dinero, _),
    Dinero < 2000.

puedePagarse(Visitante, Comida):-
    comida(Comida, Precio),
    visitante(Visitante, Plata, _ ),
    Plata > Precio.

/*
4.  Saber si puede producirse una lluvia de hamburguesas. Esto ocurre para
    un visitante que puede pagar una hamburguesa al subirse a una atracción que:
    -Es intensa con un coeficiente de lanzamiento mayor a 10, o
    -Es una montaña rusa peligrosa, o
    -Es el tobogán

    La peligrosidad de las montañas rusas depende de la edad del visitante.
    Para los adultos sólo es peligrosa la montaña rusa con mayor cantidad
    de giros invertidos en todo el parque, a menos que el visitante necesite
    entretenerse, en cuyo caso nada le parece peligroso. El criterio cambia
    para los chicos, donde independientemente de la cantidad de giros
    invertidos, los recorridos de más de un minuto de duración alcanzan para
    considerarla peligrosa.
*/
lluviaDeHamburguesa(Visitante, Atraccion):-
    puedePagarse(Visitante, hamburguesa),
    puedeSubir(Visitante, Atraccion).

puedeSubir(_, tobogan).

puedeSubir(_, Atraccion):-
    atraccion(Atraccion, intensa(CoeficienteDeLanzamiento)),
    CoeficienteDeLanzamiento > 10.

puedeSubir(Visitante, Atraccion):-
    esUnaMoniaRusaPeligrosa(Atraccion, Visitante).

esUnaMoniaRusaPeligrosa(Atraccion, Visitante):-
    esMenor(Visitante),
    atraccion(Atraccion, montaniaRusa(_, Tiempo)),
    Tiempo > 60.

esUnaMoniaRusaPeligrosa(Atraccion, Visitante):-
    atraccion(Atraccion, montaniaRusa(MayoresGiros, _)),
    forall((atraccion(Nombre, montaniaRusa(Giros, _)), Nombre \= Atraccion), MayoresGiros >= Giros),
    not(esMenor(Visitante)),
    not(necesitaEntretenerse(Visitante)).

/*
5.   Saber, para cada mes, las opciones de entretenimiento para un visitante.
     Esto debe incluir todos los puestos de comida en los cuales tiene dinero
    para comprar, todas las atracciones tranquilas a las que puede acceder
    (dependiendo su franja etaria), todas las atracciones intensas, todas las
    montañas rusas que no le sean peligrosas, y por último todas las atracciones
    acuáticas, siempre y cuando el mes de visita coincida con los meses de apertura.
     El resto de las atracciones están abiertas todo el año.
     Finalmente, una atracción tranquila exclusiva para chicos también puede ser
    opción de entretenimiento para un visitante adulto en el caso en que en el grupo
    familiar haya un chico a quien acompañar.

*/

opcionesDeEntretenimiento(Visitante, _, Opcion):-
    visitante(Visitante, Dinero, _),
    puedeComprar(Dinero, Opcion).

opcionesDeEntretenimiento(Visitante, _, Opcion):-
    franjaEtaria(Visitante, Opcion).

opcionesDeEntretenimiento(_, _, Opcion):-
    atraccion(Opcion, intensa(_)).

opcionesDeEntretenimiento(Visitante, _, Opcion):-
    esVisitante(Visitante),
    atraccion(Opcion, montaniaRusa(_, _)),
    not(esUnaMoniaRusaPeligrosa(Opcion, Visitante)).

opcionesDeEntretenimiento(_, Mes, Opcion):-
    esVerano(Mes),
    atraccion(Opcion, acuatica).

franjaEtaria(Visitante, Opcion):-
    esVisitante(Visitante),
    not(esMenor(Visitante)),
    atraccion(Opcion, tranquila(adultosYchicos)).

franjaEtaria(Visitante, Opcion):-
    esMenor(Visitante),
    atraccion(Opcion, tranquila(chicos)).

franjaEtaria(Visitante, Opcion):-
    not(esMenor(Visitante)),
    pertenece(Visitante, Grupo),
    pertenece(OtroVisitante, Grupo),
    esMenor(OtroVisitante),
    atraccion(Opcion, tranquila(chicos)).

puedeComprar(Dinero, Comida):-
    comida(Comida, Precio),
    Dinero > Precio.
