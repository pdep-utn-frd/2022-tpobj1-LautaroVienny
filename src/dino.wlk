import wollok.game.*
    
  const velocidad = 220
  const velocidad2 = 275
  
object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.boardGround("fondodino.jpg")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(puntuacion)
		game.addVisual(bomba)
	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method    iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		bomba.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
		bomba.detener()
	}
	
}

object gameOver {
	method position() = game.at(5,game.height()-4)
	method text() = "¡HAS MUERTO!"
	method textColor() = paleta.negro()
	
}


object paleta {
	const property negro = "000000"	
	
}


object puntuacion {
	
	method text() = "PUNTAJE ACTUAL:"
	method position() = game.at(1,game.height()-1)
	method textColor() = paleta.negro()
}

object bomba {
	
	const posicionInicial = game.at(game.width()-2,suelo.position().y())
	var position = posicionInicial
	
	method image() = "obstaculo.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverBomba",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverBomba")
	}
}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(3, game.height()-1)
	method textColor() = paleta.negro()
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad2,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "dino1.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡BOOM!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}