import vehiculos.*
import zonas.*


class Usuario{
    const property nombre
    const property dni
    var property dineroDeCuenta
    var property vehiculo = Camioneta
    const property multas = []

    method viajar(kilometros) = vehiculo.recorre(kilometros)

    method puedePagarRecarga(litros) = if(!self.puedePagar(combustible.precio(litros))) throw new DomainException(message = "NO HAY PLA TA")

    method litrosACargar(litros) = vehiculo.usuarioPuedeCargar(litros)

    method recargarCombustible(litros){
        self.puedePagarRecarga(litros)
        dineroDeCuenta -= combustible.precio(self.litrosACargar(litros))
        vehiculo.cargarse(self.litrosACargar(litros))
    }

    method puedePagar(cantidad) = cantidad <= dineroDeCuenta

//Controles

    method pasadoDeVelocidad(velMax) = vehiculo.velocidadPromedio() > velMax
    method esVerde() = vehiculo.esEcologico()
    method noLeTocaSalir() = calendario.fecha().even() == self.dni().even()

// APP

    method adeuda() = multas.map{multa => multa.precio()}.sum()

    method pagarMultas() = multas.forEach{multa => self.pagar(multa)}

    method pagar(multa){
        self. puedePagaMulta(multa)
        dineroDeCuenta -= multa.precio()
        multas.remove(multa)        
    }

    method puedePagaMulta(multa){
        if(!self.puedePagar(multa.precio())){
            multa.pagoRetrasado()
            throw new DomainException(message = "No hay saldo suficiente para pagar la multa")
        }
    }
}

object combustible{
    method valorDelLitro() = 160
    method precio(litro) = self.valorDelLitro() * litro
}

class Multa{
    var property precio = 0

    method pagoRetrasado(){
        precio = precio * 1.1
    }
}