;creo que debo crear una gui para la alarma. esta tendra el boton para detenerla y dira, el script se detubo, presione aceptar para detener la alarma.

;buscar google sonidos de alarma que pueda usar, busco uno que no moleste demaciado, porque el beep estandar me molesta. quiero uno como Tin Tin Tin, Tin Tin TIn, etc
;añadir forma para reproducir la musica que el usuario quiera.
ini_Alarma()
{
	Global 
	_ALARMA_TERMINAR := false
}

;ini_Alarma() ;para efectos de prueba

activarAlarma()
{
	Global
	Critical, off
	;recuenci de 523 y dura un minuto
	;SoundBeep , 523, 6000
		Local Frecuencia := 800
		loop 4
		{
			if !_ALARMA_TERMINAR
			{	
				loop, 3
				{
					SoundBeep, Frecuencia, 333
				}
				Sleep 1000
			}
			else
			{
				_ALARMA_TERMINAR := false ;se devuelve a su estado normal
				return 0
			}
		}
	_ALARMA_TERMINAR := false ;se devuelve a su estado normal
}


apagarAlarma()
{
	Global
	_ALARMA_TERMINAR := true
}




/*
SoundPlay, Filename [, Wait]



*/
/*
;controlar el sonido con un bucle, asi es posible pararlo cuando quiera.
_alarma()
{
	emite beep mientras no este detenido, se emite una señal para detener cuando se da click en el mensaje que aprece indicando la interrucpion del escript
	


}
*/