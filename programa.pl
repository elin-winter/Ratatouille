%%%%%%%%%%%%%%%%%%%%%%% Ratatouille %%%%%%%%%%%%%%%%%%%%%%%%

% rata(nombre, dondeVive).
rata(remy, gusteaus).
rata(emile, chezMilleBar).
rata(django, pizzeriaJeSuis).

% persona(nombre)
% cocina(persona, plato, experiencia)

cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, horst).
trabajaEn(deuxMoulins, amelie).

restaurante(Restaurante):-
    trabajaEn(Restaurante, _).

persona(Persona):-
    cocina(Persona, _, _).

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 1

platoEnMenu(Plato, Restaurante):-
    trabajaEn(Restaurante, Chef),
    cocina(Chef, Plato, _).

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 2

cocinaBien(remy, Plato):-
    cocina(_, Plato, _).

cocinaBien(Persona, Plato):-
    cocina(Persona, Plato, Exp),
    Exp > 7.

cocinaBien(Persona, Plato) :-
    tutor(Persona, Tutor),
    cocinaBien(Tutor, Plato).

tutor(linguini, Tutor) :-
    trabajaEn(Resto, linguini),
    rata(Tutor, Resto).

tutor(skinner, amelie).

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 3

chefResto(Chef, Resto):-
    trabajaEn(Resto, Chef), 
    cumpleCondicionChef(Chef, Resto).
    
cumpleCondicionChef(Chef, Resto):-
    forall(platoEnMenu(Plato, Resto), cocina(Chef, Plato, _)).

cumpleCondicionChef(Chef, _):-
    findall(Exp, cocina(Chef, _, Exp), Exps),
    sumlist(Exps, ExpTotal),
    ExpTotal >= 20. 

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 4

encargadoPlato(Persona, Plato, Resto):-
    trabajaEn(Resto, Persona),
    cocina(Persona, Plato, Exp), 
    forall(
        (trabajaEn(Resto, Otro), 
        cocina(Otro, Plato, OtraExp)),
        OtraExp =< Exp).

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 5

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(frutillasConCrema, postre(265)).

esSaludable(Plato):-
    plato(Plato, Info),
    caloriasPlato(Info, Calorias),
    Calorias < 75.

caloriasPlato(postre(Calorias), Calorias).

caloriasPlato(entrada(Ingredientes), Calorias):-
    length(Ingredientes, Cant),
    Calorias is 15 * Cant.

caloriasPlato(principal(Guarnicion, Tiempo), Calorias):-
    adicionalGuarnicion(Guarnicion, Adicional),
    Calorias is Adicional + 5 * Tiempo.

adicionalGuarnicion(pure, 20).
adicionalGuarnicion(papasFritas, 50).
adicionalGuarnicion(ensalada, 0).

%%%%%%%%%%%%%%%%%%%%%%%%% Punto 6

criticaPositiva(Critico, Resto) :-
    not(rata(_, Resto)),
    criticoAprueba(Critico, Resto).

criticoAprueba(antonEgo, Resto):-
    especialistaEn(Resto, ratatouille).

criticoAprueba(cormillot, Resto):-
    forall(platoEnMenu(Plato, Resto), esSaludable(Plato)).

criticoAprueba(martiniano, Resto):-
    trabajaEn(Resto, Chef),
    not((trabajaEn(Resto, OtroChef), OtroChef \= Chef)).

especialistaEn(Resto, Plato):-
    forall(trabajaEn(Chef, Resto), cocinaBien(Chef, Plato)).

