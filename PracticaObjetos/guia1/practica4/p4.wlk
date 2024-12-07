/*
Ejercicio 4 - Celulares
A_    Se pide representar con objetos a personas que hablan entre sí por celulares.
  Juliana tiene un Samsung S21, y Catalina tiene un iPhone.
  El Samsung S21 pierde 0,25 "puntos" de batería por cada llamada, y el iPhone
pierde 0,1% de la duración de cada llamada en batería. Ambos celulares tienen
5 "puntos" de batería como máximo.


  Implementar a Juliana, Catalina, el Samsung S21 de Juliana y el iPhone de
Catalina en Wollok y hacer pruebas en donde Juliana y Catalina se hagan llamadas
telefónicas de distintas duraciones.

  *Conocer la cantidad de batería de cada celular.
  *Saber si un celular está apagado (si está sin batería).
  *Recargar un celular (que vuelva a tener su batería completa).
  *Saber si Juliana tiene el celular apagado; saber si Catalina tiene el celular apagado.

B_    Ahora podemos también tener en cuenta el costo de las llamadas que se hacen entre
Catalina y Juliana. Catalina tiene contratado como servicio de telefonía celular a
Movistar, Juliana a Personal. Movistar cobra fijo $60 final el minuto, Claro cobra
$50 el minuto + 21% de IVA y Personal $70 final los primeros 10 minutos que usaste
el celu, y $40 el minuto el resto.

  Se pide hacer un diagrama de objetos que represente esto y saber cuánta plata
gastó cada uno luego de haberse hecho varias llamadas entre sí.

¿Qué objeto me conviene que conozca a la compañía telefónica? ¿Qué debería pasar
con los gastos de llamadas si a Juliana se le rompe su celular y se compra uno nuevo?

/////////////////////////////////////////Practica 8///////////////////////////////////////
Agregar al modelo armado para el ejercicio de celulares lo siguiente:

A_    Revisar si como está lo que hiciste, crear una persona nueva es fácil o no; si para crear
una persona hay que repetir código, pensar cómo hacer para que no sea así.
B_    Crear a Juan, que tiene un iPhone; este iPhone no es el mismo aparato que el de Catalina,
pero se porta igual. Juan contrató a Personal.
Crear a Ernesto, que también tiene un iPhone, y contrató a Claro.
Armar el diagrama de objetos que queda después de agregar a las dos personas nuevas.
C_    Cambiar la política de Claro, para que cobre 0.50 + IVA por llamada, en lugar de por minuto.
D_    Además de llamadas, se pueden enviar mensajes de texto entre celulares. Siempre que un celular
recibe un mensaje lo guarda. Movistar y Claro cobran $0,12 centavos el mensaje, y Personal $0,15.
  Hacer que una persona cualquiera le mande un mensaje a otra.
  Saber cuántos mensajes le llegaron a una persona.
  Saber si una persona recibió un cierto mensaje, o sea, un mensaje con un determinado texto.
  Saber si una persona recibió un mensaje que empiece con un determinado texto, por ejemplo, con "Esta noche".
  Saber cuánta plata gastó una persona luego de hacer varias llamadas y envíos de mensajes.

Todo lo que viene abajo, debería hacerse en un solo objeto, y que ande para todas las personas.
Está relacionado con lo que preguntamos en el punto a. de este ejercicio.

*/
object juliana {
  var property celular = samsungS21
  var property servicioCelular = personal

  method celuApagado(){
    celular.apagado()
  }

  method recibirLlamada(duracion){
    self.realizarLlamada(duracion)
    servicioCelular.costoPorLlamada(duracion)
  }

  method llamar(duracion, unReceptor){
    self.realizarLlamada(duracion)
    unReceptor.recibirLlamada(duracion)
  }

  method realizarLlamada(duracionLlamada){
    celular.llamada(duracionLlamada)
    servicioCelular.costoPorLlamada(duracionLlamada)
  }
}
object catalina {
  var property celular = iphone
  var property servicioCelular = movistar

  method celuApagado(){
    celular.apagado()
  }

  method recibirLlamada(duracion){
    self.realizarLlamada(duracion)
    servicioCelular.costoPorLlamada(duracion)
  }

  method llamar(duracion, unReceptor){
    self.realizarLlamada(duracion)
    unReceptor.recibirLlamada(duracion)
  }

  method realizarLlamada(duracionLlamada){
    celular.llamada(duracionLlamada)
    servicioCelular.costoPorLlamada(duracionLlamada)
  }
}

object samsungS21{
  var bateria = 5
  method bateria() = bateria
  method llamada(duracionLlamada){
    bateria = bateria -0.25
  }
  method apagado(){
    return bateria <= 0
  }
  method recargar(){
    bateria = 5
  }
}

object iphone{
  var bateria = 5
  method bateria() = bateria
  method llamada(duracionLlamada){
    bateria = bateria - 0.1 * duracionLlamada
  }
  method apagado(){
    return bateria <= 0
  }
  method recargar(){
    bateria = 5
  }
}

object movistar{
  method costoPorLlamada(minutos){
    return minutos * 60
  }
}

object claro{
  method costoPorLlamada(minutos){
    return minutos * 50 * 1.21
  }
}
object personal{
  method costoPorLlamada(minutos){
    if(minutos > 10){
      return 70 * 10 + (minutos - 10) * 40
    }else{
      return 70 * minutos
    }
  }
}
