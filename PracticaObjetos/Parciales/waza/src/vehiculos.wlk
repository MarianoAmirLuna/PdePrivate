class Vehiculo{
    const property tanque = 20
    var property combustible
    const property velocidadPromedio

    method recorrer(kilometros){
        combustible -= self.consumirCombustibleBase() + self.consumirCombustibleAdicional(kilometros)
    }

    method consumirCombustibleBase() = 2
    method consumirCombustibleAdicional(kilometros) = 0

    method esEcologico() = false

    method usuarioPuedeCargar(litrosACargar) = litrosACargar.min(tanque)

    method cargarse(litros){
        combustible += litros
    }
}

class Camioneta inherits Vehiculo{
    override method consumirCombustibleBase() = 4
    override method consumirCombustibleAdicional(kilometros) = 5*kilometros
}

class Deportivo inherits Vehiculo{
    override method esEcologico() = self.velocidadPromedio() < 120
    override method consumirCombustibleAdicional(kilometros) = 0.2 * self.velocidadPromedio()
}

class Familiar inherits Vehiculo{
    override method esEcologico() = true
}