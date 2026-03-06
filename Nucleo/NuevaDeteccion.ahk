;Con la aparicion del objeto Monitor GLobal esto podria quedar obsoleto.

;RASTREADORES,
;DETECTORES Y
;IDENTIFICADORES
;(TODOS USAN DATOS)

;La deteccion me puede servir para identificar los objetos en el inventario asi como los contenidos en el banco.
;Podria necesitar RASTREADORES, estos tendrian la tarea de buscar en areas (inclusive toda la pantalla) algun color que se le indique. Como para detertar cosas en movimiento como, Monstruos, players o Hadas.
	;Una ves que el rastrador consiga una coincidencia se hubica lo mas al centro que pueda de ella (el centro debe tener un color coincidente en la matris de color)  y le mantiene la pista (track, la sigue)
	;mientras pueda, Se pueden crear muchos rastreadores con su MADRE RASTREADOR



;los detectores  se encargar de BUSCAR(NO ANALISAR, ANLISAR ES MAS COMPLEJO) el contenido de un objeto area, ya sea de usuario o de interface en busca de un color conocido  devuelve el objeto asociado a ese color.

;IDENTIFICAR Y DETECTAR NO SON LO MISMO, PERO SE RELACIONAN. llEGAN A TENER UTILIDADES SEPARADAS
;SE IDENTIFICAN COSAS QUE YA SE SABE DONDE ESTAN Y
;SE DETECTAN COSAS MEDIANTE INFORMACION, PARA CONOCER DONDE ESTA.


;un detector busca algo conocido dentro de un area.
;un identificador es  una funcion que se encarga de evaluar que esta contenido en un area, si es una roca puede decir que mineral es, si es un arbol puede decir cual es etc.
;detectarColor(area)
;identificarColor(color)

#include Nucleo/RS_Datos.ahk



;devuelve una lista de todos los objetos conocidos encontrados  (a traves de sus colores) y la poscicion donde encontro cada uno.
;ES UNA FUNCION MUY COMPLEJA, porque lleva a cabo muchas tareas y ademas deve hacerlo rapido.
detectarQueHay(area, modo:= "")
{
	Global
	;si modo es blank se ejecutan todas las busquedas
	;los modos son roca, arbol, pez, gema,
	if isObject(area)
	{
		switch modo
		{
			case "":
				MsgBox Modo de busqueda completa.
				return 1
			case "roca": 
				Local hayAlgo := false
				Local hallasgo := []
				loop, % ROCA.length()
				{
					pixelSearch, cX, cY, area.x1,area.y1, area.x2, area.y2, ROCA[A_Index].color,,fast
					if(!ErrorLevel)
					{
						;si no hubo error
						hayAlgo := true
						hallasgo.push({nombre:ROCA[A_Index].nombre, color:ROCA[A_Index].color, materialColor:ROCA[A_Index].materialColor, pos:{x:cX, y:cY}})	
					}
				}
				if hayAlgo
				{
					return hallasgo
				}
				else
				{
					;guiMsg()
					MsgBox Ningun mineral hallado en el area evaluada
					return 
				}
				
			case "pez": 
				detectarPez(area)
				return
			case "arbol": 
				detectarArbol(area)
				return
			case "gema": 
				detectarGema(area)
				return
			default:
				MsgBox Erro en funcion detectarQueHay(). El modo escogido no esta permitido.
			return -1
		}
	}
	else
	{
		
		MsgBox Error en funcion detectarQueHay(). El area no es valida.
		return -1
	}

	
}

;devuelve el objeto identificado a traves de su color asociado, modo permite orientar al identificador sobre que debe buscar
;los modos son, arbol, roca, pez, gema, otro
identificarColor(color, modo)
{
	Global


}

;no solo se puede identificar por el color, tambien se puede identificar un area. el area se  identifica segun un color conocido hallado en ella y  se definen sus caracterirsticas.
;es mas logico que reciva un objeto roca, pero igualmente se termina usando el area de la roca
identificarRocaEnArea(area)
{
	Global
	Local cX
	Local cY
	loop, % _RSROCA.length()
	{
		pixelSearch, cX, cY, area.x1,area.y1, area.x2, area.y2, _RSROCA[A_Index].color,,fast
		if(!ErrorLevel)
		{
						
			;MsgBox % "Detectado " ROCA[A_Index].nombre
			return {area:area, nombre:ROCA[A_Index].nombre, color:ROCA[A_Index].color, materialColor:ROCA[A_Index].materialColor, indicador:{x:cX, y:cY, color:ROCA[A_Index].color}}
		}
		else
		{	
			;buscar de nuevo hasta conseguirlo
			;MsgBox % ROCA[A_Index].nombre " no detectado"
			;siguiente color a buscar
			;en caso de que sehalla buscado todo en el array roca entoces lanzar un msj diciendo no se reconoce ningun color de una roca
		}
	}
	;MsgBox Ningun mineral hallado en el area evaluada
	return 0
}

;busca en el area dada un pez conocido.
detectarPez(area)
{
	MsgBox "funcion detectar pez"

}

detectarArbol(area)
{
	MsgBox "funcion detectar arbol"

}

detectarGema(area)
{
	MsgBox "funcion detectar gema"

}

;recive un area y un color para buscar en ella. si lo encuentra devuelve la posicion donde lo encontro, sino devuelve 0
detectarColorEnArea(bArea, bColor)
{
	Global
	;debido al contexto global me preocupa que la clase Area interfiera con el nombre de la variables parametro "area", por eso cambio su nombre a bArea
	;primero se tiene que comprobar que la variable area y color contienen valores validos
	;la variable color puede ser un arreglo o una cadena unico que indica un color
	if isObject(bArea)
	{
		if bColor is xdigit
		{
			Local cX
			Local cY
			pixelSearch, cX, cY, bArea.x1, bArea.y1, bArea.x2, bArea.y2, bColor,,fast
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
			
			MsgBox Error en funcion detectarColorEnArea(). El color no es valido.
			return -1
		}
	}
	else
	{
		MsgBox Error en funcion detectarColorEnArea(). El area no es valida.
		return -1
	
	}
}

;identificar no es detectar. Esto no va aqui
identificarArbolEnArea(area)
{
	Global
	Local cX, cY
	loop, % _RSARBOL.length()
	{
		pixelSearch, cX, cY, area.x1, area, y1, area.x2, area.y2, _RSARBOL[A_Index].color, , fast
		if (!ErrorLevel)
		{
			return _RSARBOL[A_Index]
		}
		else
		{
			;se busca el siguiente color
		
		
		
		}
	}
	;en caso de que no se halla identificado un arbol conocido en el area
	return 0

}