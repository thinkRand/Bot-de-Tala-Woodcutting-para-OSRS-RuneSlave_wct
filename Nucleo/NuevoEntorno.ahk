;REGLA UNO: ES UN SCRIPT POR CLIENTE, NO UN SCRIPT PARA VAIROS CLIENTES

/*
cada ventana de runescape , runelite o osbuddy debe estar asociada con un script  o varios dependiendo de si un script no le estorba a otro.
por el contrario, cada script puede que este asociado a una ventana valida o puede que este inactivo()sin ventana. Es decir
	1) cada script debe seleccionar sobre que ventana estara operativa y,
	2) cada ventana valida puede tener mas de un script asociado si estos no se interponen entre ellos.
	
	para solventar 2), necesito crear una global UnicoPosible que indica si un script puede correr al lado de otro de la misma clase.
	Para soveltar 1), puedo hacer dos cosas, iniciar un proceso valido cada ves que se inicia un script con el comando RUN y la segunda opcion es dar la capacidad a cada script de seleccionar sobre que ventana estar operativo.
	
	La auto seleccion de ventana para los script no es posible a menos que solo exista un proceos valido unico donde todos vallan a operar.
	
	Como opcion 3 )
	cada script estara operativo para a la ventana activa de runescape, de esta manera se puede usar el mismo script  para operar en varias ventanas, lo que hay que hacer es cambiar a cada ventana valida despues de cada siclo
	solucion 3) esto se puede logra haciendo ALT+TAB para pasar al siguiente proceso activo, si dicho proceso es valido iniciar y en caso contrario, pasar al siguiente proceso en la lista
*/
VENTANA_TITULO := ""
VENTANA_ACTUAL := 0
VENTANA_EN_USO := 0
NOMBRE_PROCESO_EN_USO := ""
EXISTE_ENTORNO:= false

;comprueba si la venta  es valida y devuelve el process id si lo es, devuelve 0 si no es valida
cargarEntorno()
{	
	Global VENTANA_EN_USO
	Global NOMBRE_PROCESO_EN_USO
	Global EXISTE_ENTORNO
	Global VENTANA_ACTUAL
	Global VENTANA_TITULO
	hwndActiva := WinExist("A")
	;WinGet, nombreProceso , ProcessName, A es valido tambien
	WinGet, nombreProceso , ProcessName, ahk_id %hwndActiva%
	winGetTitle, vTitle, ahk_id %hwndActiva%
	;nombreProceso == runelite.exe no funcion poraalguna razon que desconosco
	
	;mientras el entorno actual no sea valido sigo buscando
	if EXISTE_ENTORNO
	{
		;si el entorno con que operara el script ya fue definido mantengo actualisada la informacion actual del entorno
		VENTANA_ACTUAL := WinExist("A")
	}
	else
	{
		;en caso de que el entorno con que operara el script no haya sido definido, evaluo el entorno actual a ver si es valido
		if (nombreProceso = "RuneLite.exe")
		{	
			MsgBox La ventana %vTitle%  del proceso %nombreProceso% ha sido seleccionada para operar con el script
			VENTANA_EN_USO := hwndActiva
			VENTANA_ACTUAL := VENTANA_EN_USO
			NOMBRE_PROCESO_EN_USO := nombreProceso
			VENTANA_TITULO := vTitle
			EXISTE_ENTORNO := true
		}
		else if (nombreProceso = "OldSchoolClient.exe")
		{
			VENTANA_EN_USO := hwndActiva
			MsgBox La ventana %vTitle%  no esta siendo soportada y puede que sea inestable. Use RuneLite para los mejores resultados.
		}
		else if (nombreProceso = "Osbuddy.exe")
		{	
			VENTANA_EN_USO := hwndActiva
			MsgBox La ventana %vTitle%  no esta siendo soportada y puede que sea inestable. Use RuneLite para los mejores resultados.
		}
		else
		{
			MsgBox la ventana %vTitle% del proceso %nombreProceso% no es valida.
			;esta funcion no retorna nada
		}
	}
}


ventanaActual()
{
	return WinExist("A")
}
