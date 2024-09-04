%%% Enunciado: https://docs.google.com/document/d/1Tvfqdj4N23O5NGJbbdBQGiDgMssnKvnhv0e4wkHvUpk/edit

% esPersonaje/1 nos permite saber qué personajes tendrá el juego
esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).
esPersonaje(bumi).
esPersonaje(suki).

% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes

esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado

elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla

controla(bumi, tierra).
controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).

% visito/2 relaciona un personaje con un lugar que visitó. Los lugares son functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)

visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).
visito(pepe, tribuAgua(sur)).
visito(pepe, temploAire(sur)).
visito(juan, tribuAgua(sur)).
visito(juan, temploAire(sur)).
visito(bumi, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(suki, nacionDelFuego(prisionDeMaximaSeguridad, 200)).

% 1. saber qué personaje esElAvatar. El avatar es aquel personaje que controla todos los elementos básicos.

esElAvatar(Avatar):-
    esElementoBasico(Elemento),
    controla(Avatar, Elemento).

/*
2. clasificar a los personajes en 3 grupos:
    -un personaje noEsMaestro si no controla ningún elemento, ni básico ni avanzado;
    -un personaje esMaestroPrincipiante si controla algún elemento básico pero ninguno avanzado;
    -un personaje esMaestroAvanzado si controla algún elemento avanzado. Es importante destacar
que el avatar también es un maestro avanzado
*/
noEsMaestro(Personaje):-
    esPersonaje(Personaje),
    not(controla(Personaje, _)).

esMaestroPrincipiante(Personaje):-
    esPersonaje(Personaje),
    esElAvatar(Avatar),
    Personaje \= Avatar,
    controla(Personaje, Elemento),
    not(elementoAvanzadoDe(_, Elemento)).

esMaestroAvanzado(Personaje):- esElAvatar(Personaje).

esMaestroAvanzado(Personaje):-
    elementoAvanzadoDe(_, ElementoAvanzado),
    controla(Personaje, ElementoAvanzado).

/*
3.  saber si un personaje sigueA otro. Diremos que esto sucede si el segundo visitó
    todos los lugares que visitó el primero. También sabemos que zuko sigue a aang.
*/

sigueA(Seguido, Seguidor):-
    forall(visito(Seguido, Lugar),visito(Seguidor, Lugar)).

sigueA(aang, zuko).

/*
4.  conocer si un lugar esDignoDeConocer, para lo que sabemos que:
    todos los templos aire son dignos de conocer;
    la tribu agua del norte es digna de conocer;
    ningún lugar de la nación del fuego es digno de ser conocido;
    un lugar del reino tierra es digno de conocer si no tiene muros en su estructura. 
*/
estructurasDelReinoTierra(A,A).

esDignoDeConocer(tribuAgua(_)).
esDignoDeConocer(temploAire(_)).
esDignoDeConocer(reinoTierra(_, Estructuras)):-
    estructurasDelReinoTierra(Estructuras, Estructuras),
    not(member(muros, Estructuras)).

/*
5.  definir si un lugar esPopular, lo cual sucede cuando fue visitado por más de 4 personajes.
*/

esPopular(Lugar):-
    visito(Personaje1, Lugar),
    visito(Personaje2, Lugar),
    visito(Personaje3, Lugar),
    visito(Personaje4, Lugar),
    Personaje1 \= Personaje2,
    Personaje1 \= Personaje3,
    Personaje1 \= Personaje4,
    Personaje2 \= Personaje3,
    Personaje2 \= Personaje4,
    Personaje3 \= Personaje4.

/*
6.  Por último nos pidieron modelar la siguiente información en nuestra base de conocimientos
    sobre algunos personajes desbloqueables en el juego:
    bumi es un personaje que controla el elemento tierra y visitó Ba Sing Se en el reino Tierra;
    suki es un personaje que no controla ningún elemento y que visitó una prisión de máxima
    seguridad en la nación del fuego protegida por 200 soldados. 
*/