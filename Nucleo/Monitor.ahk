
;Un indicador es una piesa de informacion para leer, es un punto en la pantalla, y lo que se espera que indique es el color del pixel que hay en ese punto
;Esa informacin sirve para detectar cambios de estado de graficos o para indicar el estado actual de un grafico.

;los monitores vigilan los indicadores para tranformar lo que ven en informacion
;hya un monitor universal o hay un monitor para cada Area.

;A un monitor hai que decirle que vigilar
;Los indicadores solo se deben leer
;Los monitores leen los indicadores para hacer cosas
;tambien puedo crear un objeto monitor global que recive todo de forma global, y es usado por cada sub interface para conocer informacion de estado.
;Se usan las funciones de Monitor para definir logica de Monitoreo, como las relacionadas con restreo de pixeles
;Dentro del sistema cada interface esta posicionada de forma relativa a la interface global, y el monitor se encarga de traducir esas coordenadas para que sean relativas a la ventana
class _Monitor
{
	Static cuentaIndicadores := 0
	indicadores := []
	Static cuentaAreas := 0
	areas := []
	;todas las interfaces y lo demas se hubica relativo a la ventana global, sunawtframe2
	
	xG := 0 ; necesito la interdaceGlobal para hubicar correctamente cada componente, debo crear un objeto Monitor, que se enacargara de monitotereas, no estara contenido detntro de ninguna clase
	yG := 0
	
	__new(xG, yG)
	{
		this.xG := xG
		this.yG := yG
	}
	
	
	class _Indicador
	{
		ID := 0
		x := 0
		y := 0
		__New(x, y, ID)
		{
			this.x := x
			this.y := y
			this.ID := ID
		}
	}

	agregarIndicador(x, y)
	{
		this.cuentaIndicadores++
		;la x e y son relativas a la interdaceGlobal SunAwtFrame2, pero deben ser relativas a la ventana, por eso le sumo la pos de SunAwtFrame2
		;Debo guarada cada cosa en posicion relativa a la interface Global, o relativa a la ventana. Cuando se busca se deben proporcionar coordenadas relativas a la ventana, y para cada interface es mas logico asignarle una posicion relativa a la interdaceGlobal
		nuevoIndicador := new this._Indicador(x  , y , this.cuentaIndicadores)
		this.indicadores[this.cuentaIndicadores] := nuevoIndicador
		return this.cuentaIndicadores
	}
	
	colorActualIndicador(indicadorID)
	{
		;la pos del indicador esta expresada de forma relativa a la ventana, asi que pixel get color funcionara correctamente
		;Tooltip, % "indicador id = " indicadorID
		;sleep 500
		;MouseMove, this.indicadores[indicadorID].x, this.indicadores[indicadorID].y
		PixelGetColor colorActual, this.indicadores[indicadorID].x, this.indicadores[indicadorID].y
		return colorActual
	}
	
	estaColorEnArea(bArea, bColor)
	{
		Global
		;primero se tiene que comprobar que la variable area y color contienen valores validos
		;la variable color puede ser un arreglo o una cadena unico que indica un color
		;toda area creada tiene coordenadas relativas a la ventana, significa que puedo usar las funciones normalmente
		Local cX, cY
		if isObject(bArea)
		{
			if bColor is xdigit
			{
				PixelSearch, cX, cY, bArea.x1 ,bArea.y1, bArea.x2, bArea.y2, bColor,,fast
				if(!ErrorLevel)
				{
					return 1
				}
				else
				{
					return 0
				}
			}
			else
			{
				
				MsgBox Error en funcion estaColorEnArea(). El color no es valido.
				return -1
			}
		}
		else
		{
			MsgBox Error en funcion estaColorEnArea(). El area no es valida.
			return -1
		
		}
	}
	
	;actualizar(); lee cada indicador y guarda esa informacion en la variable que se aya designado para eso. Deben ser referencias a variables ocntenidas en los objetos que esperan saber esa informacion
	;con un arrglo varList puedo saber que variables van con cada indicador, y en esas variables solo indicare el color en ese indicador al de ejecutar actualisar(), asi que mientras mas seguido se ejecute
	;la funcion actualisar se contara con la informacion mas precicisa a tiempo real

}
