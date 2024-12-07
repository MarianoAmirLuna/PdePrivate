class Barrio{
    const property niniosEnBarrio = []

    method topTres() = niniosEnBarrio.sortedBy{ninio => ninio.caramelos()}.reverse().take(3)

    method criterioEstadistica(ninio) = ninio.caramelos() > 10

    method estadisticasElementos() = niniosEnBarrio.filter{ninio => self.criterioEstadistica(ninio)}.elementos().asSet()
}