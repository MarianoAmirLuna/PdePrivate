/*
Ejercicio 2 - Tom y Jerry
A)  Implementar en Wollok un objeto que represente a tom, que es un gato.
Lo que nos interesa de tom es manejar su energía y su velocidad, que dependen de sus actividades de comer ratones
y de correr. 
La persona que registra las actividades de tom, registra los ratones que come y la cantidad de tiempo que corre 
en segundos. 
Cuando tom come un ratón, su energía aumenta en (12 joules + el peso del ratón en gramos). La 
velocidad de tom es 5 metros x segundo + (energia medida en joules / 10). 
Cuando tom corre, su energía disminuye en (0.5 x cantidad de metros que corrió). Observar que la cuenta está en
joules consumidos por metro, pero cuando me dicen cuánto corrió, me lo dicen en segundos. La velocidad que se 
toma es la que corresponde a la energía de Tom antes de empezar a correr, y no varía durante una carrera.
Nota: además de tom, hay otros objetos en juego, ¿cuáles son, qué mensaje tienen que entender?
*/
/*B)  Lograr que tom entienda el mensaje:
tom.meConvieneComerRatonA(unRaton, unaDistancia)
Devuelve true si la energía que gana por comer al ratón es mayor a la que consume corriendo la distancia, que 
está medida en metros.*/
// ** CODIGO **
/*
Ejercicio 1 - Pepita básica
Codificar a pepita en Wollok, con estos patrones de modificación de la energía:
cuando vuela, consume un joule por cada kilómetro que vuela, más 10 joules de "costo fijo" en cada vuelo.
cuando come, adquiere 4 joules por cada gramo que come.
No olvidar la inicialización.
Pepita ahora es mensajera, le enseñamos a volar sobre la ruta 9.
Agregar los siguientes lugares sobre la ruta 9, con el kilómetro en el que está cada una, y agregar lo que haga
falta para que:
pepita sepa dónde está (vale indicarle un lugar inicial al inicializarla).
le pueda decir a pepita que vaya a un lugar, eso cambia el lugar y la hace volar la distancia.
pueda preguntar si pepita puede o no ir a un lugar, puede ir si le da la energía para hacer la distancia entre
donde está y donde le piden ir.
Por ahora no validamos cuando le pedimos que vaya que pueda ir, eso lo agregaremos más adelante.
Pensar en particular
qué objeto se debe encargar del cálculo de la distancia entre dos lugares, piensen cómo lo preguntarían desde la consola. 
Si resulta que el cálculo se repite para distintos objetos… OK, después vamos a ver cómo arreglar eso.
cómo hago para no repetir en distintos métodos de pepita la cuenta de la energía que necesita para moverse una cantidad de kilómetros.
*/
// ** CODIGO **

object pepita {
  var joules = 100
  var lugarUbicada = inicioDeRuta
  
  method volar(kilometro) {
    joules = (joules - (kilometro * 1)) - 10
  }
  
  method comer(gramo) {
    joules += gramo * 4
  }
  
  method dondeEsta() = lugarUbicada // getter
  
  method lugarUbicada(lugar) {      // setter
    lugarUbicada = lugar
  }
  
  method irA(lugar) {
    var distanciaAVolar = self.distanciaEntre(lugarUbicada, lugar)
    self.volar(distanciaAVolar)
    self.lugarUbicada(lugar)
  }
  
  method distanciaEntre(unLugar, otroLugar) {
    var diferencia = unLugar.kilometro() - otroLugar.kilometro()
    diferencia = diferencia.abs()
    return diferencia
  }
  
  method puedeIrA(lugar) {
    var distanciaAVolar = lugar.kilometro()
    return joules > (distanciaAVolar + 10)
  }
}

object inicioDeRuta {
  var distanciaEnKilometros = 0
  
  method kilometro() = distanciaEnKilometros
}

object unLugar {
  var distanciaEnKilometros = 10
  
  method kilometro() = distanciaEnKilometros
}

object otroLugar {
  var distanciaEnKilometros = 13
  
  method kilometro() = distanciaEnKilometros
}

object lugarLejos {
  var distanciaEnKilometros = 1300
  
  method kilometro() = distanciaEnKilometros
}

 /*Preguntas:
Uso siempre el method kilometro en cada lugar, debe haber otra forma de hacerlo.

Respuesta:
Seguramente sea con clases
*/