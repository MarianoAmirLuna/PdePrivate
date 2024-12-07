class Familia{
    const property miembros = []

    method concluyoAtaqueSorpresa() = miembros.isEmpty()

    method peligroso() = miembros.find{unMiembro, otroMiembro => !unMiembro.durmiendoConLosPeces() && unMiembro.totalDeArmas() > otroMiembro.totalDeArmas()}

    method ataqueSorpresa(unaFamiliaRival) {
      miembros.forEach{unMiembro => unMiembro.realizarTrabajo(unaFamiliaRival.peligroso())}
      if(unaFamiliaRival.concluyoAtaqueSorpresa())
        throw new DomainException(message = "El ataque sorpresa fue un exito")
      else
        self.ataqueSorpresa(unaFamiliaRival)

    }

    method luto(){
        miembros.map{miembro => miembro.reorganizado()}
    }
}

// ---------------------------------
//MIEMBROS
// ---------------------------------
class Miembro{
    //[Armas] al final no habia que delegarselo a los rangos, que pelotudo no tiene sentido
    //el traidor era una CLASE especial de miembro, pelotudo

    var property rango
    var property lealtad = 100
    var property estaHerido = false
    var property durmiendoConLosPeces = false

//ARMAS

    method recibirDisparo(){
        estaHerido = true
    }

    method toqueDeGracia(){
        durmiendoConLosPeces = true
    }

//RANGOS

    method realizarTrabajo(persona) {
      rango.laburarA(persona)
    }

//ACCION

    method esElagante() = rango.despachaElegantemente()

    method totalDeArmas() = rango.armas().size()

    method reorganizado(){
        self.efectoDonMuerto()
        self.evaluarRango()
    }

    method efectoDonMuerto(){
        lealtad = lealtad * 1.1
    }

    method evaluarRango(){
        rango.evaluar(self)
    }

    method rangoPromovido(nuevoRango){
        rango = nuevoRango
    }
}

// ---------------------------------
//ARMAS
// ---------------------------------
class Arma{
    //Falto Modelar la recarga de las armas
    //Falto modelar la descarga del arma
    method puedeMatar(persona)

    method noPudoMatar(persona)

    method matar(persona){
        if(self.puedeMatar(persona))
            persona.toqueDeGracia()
        else
            self.noPudoMatar(persona)
    }

    method esSutil()
}

class Revolver inherits Arma{
    var property balas

    method recargar(cantidad){
        balas += cantidad
    }

    override method puedeMatar(persona) = balas > 0

    override method esSutil() = balas == 1
}

class Escopeta inherits Arma{
    override method puedeMatar(miembro) = miembro.estaHerido()

    override method noPudoMatar(persona){
        persona.recibirDisparo()
    }

    override method esSutil() = false
}

class CuerdaDePiano inherits Arma{
    var property buenaCalidad = true

    override method puedeMatar(persona) = buenaCalidad

    override method esSutil() = true
}