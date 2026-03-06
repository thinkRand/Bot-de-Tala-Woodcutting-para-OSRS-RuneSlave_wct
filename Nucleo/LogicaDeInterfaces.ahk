
#Include Puntero.ahk

;para botar un item en especifico, puede servir en ciertos casos
;Al final debe comproba que se boto el item. 
;dvuelve 1 si el item se boto o 0 si hubo un error. Un error puede ser que tarde mucho tiempo en botarse a causa de un laggg.
inventory_botarItemCelda(i)
{
	
	Global EXISTE_INVENTARIO_NORMAL
	Global INVENTARIO_NORMAL
	;no necesito comprobar el estado del invenatrio normal porque fue definido con precausion y completamente seguro que su estado es optimo
	if EXISTE_INVENTARIO_NORMAL
	{	
		if i > 0 & i < 29
		{
		Send {Shift down}
		punteroA(INVENTARIO_NORMAL.celda[i].area, 1)
		Click
		pausaMin() 
		Send {Shift up}
		}
		else
		{
			MsgBox Error en funcion botarItemCelda(). El numero de celda %i% no es valido.
			return 0
		}
	}
	else
	{
		MsgBox Error en funcion botarItemCelda(). La interface INVENTARIO_NORMAL no esta definida.
		return 0
	}


}


;Debo agregar mas variables de estado para el inventario que me permitan manejarlo de diferentes maneras.
;CELDA_INICIAL me indica de donde se comensara a botar
;CELDA_FINAL me indica cual celda es la ultima a botar.
;ITEMS_INGNORAR me indica el color que tienen los items especiales que no se debe botar {gemas, clue, y otros}
;BOTAR_CADA := {5, 17} me indica el numero de items que se acumularan antes de empesar a botar, puede ser un rango para agregar una longitud variables.
;CELDAS_OCUPADAS_CUENTA para indicar cuantas celdas estan llenas en cada momento.
;CELDAS_LLENAS

;o mejor que cada celda contengo su estado actual celda.1.estaLLena()
