%%% Enunciado: bit.ly/3yUcZhk
esMago(harry).
esMago(draco).
esMago(hermione).

esSangre(harry, mestiza).
esSangre(draco, pura).
esSangre(hermione, impura).

seCaracteriza(harry, [corajudo, amistoso, orgulloso, inteligente]).
seCaracteriza(draco, [orgulloso, inteligente]).
seCaracteriza(hermione, [responsable, orgulloso, inteligente]).

odiaLaCasa(harry, slytherin).
odiaLaCasa(draco, hufflepuff).

%%% Sombrero %%%

casaAdecuada(Personaje, Casa):-
    seCaracteriza(Personaje, Personalidad),
    sombrero(Personalidad, Casa).

sombrero(Personalidad, gryffindor):-
    member(corajudo, Personalidad).

sombrero(Personalidad, slytherin):-
    member(orgulloso, Personalidad),
    member(inteligente, Personalidad).

sombrero(Personalidad, ravenclaw):-
    member(responsable, Personalidad),
    member(inteligente, Personalidad).

sombrero(Personalidad, hufflepuff):-
    member(amistoso, Personalidad).

%   1.
accesoPermitido(gryffindor, _).
accesoPermitido(ravenclaw, _).
accesoPermitido(hufflepuff, _).
accesoPermitido(slytherin, Mago):-
    esMago(Mago),
    not(esSangre(Mago, impura)).

%   2. no lo hace casaAdecuada/2?
%   3.
casaSelecionada(hermione, gryffindor).

casaSelecionada(Mago, Casa):-
    Mago \= hermione,
    casaAdecuada(Mago, Casa),
    accesoPermitido(Casa, Mago),
    not(odiaLaCasa(Mago, Casa)).

%   4.
cadenaDeAmistades(ListaDeMagos):-
    member(Mago0, ListaDeMagos),
    casaSelecionada(Mago0, Casa),
    forall(member(Mago, ListaDeMagos), (tienePersonalidad(Mago, amistoso), casaSelecionada(Mago, Casa))).

tienePersonalidad(Mago, Personalidad):-
    seCaracteriza(Mago, Personalidades),
    member(Personalidad, Personalidades).