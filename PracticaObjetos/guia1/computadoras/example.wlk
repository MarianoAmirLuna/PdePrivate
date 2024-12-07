class SuperComputadora{
  const property equipos = []
  var property totalDeComplejidadComputada = 0

  method equiposActivos() = equipos.filter{equipo => equipo.estaActivo()}

  method estaActivo() = true

  method capacidadDeComputo() = self.equiposActivos().sum{equipo => equipo.computo()}

  method capacidadDeConsumo() = self.equiposActivos().sum{equipo => equipo.consumo()}

  method malConfigurado() = self.equipoQueMasComputa() != self.equipoQueMasConsume()

  method equipoQueMasConsume() = self.equiposActivos().max({equipo => equipo.consumo()})

  method equipoQueMasComputa() = self.equiposActivos().max({equipo => equipo.computo()})

  method computar(unidadesDeComputoRequeridas){
    self.equiposActivos().forEach{
      equipo => equipo.computar(unidadesDeComputoRequeridas / self.equiposActivos().size())
    }// forEach => quiero hacer una accion
    totalDeComplejidadComputada += unidadesDeComputoRequeridas
  }
}

class Equipo{
  var property estadoQuemado = false
  var property modo = standard
  
  method estaActivo() = !estadoQuemado && self.computo() > 0

  method consumo() = modo.consumoDe(self)

  method computo() = modo.computoDe(self)

  method consumoBase()
  method computoBase()
  method computoOverlock()
  
  method computar(ucRequeridas){
    if(ucRequeridas > self.computo()){
      throw new DomainException(message = "El equipo no da abasto al problema")
    }
    modo.puedeComputar(self)
  }
}

class A105 inherits Equipo{

  override method consumoBase() = 300

  override method computoBase() = 600

  override method computoOverlock() = self.computoBase() * 1.3

  override method computar(ucRequeridas){
    if(ucRequeridas < 5) throw new DomainException(message = "Error de fabrica")
    super(ucRequeridas)
  
  }
}

class B2 inherits Equipo{

  var property microchips = 0

  override method consumoBase() = 50 * microchips + 10

  override method computoBase() = (100 * microchips).min(800)

  override method computoOverlock() = self.computoBase() + 20 * microchips
}


//------------------------------------------------------------------------------
//  Modos
//------------------------------------------------------------------------------

object standard{
  method consumoDe(equipo) = equipo.consumoBase()

  method computoDe(equipo) = equipo.computoBase()

  method puedeComputar(equipo){}
}

class Overclock{
  var property vecesAntesDeQuemarse = 4
  method consumoDe(equipo) = equipo.consumoBase() * 2

  method computoDe(equipo) = equipo.computoOverlock()

  method puedeComputar(equipo){
    if (vecesAntesDeQuemarse == 0){
      equipo.estadoQuemado(true)
      throw new DomainException(message = "Equipo quemado")
    }
    vecesAntesDeQuemarse -= 1
  }
}

class AhorroDeEnergia{
  var computosRealizados = 0

  method periodicidadDeError() = 17

  method consumoDe(equipo) = 200

  method computoDe(equipo) = (self.consumoDe(equipo)/equipo.consumoBase()) * equipo.computoBase()

  method puedeComputar(equipo){
    computosRealizados += 1
    if(computosRealizados % self.periodicidadDeError() == 0) throw new DomainException(message = "Corriendo monitor")
  }
}

class APruebaDeFallos inherits AhorroDeEnergia{
  override method periodicidadDeError() = 100
  override method computoDe(equipo) = super(equipo)/2
}