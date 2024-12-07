import armas.*
class Rango{
    const property armas = [new Escopeta()]

    method laburarA(persona)

    method despachaElegantemente()

    method evaluar(miembro)
}

class Don inherits Rango{
    const property subordinados = []

    override method laburarA(persona){
        subordinados.anyOne().laburarA(persona)
    }

    override method despachaElegantemente() = true

    override method evaluar(miembro){
        miembro.toqueDeGracia()
        self.seleccionarSucesor().rangoPromovido(Don)
    }

//Bastaba con un max{criterio} y otro metodo, tengo que abandonar la mala practica de ordenar las cosas
    method seleccionarSucesor() = subordinados.find{unMiembro, otroMiembro => unMiembro.lealtad() > otroMiembro.lealtad() && unMiembro.esElagante()}

}

class Subjefe inherits Rango{
    var property ultimaArmaUtilizada = Revolver
    const property subordinados = []

    method armaDistinta() = armas.find{arma => arma != self.ultimaArmaUtilizada()}

    override method laburarA(persona){
        ultimaArmaUtilizada = self.armaDistinta()
        ultimaArmaUtilizada.matar(persona)
    }

    override method despachaElegantemente() = subordinados.any{miembro => miembro.despachaElegantemente()}

    override method evaluar(miembro){}
}

class Soldado inherits Rango{
// pude agregar un metodo para subordinados que me devuelva la lista vacia

    override method laburarA(persona){
        armas.anyOne().matar(persona)
    }

    override method despachaElegantemente() = armas.any{arma => arma.esSutil()}

    override method evaluar(miembro){
        if(armas.size() > 5)
            miembro.rangoPromovido(Subjefe)
    }
}