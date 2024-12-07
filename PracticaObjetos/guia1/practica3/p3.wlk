/*
Implementar en Wollok los objetos necesarios para calcular el sueldo de Pepe.
El sueldo de pepe se calcula así: sueldo = neto + bono x presentismo + bono x resultados.
El neto es el de la categoría, hay dos categorías: gerentes que ganan $1000 de neto, y cadetes que ganan $1500.
Hay dos bonos por presentismo:
Es $100 si la persona a quien se aplica no faltó nunca, $50 si faltó un día, $0 en cualquier otro caso;
En el otro, nada.
Hay tres posibilidades para el bono por resultados:
10% sobre el neto
$80 fijos
O nada
Jugar cambiándole a pepe la categoría, la cantidad de días que falta y sus bonos por presentismo y por resultados; y preguntarle en cada caso su sueldo.
Nota: acá aparecen varios objetos, piensen bien a qué objeto le piden cada cosa que hay que saber para poder llegar al sueldo de pepe.
*/
/*
Implementar en Wollok los objetos necesarios para calcular el sueldo de Pepe.
El sueldo de pepe se calcula así: sueldo = neto + bono x presentismo + bono x resultados.
El neto es el de la categoría, hay dos categorías: gerentes que ganan $1000 de neto, y cadetes que ganan $1500.
Hay dos bonos por presentismo:
Es $100 si la persona a quien se aplica no faltó nunca, $50 si faltó un día, $0 en cualquier otro caso;
En el otro, nada.
Hay tres posibilidades para el bono por resultados:
10% sobre el neto
$80 fijos
O nada
Jugar cambiándole a pepe la categoría, la cantidad de días que falta y sus bonos por presentismo y por resultados; y preguntarle en cada caso su sueldo.
Nota: acá aparecen varios objetos, piensen bien a qué objeto le piden cada cosa que hay que saber para poder llegar al sueldo de pepe.
*/
object pepe {
  var property faltas = 0
  var property puesto = gerente
  var property bonoPorResultado = porcentual
  // porcentual     fijo       ninguno
  var sueldo = 0
  
  method sueldoDePepe() {
    sueldo = self.sueldoNeto() + bonoPresentismoPorFaltas.sueldo(self) + bonoPorResultado.sueldo(self)
  }
  method sueldoNeto() = puesto.ganancia()
}

object gerente {
  method ganancia() = 1000
}

object cadete {
  method ganancia() = 1500
}

object bonoPresentismoPorFaltas {
  method sueldo(unEmpleado) {
    if (unEmpleado.faltas() == 0) {
      return 100
    } else {
      if (unEmpleado.faltas() == 1) {
        return 50
      } else {
        return 0
      }
    }
  }
}

object porcentual{
    method sueldo(unEmpleado){
        return unEmpleado.bonoPorResultado(unEmpleado)
    }
}
object fijo{
    method sueldo(unEmpleado){
        return unEmpleado.sueldoNeto()* 0.1
    }
}
object ninguno{
    method sueldo(unEmpleado){}
}