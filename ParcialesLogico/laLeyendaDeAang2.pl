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
 
esElementoBasico(fuego). 
esElementoBasico(agua). 
esElementoBasico(tierra). 
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado
elementoAvanzadoDe(fuego, rayo). 
elementoAvanzadoDe(agua, sangre). 
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla  
controla(zuko, rayo). 
controla(toph, metal). 
controla(katara, sangre). 
controla(aang, aire). 
controla(aang, agua). 
controla(aang, tierra). 
controla(aang, fuego). 
controla(azula, rayo). 
controla(iroh, rayo).

%reinoTierra(nombreDelLugar, estructuras).
%nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden).
%tribuAgua(PuntoCardinal).
%temploAire(PuntoCardinal).
visito(aang, reinoTierra(baSingSe           , [muro   , zonaAgraria, sectorBajo, sectorMedio                       ])). 
visito(iroh, reinoTierra(baSingSe           , [muro   , zonaAgraria, sectorBajo, sectorMedio                       ])). 
visito(zuko, reinoTierra(baSingSe           , [muro   , zonaAgraria, sectorBajo, sectorMedio                       ])). 
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])). 
visito(aang, nacionDelFuego(palacioReal, 1000)). 
visito(katara, tribuAgua(norte)). 
visito(katara, tribuAgua(sur  )). 
visito(aang, temploAire(sur  )).
visito(aang, temploAire(norte)). 
visito(aang, temploAire(oeste)). 
visito(aang, temploAire(este )). 

lugar(temploAire(sur)).
lugar(temploAire(este)).
lugar(temploAire(norte)).
lugar(temploAire(oeste)).
lugar(tribuAgua(sur)).
lugar(tribuAgua(norte)).
lugar(nacionDelFuego(palacioReal, 1000)).
lugar(reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
lugar(reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).

esAvatar(Personaje):-
    esPersonaje(Personaje),
    forall(esElementoBasico(Elemento), controla(Personaje, Elemento)).

noEsMaestro(Personaje):-
    esPersonaje(Personaje),
    not(controla(Personaje, _)).

esMaestroPrincipiante(Personaje):-
    controla(Personaje, Elemento),
    not(elementoAvanzadoDe(_, Elemento)).

esMaestroAvanzado(Personaje):- esAvatar(Personaje).
esMaestroAvanzado(Personaje):- controla(Personaje, Elemento), elementoAvanzadoDe(_, Elemento).

sigueA(aang, zuko).
sigueA(Seguido, Perseguidor):-
    esPersonaje(Seguido),  esPersonaje(Perseguidor),
    forall(visito(Seguido, Lugar), visito(Perseguidor, Lugar)).

esDignoDeConocer(temploAire(_)              ).
esDignoDeConocer(tribuAgua(norte)           ).
esDignoDeConocer(reinoTierra(_, Estructuras)):- not(member(muro, Estructuras)).

esPopular(Lugar):-
    visito(_, Lugar),
    findall(Persona, visito(Persona, Lugar), ListaDeVisitantes),
    length(ListaDeVisitantes, CantPersonas), CantPersonas > 4.