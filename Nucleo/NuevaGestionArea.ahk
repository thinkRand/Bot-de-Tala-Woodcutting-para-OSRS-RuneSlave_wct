;Crear, Borrar,  y Editar  areas. Mostrar areas puede ir en otro contexto,

ini_GestionArea()
{
	Global
	AREAS_DEFINIDAS_POR_USUARIO := []
	EXISTE_AREA_DEFINIDA_POR_USUARIO := false
}

class Area
{
	x1 := 0
	y1 :=0
	x2 :=0
	y2 :=0
	
}


defineArea()
{
	Global
	Static cuentaPuntos = 1
	Static cuentaAreas = 1
	Local x = 0
	Local y = 0
	MouseGetPos, x, y
	if(cuentaPuntos = 1)
	{
		cuentaPuntos++
		AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas] := new Area
		AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].x1 := x
		AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].y1 := y
	}
	else if (cuentaPuntos = 2)
	{
		AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].x2 := x
		AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].y2 := y
		
		;arganizo a toda AREAS_DEFINIDAS_POR_USUARIO para que se  forme desde x, y minimo a x, y maximo
		if(AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].x1 > AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].x2)
		{
			aux := AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].x1
			AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].x1 := AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].x2
			AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].x2 := aux
		}
	
		if(AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].y1 > AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].y2)
		{
			aux := AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].y1
			AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].y1 := AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].y2
			AREAS_DEFINIDAS_POR_USUARIO[cuentaAreas].y2 := aux
		}
		;insertar a guiMsg guiMsg(Area %cuentaAreas% a sido creada.)
		MsgBox Area %cuentaAreas% a sido creada.
		cuentaAreas++
		cuentaPuntos = 1
		EXISTE_AREA_DEFINIDA_POR_USUARIO := true	
	}
}

;las funciones deberian comprobar la existencia de areas definidas por el usuario?
borrarArea(i)
{
	Global
	AREAS_DEFINIDAS_POR_USUARIO.RemoveAt(i)
	if (AREAS_DEFINIDAS_POR_USUARIO.length() <=0)
	{
		EXISTE_AREA_DEFINIDA_POR_USUARIO := false
		MsgBox El area %i% a sido borrada.
	}
}

borrarAreas()
{
	Global
	AREAS_DEFINIDAS_POR_USUARIO := []
	EXISTE_AREA_DEFINIDA_POR_USUARIO := false
	;guiMsg()
	MsgBox Todas las areas an sido borradas.
}

dameArea(i)
{
	Global
	return AREAS_DEFINIDAS_POR_USUARIO[n]
}

editarArea(i)
{
	Global
	Static cuentaPuntos = 1
	nuevaArea := new Area
	Local x = 0
	Local y = 0
	MouseGetPos, x, y
	if(cuentaPuntos = 1)
	{
		cuentaPuntos++
		nuevaArea.x1 := x
		nuevaArea.y1 := y
	}
	else if (cuentaPuntos = 2)
	{
		nuevaArea.x2 := x
		nuevaArea.y2 := y
		if(nuevaArea.x1 > nuevaArea.x2)
		{
			aux := nuevaArea.x1
			nuevaArea.x1 := nuevaArea.x2
			nuevaArea.x2 := aux
		}
	
		if(nuevaArea.y1 > nuevaArea.y2)
		{
			aux := nuevaArea.y1
			nuevaArea.y1 := nuevaArea.y2
			nuevaArea.y2 := aux
		}
		
		AREAS_DEFINIDAS_POR_USUARIO[i] := nuevaArea
		
		;insertar a guiMsg guiMsg(Area %cuentaAreas% a sido creada.)
		MsgBox Area %i% a sido editada.
		cuentaPuntos = 1	
	}
}