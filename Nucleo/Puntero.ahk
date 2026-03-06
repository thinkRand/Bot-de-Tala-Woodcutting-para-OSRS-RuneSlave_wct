;quesas deba crear las fucniones que vi en los post: click rando area, click punto, mover random are, click rando etc,. Quisas deba cambiar le nombre de la funcion para hacerlo mas claro con su cometidoy su funcionamiento

;tengo que medir el tiempo que tarda esta funcion en desplazarce desde cualquier posicion hasta el area elegida, la velocidad de desplasamiento debe obedecer un comportamiento `parecido al humano.
punteroA(area, foco := 0, rapidez := 10)
{	
	Global
	Local xl := 0
	Local yl := 0
	
	Random, xl, (area.x1+foco), (area.x2-(foco*2))
	Random, yl, (area.y1+foco), (area.y2-(foco*2))
	;el senmode solo puede ser evetn para que la velicidad no sea instantanea
	MouseMove, %xl%, %yl%, %rapidez%
}


clickA(area, foco := 0, mRapidez := 15, n := 1, cRapidez:=50)
{	
	Global
	Local x := 0
	Local y := 0
	;MsgBox % "legue a punteroA con area =" area[1][1]
	Random, x, area.x1+foco, area.x2-(foco*2)
	Random, y, area.y1+foco, area.y2-(foco*2)
	;MsgBox % "mover a punto x = " x " y= " y
	MouseMove x, y, mRapidez
	loop, % n
	{
		Click
		sleep, cRapidez
	}
	
}


arastraA(area1, area2)
{
	;para mover algo del area1 al area2

}