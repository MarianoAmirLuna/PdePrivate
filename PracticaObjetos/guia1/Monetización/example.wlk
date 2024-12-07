
//---------------------------------------------------------------------------------------------------------
// CONTENIDOS
//---------------------------------------------------------------------------------------------------------
class Contenido {
  var property titulo
  var property vistas = 0
  var property contenidoOfensivo = false
  var property monetizacion

  method monetizacion(nuevaMonetizacion){
    if(!nuevaMonetizacion.puedeAplicarseA(self)){
      throw new DomainException(message = "Monetizacion no apta para el contenido")
    }
    monetizacion = nuevaMonetizacion
  }

  override method initialize(){
    const nuevaMonetizacion 
    if(!nuevaMonetizacion.puedeAplicarseA(self)){
      throw new DomainException(message = "Monetizacion no apta para el contenido")
    }
  }

  method recaudacion() = monetizacion.recaudacionDe(self)
  
  method esPopular()
  method maximoPermitido()
  method puedeAlquilarse()
}

class Video inherits Contenido {
  
  override method esPopular() = vistas > 10000
  
  override method maximoPermitido() = 10000

  override method puedeAlquilarse() = true
}

class Imagen inherits Contenido{
  const tags = []

  override method esPopular() = tags.all({elemento => tagsDeModa.contains(elemento)})

  override method maximoPermitido() = 4000

  override method puedeAlquilarse() = false
}

 const tagsDeModa = ["duki"]


//---------------------------------------------------------------------------------------------------------
// MONETIZACION
//---------------------------------------------------------------------------------------------------------
object publicidad{
  
  method recaudacionDe(contenido) = (
    0.05 * contenido.vistas() +
    if(contenido.esPopular()) 2000 else 0).min(contenido.maximoPermitido())

  method puedeAplicarseA(contenido) = !contenido.contenidoOfensivo()
}

class Donacion{
  var property donado = 0

  method recaudacionDe(contenido) = donado

  method puedeAplicarseA(contenido) = true
}


class VentaDescarga{
  var property precio = 5

  method recaudacionDe(contenido){
    if(precio >= 5){
      return contenido.obtenerVistas() * self.precio()
    }
    else{
      throw new DomainException(
        message = "El precio de venta esta por debajo del minimo"
      )
    }
  }

  method puedeAplicarseA(contenido) = contenido.esPopular()
}

class Alquiler inherits VentaDescarga{
  override method precio() = 1.max(super())

  override method puedeAplicarseA(contenido) = super(contenido) && contenido.puedeAlquilarse()
}

//---------------------------------------------------------------------------------------------------------
// USUARIO
//---------------------------------------------------------------------------------------------------------

object usuarios{ //objeto compañero, para conductas que no dependan de un objeto en particular, sino más bien al todo
  const property todosLosUsuarios = []

  method emailsDeUsuariosRicos() = todosLosUsuarios.filter{usuario => usuario.verificado()}.sortedBy({uno, otro => uno.saldoTotal() > otro.saldoTotal()}).take(100).map{usuario => usuario.email()}

  method superUsuarios() = todosLosUsuarios.count{usuario => usuario.soySuperUsuario()}

}

class Usuario{
  const property nombre
  const property email
  var property verificado = false
  const property contenidos = []

  method saldoTotal(){
    contenidos.sum({contenido => contenido.recaudacion()})
  }
  
  method soySuperUsuario(){
    contenidos.count{contenido => contenido.esPopular()} >= 10
  }

  method publicar(contenido, monetizacion){
    contenidos.add(contenido)
    
  }
}