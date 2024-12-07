object waza{
    const property totalUsuarios = []
    const property todasLasZonas = []
    
    method zonaMasTransitada() = todasLasZonas.sortedBy({zona1, zona2 => zona1.cantUsuarios() > zona2.cantUsuarios()}).head()

    method usuariosComplicados() = totalUsuarios.filter{usuario => self.esDeudor(usuario, 50000)}

    method esDeudor(usuario, maximoPermitido) = usuario.adeuda() > maximoPermitido

    method pagarMultas() = totalUsuarios.forEach{usuario => usuario.pagarMultas()}

}