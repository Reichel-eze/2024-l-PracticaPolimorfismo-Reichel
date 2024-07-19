% POLIMORFISMO

/*
El polimorfismo permite obtener soluciones más genéricas, que sean válidas para diferentes tipos de datos contemplando
las particularidades de cada uno de ellos. En general podemos decir que dos cosas son polimórficas cuando desde algún 
punto de vista comparten un tipo, o sea que pueden ser tratados indistintamente por quienes no les interesen los detalles 
en los cuales difieren.
*/

% Se tiene 3 tipos de vehiculos autos, camiones y bicicletas: 

hoy(fecha(22,12,2008)).

vehiculo(auto("A2000")).
vehiculo(auto("H2342")).
vehiculo(camion(12000, 2005)).
vehiculo(camion(70000, 2003)).
vehiculo(camion(30000, 1997)).
vehiculo(bici(fecha(30,10,2005))).
vehiculo(bici(fecha(20,12,2008))).

/* ALTERNATIVA INFELIZ :(

autoViejo(Patente):- Patente > "F".
camionViejo(Kilometraje,_):- Kilometraje > 60000.
camionViejo(_,Anio):- hoy(fecha(_,_,AnioActual)),
                      AnioActual - Anio > 10.
biciVieja(fecha(_,_,Anio)):- Anio < 2006.

?- forall(vehiculo(auto(Patente)), autoViejo(Patente)),
   forall(vehiculo(camion(Kms, Anio)), camionViejo(Kms, Anio)),
   forall(vehiculo(bici(Fecha)), biciVieja(Fecha)).

MUCHOS PREDICADOS PARA CADA UNO DE LOS VEHICULOS

*/

% ¿todos los vehiculos son viejos? (PENSANDO DE FORMA POLIMORFICA)

% Un auto es viejo si su patente es menor a F, 
% Un camion es viejo si tiene más de 60000km o más de 10 años, 
% Una bicicleta es vieja si la fecha de fabricacion es de año anterior al 2006

esViejo(auto(Patente)) :- Patente < "F".

esViejo(camion(Kilometros,_)) :- Kilometros > 60000.

esViejo(camion(_,Anios)) :- 
    hoy(fecha(_,_,AnioActual)),
    DiferenciaAnios is AnioActual - Anios,
    DiferenciaAnios > 10.

esViejo(bici(fecha(_,_,Anio))) :- Anio < 2006.

% ------------------------------------------------------

juguete(ingenio(cuboRubik,10)).
juguete(ingenio(encajar,2)).
juguete(munieco(50)).
juguete(peluche(300)).
juguete(peluche(150)).

% Suponiendo que quiero saber si un juguete es caro, 
% Lo que sucede cuando su precio supera los 100 pesos.
% - Se sabe que el precio de los juguetes de ingenio es de $20 por cada punto de dificultad, 
% - El precio del muñeco es el indicado, y 
% - El precio de los peluches es la mitad de su tamaño en mm.

% FORMA INFELIZ DE HACERLO :( -> mucha repeticion del predicado esCaro en relacion al tipo de juguete

% esCaro(ingenio(_,Dificultad)):-
%    100 < Dificultad * 20.
% esCaro(munieco(Precio)):- 
%    Precio > 100.
% esCaro(peluche(Tamanio)):-
%    Tamanio / 2 > 100.

esCaro(Juguete) :-
    juguete(Juguete),
    precio(Juguete,Precio), % Si tengo la lógica del precio delegada en otro predicado, luego no necesito repetir la lógica de esCaro en cada cláusula
    Precio > 100.

precio(ingenio(_,Dificultad), Precio) :- Precio is Dificultad * 20.
precio(munieco(Precio), Precio).
precio(peluche(Tamanio), Precio) :- Precio is Tamanio / 2. 

% ------------------------------------------------

vehiculo(opp564, camion(mercedes,2014)). % el año ta segundo
vehiculo(agt445, auto(504,1995)).        % el año ta segundo
vehiculo(mmr444, camion(scania,2010)).   % el año ta segundo
vehiculo(ppt666, moto(2010)).            % NO respeta la aridad
vehiculo(ert434, lancha(2017,yamaha)).   % El orden es otro
vehiculo(dfg345, karting(rojo)).         % ¡Y puede ser que no incluya la información del año y haya que hacer otra cosa!

% Y quisiéramos saber las patentes de los vehiculos anteriores al 2000

% CAMINO INFELIZ :(
% patenteDeAutoInteresante(Patente):-
%    vehiculo(Patente, Tipo(_,Anio)),   ---> TA MAL, PORQUE EL FUNCTOR NO PUEDE SER UNA VARIABLE(INCOGNITA)
%    Anio < 2000.                       ---> ADEMAS, NO SIEPRE EL ANIO VA A ESTAR EN ESE LUGAR!!    

patenteVehiculoInteresante(Patente) :-
    vehiculo(Patente,Vehiculo),
    anioVehiculo(Vehiculo,Anio),  % busco el Año segun el Vehiculo (el Año depende del Vehiculo)
    Anio < 2000.

anioVehiculo(camion(_,Anio), Anio).
anioVehiculo(auto(_,Anio), Anio).
anioVehiculo(moto(Anio), Anio).
anioVehiculo(lancha(Anio,_), Anio).

anioVehiculo(karting(Color), Anio) :-  colorDelAnio(Color, Anio). 

colorDelAnio(rojo,2010).
colorDelAnio(verde,1990).
colorDelAnio(azul,2015).

% De esta forma se evita repetir lógica creando relaciones acordes a los datos de los individuos, 
% aprovechando el polimorfismo en patenteDeAutoInteresante/1 al unificar toda la estructura con Vehiculo (sin iportar su forma) 
% y recién haciendo pattern matching cuando es necesario, en anioVehiculo/2.

% Así puedo meter los functores con la forma que yo quiera , y aún así mi predicado patenteDeAutoInteresante/1 no cambia. 
% Esa es la gran ventaja del polimorfismo. Lo único que tengo que hacer es definir el predicado anioVehiculo/2 para ese 
% nuevo tipo de functor, y ya todo anda ;)