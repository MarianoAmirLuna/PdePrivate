import usuarios.*
class Zona{
    const property maxVel
    const property controles = []
    const property usuariosEnZona = []

    method activarControles() = controles.forEach{control => control.efectuarMulta(usuariosEnZona, maxVel)}

    method cantUsuarios() = usuariosEnZona.legth()
}

//CONTROLES
class Control{
    method obtenerInfractores(personas, maxVel) = personas.filter{usuario => self.condicionDeMulta(maxVel, usuario)}
    
    method efectuarMulta(personas, maxVel){
        self.obtenerInfractores(personas, maxVel).forEach{persona => self.multar(persona)}
    }

    method multar(persona){
        const multa = new Multa (precio = self.valorDeMulta())
        persona.multas().add(multa)
    }

    method valorDeMulta()
    method condicionDeMulta(velMax, usuario)
}


object controlVelocidad inherits Control{
    override method valorDeMulta() = 3000
    override method condicionDeMulta(velMax, usuario) = usuario.pasadoDeVelocidad(velMax)

}

object controlEcologico inherits Control{
    override method valorDeMulta() = 1500
    override method condicionDeMulta(velMax, usuario) = usuario.esVerde() 
}

object controlRegulatorio inherits Control{
    override method valorDeMulta() = 2000
    override method condicionDeMulta(velMax, usuario) = usuario.noLeTocaSalir()
}

object calendario{
    method fecha() = new Date().day()
}