import legiones.*
import barrio.*

class Elemento{
    var property susto
}

class Maquillaje inherits Elemento{
    override method susto() = 3
}

class Traje inherits Elemento{
    var property tipo
    
    override method susto() = tipo.miedoCausado()
}

object tierno{
    const property miedoCausado = 2
}

object terrorifico{
    const property miedoCausado = 5
}

class Ninio{
    
    var property actitud
    var property caramelos = 0
    const property elementos = []

    method capacidadAsustar() = actitud * elementos.sum{elemnto => elemnto.susto()}

    method asustar(adulto) = adulto.asustarse(self)

    method recibirDulces(cantidad) {caramelos += cantidad}

    method asustadores() = 1

    method verificarDulces(){
        if(caramelos == 0)
            throw new DomainException(message = "No hay caramelos que comer")
    }

    method comerDulces(cantidad) {
        self.verificarDulces()
        caramelos -= cantidad
    }
}



class Adulto{
    var property niniosGlotones = 0

    method asustarse(ninio){
        if(self.pudoAsustarse(ninio)){
            self.darDulces(ninio)
        }
    }

    method tolerancia()

    method pudoAsustarse(ninio)

    method darDulces(ninio) = ninio.recibirDulces(self.cantidadCaramelos())
    
    method cantidadCaramelos()
}

class Comun inherits Adulto{
    override method tolerancia() = 10 * niniosGlotones
    
    override method pudoAsustarse(unNinio){
        self.intentoDeSusto(unNinio)
        return self.tolerancia() < unNinio.capacidadAsustar()
    }

    method intentoDeSusto(unNinio){
        if(unNinio.caramelos() > 15) niniosGlotones += 1
    }

    override method cantidadCaramelos() = self.tolerancia() * 0.5
}

class Abuelo inherits Comun{
    override method pudoAsustarse(unNinio) = true

    override method cantidadCaramelos() = super() * 0.5
}

class Necio inherits Adulto{
    override method pudoAsustarse(unNinio) = false
}