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
object tom {
  var energia = 100
  
  method velocidad() = 5 + (energia / 10)
  
  method energiaActual() = energia

  method comerRatones(jerry) {
    energia = self.energiaPorComer(jerry)
    investigador.ratonesDevorados(1)
  }
  
  method correr() {
    const distanciaRecorrida = investigador.tiempoDePersecucion() * self.velocidad()
    energia = self.consumoPorRecorrer(distanciaRecorrida)
  }

  method meConvieneComerRatonA(unRaton, unaDistancia){
    return self.energiaPorComer(unRaton) > self.consumoPorRecorrer(unaDistancia)
  }

  method energiaPorComer(unRaton){
    return energia + 12 + unRaton.cuantoPesa()
  }
  
  method consumoPorRecorrer(unaDistancia){
    return energia - 0.5 * unaDistancia
  }
}

object investigador {
  var cantidadDeRatonesDevorados = 0
  var duracionDePersecucion = 120         //segundos
  
  method ratonesDevorados(cantidad){
    cantidadDeRatonesDevorados = cantidadDeRatonesDevorados + cantidad
  }

  method tiempoDePersecucion() = duracionDePersecucion
  
  method tiempoDePersecucion(tiempoDeLaNuevaPersecucion) {
    duracionDePersecucion = tiempoDeLaNuevaPersecucion
  }
}

object jerry{
    var peso = 30    //gramos

    method cuantoPesa() = peso

    method elRatonComio(gramosComidos) {
    peso = peso + gramosComidos
  }
}