/* BASE DE CONOCIMIENTO */
%alumnoDe(Maestro, Alumno)
alumnoDe(miyagui, sara).
alumnoDe(miyagui, bobby).
alumnoDe(miyagui, sofia).
alumnoDe(chunLi, guidan).

% destreza(alumno, velocidad, [habilidades]).
% Habilidades : 
/*
patadaRecta(potencia, distancia),
patadaDeGiro(potencia, punteria, distancia),
patadaVoladora(potencia, distancia, altura, punteria), 
codazo(potencia),
golpeRecto(distancia, potencia).
*/
esPatada(patadaRecta(_, _)).
esPatada(patadaDeGiro(_, _, _)).
esPatada(patadaVoladora(_, _, _, _)).

potenciaDelGolpe(patadaRecta(Potencia, _), Potencia).
potenciaDelGolpe(patadaDeGiro(Potencia, _, _), Potencia).
potenciaDelGolpe(patadaVoladora(Potencia, _, _, _), Potencia).
potenciaDelGolpe(golpeRecto(_, Potencia), Potencia).
potenciaDelGolpe(codazo(Potencia), Potencia).

punteriaDelGolpe(patadaDeGiro(_, Punteria, _), Punteria).
punteriaDelGolpe(patadaVoladora(_, _, _, Punteria), Punteria).

destreza(sofia, 80, [golpeRecto(40, 3),codazo(20)]).
destreza(sara, 70, [patadaRecta(80, 2), patadaDeGiro(90, 95, 2), golpeRecto(1, 90)]).
destreza(bobby, 80, [patadaVoladora(100, 3, 2, 90), patadaDeGiro(50, 20, 1)]).
destreza(guidan, 70, [patadaRecta(60, 1), patadaVoladora(100, 3, 2, 90), patadaDeGiro( 70, 80 1)]).

%categoria(Alumno, Cinturones)
categoria(sofia, [blanco]).
categoria(sara, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(bobby, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(guidan, [blanco, amarillo, naranja]).

habilidades(Alumno, Habilidades):-
    destreza(Alumno, _, Habilidades).

esBueno(Alumno):-
    habilidades(Alumno, Habilidades),
    lenght(Habilidades, Cantidad),
    Cantidad >=2.

esBueno(Alumno):-
    destreza(Alumno, Velocidad, Habilidades),
    puedeGolpearRecto(Habilidades),
    between(50,80,Velocidad).

puedeGolpearRecto(Habilidades):-
    member(golpeRecto(_, _),Habilidades).


esAptoParaTorneo(Alumno):-
    esBueno(Alumno),
    alcanzoElCinturoVerde(Alumno).

alcanzoElCinturoVerde(Alumno):-
    categoria(Alumno, Cinturones),
    member(verde, Cinturones).

totalPotencia(Estudiante, PotenciaTotal):-
    habilidades(Alumno, Habilidades),
    findall(Potencia, (member(Habilidad, Habilidades), potenciaDelGolpe(Habilidad, Potencia)), Potencias),
    sumlist(Potencias, PotenciaTotal).

alumnoConMayorPotencia(AlumnoMax):-
    totalPotencia(AlumnoMax, PotenciaMax),
    forall(totalPotencia(_, PotenciaMin), PotenciaMax >= PotenciaMin).

sinPatada(Alumno):-
    habilidades(Alumno, Habilidades),
    not(sabePatadas(Habilidades))

sabePatadas(Habilidades):-
    member(Golpe, Habilidades),
    esPatada(Golpe).


soloSabePatadas(Alumno):-
    habilidades(Alumno, Habilidades),
    forall(member(Golpe, Habilidades), esPatada(Golpe)).

potencialesSemiFinalistas(Alumno):-
    esAptoParaTorneo(Alumno).

potencialesSemiFinalistas(Alumno):-
    alumnoDe(Profe, Alumno),
    alumnoDe(Profe, OtroAlumno),
    OtroAlumno \= Alumno.

potencialesSemiFinalistas(Alumno):-
    habilidades(Alumno, Habilidades),
    member(Skill, Habilidades),
    estiloArtistico(Skill).

estiloArtistico(Habilidad):-
    potenciaDelGolpe(Habilidad, 100).

estiloArtistico(Habilidad):-
    punteriaDelGolpe(Habilidad, 90).

