// JUEGOS
class Juego{
  const property nombre
  const property precioMercado
  const property categoria
  const property tipo

  method esDeCategoria(unaCategoria) = self.sonIguales(categoria, unaCategoria)

  method coincideNombre(posibleNombre) = self.sonIguales(nombre, posibleNombre)

  method sonIguales(var1, var2) = var1 == var2

  method esJugado(persona, horas){tipo.afectar(persona, horas)}
}

object violento{
  method afectar(persona, horasDeJuego){
    persona.afectarHumor(10*horasDeJuego)
  }
}

object moba{
  method afectar(persona, horasDeJuego){
    persona.comprarSkin(self.precioDeSkin())
  }

  method precioDeSkin() = 30
}

object terror{
  method afectar(persona, horasDeJuego){
    persona.actualizarSuscripcion(infantil)
  }
}

object estrategico{
  method afectar(persona, horasDeJuego){
    persona.afectarHumor(5*horasDeJuego)
  }
}

// PERSONA

class Usuario{
  var property dinero
  var property suscripcion = base
  var property humor

  method actualizarSuscripcion(nuevaSuscripcion) {suscripcion = nuevaSuscripcion}

  method pagarSuscripcion() { 
    self.realizarCompra(suscripcion.costo(), {self.actualizarSuscripcion(prueba)})
  }

  method jugar(unJuego, horasDeJuego){
    if(suscripcion.permitirJugar(unJuego))
      unJuego.esJugado(self, horasDeJuego)
  }

  method comprarSkin(precio) {self.realizarCompra(precio, throw new DomainException(message = "No se puede comprar skin"))}

  method afectarHumor(unidadesDeHumor){ humor += unidadesDeHumor}

  method puedePagar(cantidad) = cantidad <= dinero

  method pagar(cantidad) {dinero -= cantidad}

  method realizarCompra(precio, noPuedeRealizarLaCompra){
    if(self.puedePagar(precio))
      self.pagar(precio)
    else
      {noPuedeRealizarLaCompra}
  }
}

// PLATAFORMA
object gameflix{
  const property bibloteca = []
  const property usuarios = []

  method filtrar(categoriaDeBusqueda) = bibloteca.filter{unJuego => unJuego.esDeCategoria(categoriaDeBusqueda)}

  method buscar(nombreDelJuego) = bibloteca.findOrElse({unJuego => unJuego.coincideNombre(nombreDelJuego)}, {throw new DomainException(message = "No se encontro el juego")})

  method recomendar() = bibloteca.anyOne()

  method juegosBaratos() = bibloteca.filter{unJuego => unJuego.precioMercado() < 30}

  method cobrar(){
    usuarios.forEach{ usuario => usuario.pagarSuscripcion()}
  }
}

//  SUSCRIPCIONES

object premium{
  method permitirJugar(juego) = true

  method costo() = 50
}

object base{
  method permitirJugar(juego) = gameflix.juegosBaratos().contains(juego)

  method costo() = 25
}

object prueba{
  method permitirJugar(juego) = juego.esDeCategoria("demo")


  method costo() = 0
}

object infantil{
  method permitirJugar(juego) = juego.esDeCategoria("infantil")

  method costo() = 10
}