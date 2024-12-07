class Legion{
    var property legionDelTerror = []

    override method initialize(){
    if(!self.asustadores() < 2)
      throw new DomainException(message = "Son necesarios como mínimo 2 miembros")
    }

    method asustadores() = legionDelTerror.sum{ninioOLegion => ninioOLegion.asustadores()}

    method capacidadAsustar() = legionDelTerror.sum{ninio => ninio.capacidadAsustar()}

    method caramelos() = legionDelTerror.sum{ninio => ninio.bolsa()}

    method liderLegion() = legionDelTerror.max{ninio1 => ninio1.capacidadAsustar()}

    method asustarLegion(adulto) = adulto.asustarse(self)

    method recibirDulces(cantidad){
        self.liderLegion().recibirDulces(cantidad)
    }
}