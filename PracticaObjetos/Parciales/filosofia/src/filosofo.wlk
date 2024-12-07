class Filosofo{
  const property nombre
  var property diasVividos
  const property actividades = []
  const property honorificos = #{}
  var property lvIluminacion

    method presentarse() = nombre + honorificos.join(", ")  
    
    method estaEnLoCorrecto() = lvIluminacion > 10000   
    
    method nuevaIluminacion(cantidad){
      lvIluminacion += cantidad
    }   
    
    method nuevoHonorifico(honorifico){
      honorificos.add(honorifico)
    }   
    
    method edad() = diasVividos / 365   

    method envejecer(diasPasado){
        const diasPrevios = diasVividos
        diasVividos += diasPasado
        self.haCumplidoUnAnio(diasPrevios, diasVividos)
    }

    method haCumplidoUnAnio(diaJoven, diaViejo){
        if(diaJoven.div(365) < diaViejo.div(365))
            self.nuevaIluminacion(10)
        if(diaViejo.div(365) == 60)
            self.nuevoHonorifico("el sabio")
    }

    method vivirUnDia(){
        actividades.forEach{actividad => actividad.realizarActividad(self)}
        self.envejecer(1)
    }

}

//   ACTIVIDADES

class Actividad{
    method realizarActividad(unFilosofo)
}

object tomarVino inherits Actividad{
    override method realizarActividad(quienLoHace){
        quienLoHace.nuevaIluminacion(self.unidadesDeIluminacion())
        quienLoHace.nuevoHonorifico()
    }

    method unidadesDeIluminacion() = 10
}

class JuntarseEnElAgora inherits Actividad{
  
  const otroFilosofo

  override method realizarActividad(unFilosofo) {
    unFilosofo.nuevaIluminacion(self.unidadesDeIluminacion())
  }

   method unidadesDeIluminacion() = otroFilosofo.lvIluminacion() * 0.1

}

object mirarPaisaje inherits Actividad{
    override method realizarActividad(quienLoHace){}

    method unidadesDeIluminacion(){}
}

class MeditarBajoCascada inherits Actividad{
    const property metros
    override method realizarActividad(quienLoHace){
        quienLoHace.nuevaIluminacion(self.unidadesDeIluminacion())
    }

    method unidadesDeIluminacion() = metros * 10
}

// ACTIVIDADES (DEPORTES)

class Deporte{
    method realizarActividad(unFilosofo){
        unFilosofo.envejecer(-self.diasARejuvenecer())
    }

    method diasARejuvenecer()
}

object practicarFutbol inherits Deporte{
    override method diasARejuvenecer() = 1
}

object practicarPolo inherits Deporte{
    override method diasARejuvenecer() = 2
}

object practicarWaterPolo inherits Deporte{
    override method diasARejuvenecer() = practicarPolo.diasARejuvenecer() * 2
}