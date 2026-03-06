;QUE ES EL TIEMPO DE TRANSISION
/*
 Es el tiempo que transcurre de una actividad a otra. NO!
 es el tiempo que transcurre para cambiar el estado de una actividad.

;QUE ES EL TIEMPO DE EJECUCION
	;es el tiempo que cada actividad tarda en completarse


*/

;QUE ES LA TRANSISION
	;es el cambio de una actividad a otra. NO!
	;La transicion ocurre cuando se va de un estado a otro de la misma actividad.



;debo investigar el tiempo de reaccion humana promedio para hacer al script mas dificil de detectar.
;Globales, lag, rapidez
;(tiempoReaccionHumana, tiempoDistraccion, tiempoEficiaente,tiempoVariable)

/*
0.9 segundos en promedio para levantar el Lclick despues de presionarlo
entre 100 y 160 ms para presionar el Lclick despues de haberlo levantado

*/
pausaAlta(incremento:=0)
{	
	Random time, 800, 1200
	Sleep time+incremento
}

pausaMedia(incremento:=0)
{	
	Random time, 400, 800
	Sleep (time + incremento)
}

pausaBaja(incremento:=0)
{	
	Random time, 250, 400
	Sleep time + incremento
}

;Tiempo  promedio entre mover un click a un punto y hacer click, ya comprobado
pausaMin()
{
	Random, time, 100, 160
	Sleep, time
}

;crea una pausa por un periodo relacionado con el tiempo comun en que las personas notan cambios.
esperaTiempoReaccionHumana()
{
	Random time, 180, 250
	Sleep time
}

;crea una pausa por un periodo relacionado con distracciones
esperatiempoDistraccion()
{
	Random time, 1000, 4000
	Sleep time
}

;retorno un tiempo relacionado estadisticamente con intervalos regulares entre acciones.
curvaDeTiempoRegular()
{
	;toda una funcion estadistica bien locochona
	time := 0
	return time
}

;
curvaDeTiempoExponencial()
{
	;toda una funcion estadistica bien locochona
	time := 0
	return time
}

;el intervalo entre acciones sigue un tiempo binomial
curvaDeTiempoBinomial()
{
	;toda una funcion estadistica bien locochona
	time := 0
	return time
}