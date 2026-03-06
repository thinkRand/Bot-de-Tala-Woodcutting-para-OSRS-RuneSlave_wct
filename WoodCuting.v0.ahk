
;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
;las configuraciones iniciales debes estar en un archovo aparte, son parte necesaria para el funcionamiento. config.ini
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability. ;averiguar por que acelera el clikc a instantaneo
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Window ;no afecta el mouse velocidad
CoordMode, Pixel, Window ;no afecta la velocidad del mouse
SetBatchLines -1 ;no afecta la velocidad del mouse
ListLines On ; despues sera OFF, caundo todo este listo

#Include Nucleo/NuevaInterfaceCliente.ahk
#Include Nucleo/NuevoEntorno.ahk
#Include Nucleo/NuevaGestionArea.ahk
#Include Nucleo/NuevaDeteccion.ahk
#Include Nucleo/Monitor.ahk
#Include Nucleo/Puntero.ahk
#Include Nucleo/GestionTiempo.ahk
#Include Nucleo/MarcaDeTiempo.ahk

ini_GestionArea()

;No me parece iniciar un arbol solo con el area y el num, creo que el num se debe asignar de forma automatica
class _Arbol
{
	nombre := "Arbol" ;esta ves los arboles no tienen tipo especifico(willw, oak, tree etc) porque no es necesario identificarlos de esa manera.
	num := 0 ;cada arbol es enumerado para saber quien va primero en un una fila
	area := {} ;no es precisamente el area del arbol, para funcionar debe ser un area que contenga solo un arbol. y ser mas o menos grande.
	;los colores deben estar en formato BGR, porque asi son devueltos por las funciones
	colorActivo := "" ;cada Arbol tiene un colo activo y uno inactivo, el inactivo es el color debajo del color activo
	colorInactivo := ""
	;colorMadera := "" ;no es necesario usar esto en este script
	IndicadorID := 0
	Static Monitor := new _Monitor(0,0) ;debo usar xG0 y xY 0 porque son necesarias para iniciar, pero no hacen nada y no tiene importancia para el resto del codigo
	__New( num, area, colorActivo, colorInactivo, INx, INy)
	{
		;this.area := area
		;this.nombre := nombre
		this.num := num
		this.area := area
		this.colorActivo := colorActivo
		this.colorInactivo := colorInactivo
		;el indicador esta en monitor y el arbol se queda con la id
		this.indicadorID := this.Monitor.agregarIndicador(INx, INy)
	}
	
	;Para saber si un arbol esta cortado, debe usar el color que tenga a disposicion, ya sea color activo o inactivo. Si el indicador indica un color diferente a estos dos Erro. Se presume se laio de posicion.
	estaCortado()
	{
		Global
		Local gC
		gC := this.Monitor.colorActualIndicador(this.IndicadorID)

		;debo compararlo con el color que tenga a disposicion, sim imporatar que color tengo puedo saber si un arbol esta enPie o Cortado
		;En caso de que tenga el colorActivo
		if (this.colorActivo != "")
		{
			;Tooltip, % "Color actual = " gC " Color activo = " this.colorActivo
			;Sleep 5000
			;Tooltip, % "el indicador es = " this.indicadorID 
			
			if (gC = this.colorActivo)
			{
				;el arbol esta activo, en pie. Afirmado con toda certeza.? puede ser que color inactivo haya sido definido no dierectamente.
				return 0
			}
			else
			{
				;gC no es igual a color activo, 
				;pero solo queda otra opcion. Que sea igual a color Inactivo. Si no es igual a alguno de los dos, se presume que se salio de lugar.
				if (this.colorInactivo != "")
				{
					if (gC = this.colorInactivo)
					{
						;el arbol no esta activo, cortado.
						return 1
					
					}
					else
					{
						;el gc No coincide con ningun color, se presume que se salido de lugar	
						;ERROR. CUANDO APARECIO EL NUEVO ARBOL ARROJO ESTE MENSAJE
						;PUEDE SER QUE SE HAYA DEFINIDO EL COLOR PARA UNA COPIA PERO NO AL QUE SE EVALUA  EN EL MOMENTOS
						MsgBox, Error. Buelva a posicion inicial.
						;ErrorLevel 1, no se como se debe usar esta variable global, presumo que su valor se resetea antes de cada funcion, para poder arrojar un valor de esa funcion
						return -1
					}
				}
				else
				{
					;el color inactivo no se ha definido, asi que tomo el actual.
					this.colorInactivo := gC
					;return 1 para indicar que el arbol esta inactivo, cortado
					return 1
				}
				
			}
		
		}
		else if (this.colorInactivo != "")
		{
			;en caso de que no tenga el color Activo, pero tengo el inactivo
			;ToolTip, No tengo el color activo. Pero si el inactivo. en estacortado()
			;Sleep 2000
			
			if (gC = this.colorInactivo)
			{
				;El arbol esta cortado. El arbol esta cortado, afirmado con toda certeza?, puede que el color inactivo haya sido definido no directamente!
				return 1
			
			}
			else
			{
				;en este caso yo se que color no es igual a inactivo, y activo no existe
				;como no es igual al color inactivo y el color activo no existe debo hacer lo siguiente
				this.colorActivo := gC ;el opuesto a inactivo
			
				;el arbol no esta cortado. Esta en pie
				return 0
			}		
		}
		else
		{
			MsgBox, Error grave. Este arbol no tiene definido ningun color.
		}

	} ;fin de funcion

	;la contraparte de estaCortado, ambas sirven para lo mismo. debo evaluar su utilidad
	/*
	estaEnPie()
	{
		if (this.estaCortado() != -1)
		{
			return !this.estaCortado()
		}		
		else
		{
			MsgBox, Error. Buelva a posicion inicial.
			return -1
		}
	} ;fin de funcion
	*/
	
} ;fin de clase

;Creo un objeto monitor para monitorear los indicadores de los arboles (las areas definidas por el usuario)






;quisas sea mas coerente crear un objeto monitor de areas e irle aregando las areas que quiero monitorear, el mismo posee el metodo de detetarColorEn area que seria usado para saber si un arbol esta cortado
; MonitorAreas  := new _Monitor(0,0).agregarArea()arbol.area

;auto ejecutable
COMPONENTES_CARGADOS := false ;para indicar si se an cargado todos los componentes necesarios
ARBOLES_CARGADOS := false ; para indicar si los arboles ya fueron cargados
_DETENER := false ;para detener el script, en caso de mouse move, keystroke o seleccion de usuario
_ESPERA := 0 ; debe indicar el tiempo acumulado en la espera de alguna accion.

return

;Ini wct
ini_script()
{
	Global
	if (estaExpirado())
	{
		;el escript esta pasado de fecha limite
		msgExpirado()
		
		return 0
	
	}
	
	;quisas deba agregar un else que envuelva todo el resto del codigo. ummmm no se
	
	if (!COMPONENTES_CARGADOS)
	{
		cargarComponentes()
	}
	
	if (COMPONENTES_CARGADOS)
	{
		;puedo usar directamente winExist(A)
		;y que paso si el proceso de runelite se cerro?, algo tengo que hacer
		if (ventanaActual() != VENTANA_EN_USO)
		{
			WinActivate, ahk_id %VENTANA_EN_USO%
			WinWaitActive, ahk_id %VENTANA_EN_USO%
		}
		
		
		;Si se ha definido algun area, creo un arbol por cada area definida
		if (EXISTE_AREA_DEFINIDA_POR_USUARIO)
		{
			if (!ARBOLES_CARGADOS)
			{
				;Static o GLobal
				;las static se inicialisan de inmediato cuando se interpreta el script, no pueden ser variables que
				Static Arboles := 0
				Arboles := crearArbolPorArea(AREAS_DEFINIDAS_POR_USUARIO)
				if (Arboles != 0)
				{
					ARBOLES_CARGADOS := true
				}
				else
				{
					;MsgBox, Error al identificar los arboles.
					;este mensaje esta dentro de la funcion identificar
				}
				
			}
			
			if (ARBOLES_CARGADOS)
			{
				/*
				Tooltip, Los arboles estan cargados
				Sleep 8000
				
				Loop, % Arboles.length()
				{
					Tooltip, % "num = "Arboles[A_index].num
					Sleep 1000
					Tooltip, % "cA = "Arboles[A_index].colorActivo
					Sleep 1000
					Tooltip, % "cI = "  Arboles[A_index].colorInactivo
					Sleep 1000
					Tooltip, % "area = " Arboles[A_index].area.x1 "-" Arboles[A_index].area.x2
					Sleep 5000
					Tooltip, % "IndicadorID " Arboles[A_index].IndicadorID
					Sleep 1000
					Tooltip, % Arboles[A_index].Monitor.indicadores[Arboles[A_index].IndicadorID].x " " Arboles[A_index].Monitor.indicadores[Arboles[A_index].IndicadorID].y
					Sleep 5000
				}
				*/
				
				/*
				
				ToolTip, inicio prueva de cada arbol
				Sleep 2000
				
				loop, % Arboles.length()
				{
				Mousemove, Arboles[A_index].area.x1, Arboles[A_index].area.y1
				Sleep 2000
				;creo que se debe crear un objeto Monitor global, e incluir referencias a el en cada objeto arbol
				MouseMove, Arboles[A_index].Monitor.indicadores[Arboles[A_index].indicadorID].x, Arboles[A_index].Monitor.indicadores[Arboles[A_index].indicadorID].y
				Sleep 2000
				ToolTip, % "esta cortado = " Arboles[A_index].estaCortado()
				Sleep, 2000
				
				}
				*/
				
				
				
				;Defino las variables locales del ciclo de wct
				_DETENER := false ;reinicio detener a false en caso de que esta ejecucuion sea un CONTINUAR...
				Local i := 1 ;num de arbol, no. enrealidad es la direccion de un arbol
				Local arbolObjetivo := 0 ;Arboles[i] ;Es el siguiene arbol a cortar(debe pasarce por referencia y no una copia)
				Local arbolObjetivoExiste := false ;true ;para indicar que existe un arbol para ir a cortarlo
				Local arbolActual :=  0 ;Arbol actual es el que esta siendo cortado actualmente
				Local arbolSiguiente := 0 ;Es el arbol que le sigue al actual
				Local proximoArbol := 0 ;Es el arbol mas proximo que esta activo
				Local cortandoArbol := false ;Bandera para indicar si se esta cortando arbol
				Local botarItems := false ;Bandera para indicar si es necesario botar items, es una orden primaria(va primero que la ejecucuion del cortado
				Local punteroPos := 0 ;indica en que arbol esta el mouse, 0 indica que no esta en un abol.
				Local clienteNoReacciona := false ;para indicar si el cliente esta pegado o no,
				;Comiensa el ciclo de cortado
				loop, % ciclosScript := 1200000 
				{
					;Activar ventana si no lo esta, o detener el script. Es mejor detener el script
					if (ventanaActual() != VENTANA_EN_USO)
					{
						Tooltip, Error. El script solo opera con %VENTANA_TITULO%
						break
						;WinActivate, ahk_id %VENTANA_EN_USO%
						;WinWaitActive, ahk_id %VENTANA_EN_USO%
					}
					
					;Si hay que botar items es una orden primaria
					if(!BotarItems)
					{
						;Mejor hago !arbolObjetivoExiste
						if (!arbolObjetivoExiste)
						{
							;ToolTip, arbol objetivo no existe
							;Sleep 1000
							;aqui esta el problema alige arbol objetivo
							arbolObjetivo := eligeArbolObjetivo(Arboles)
							if (arbolObjetivo != 0)
							{
								arbolObjetivoExiste := true
							}
							else
							{
								;Debo esperar un tiempo brebe para dar chance al arbol de aparece
								Sleep 50
								/*
								;sigue intentando localisar un arbol objetivo
								_ESPERA += 50
								;si se ha esperado suficiente para que aparesca algun arbol. Mas o menos 14 segundos
								if (_ESPERA >= 14000)
								{
									_DETENER := true
									;disparar alarma por larga espera
									MsgBox, Detenido autonomo.
								}
								;no se ha detectado un arbol en pie en un largo tiempo, el script se detendra. Esto se debe activar cuando haya pasado un tiempo pertinente
								*/
							}
						}
						
						
						;Como configuracion inicial el inventario debe estar visible, se considera visible si el boton de inventaio esta activo
						;hay error en el area
						;hay algo mal aqui
						;las siguientes areas no se identifican
						;MouseMove, BarraOpciones.opcion[4].area.x1, BarraOpciones.opcion[4].area.y1
						;lo siguiente no muestra la info, el area esta mal o la referencia esta mal.
						
						
						;ToolTip, % BarraOpciones.ID funciona
						;La Barra de opciones se creo correctamente hasta a qui
						;ToolTip, % BarraOpciones.opcion[1].colorActivo funciona
						;ToolTip, % BarraOpciones.opcion[1].colorBase funciona
						;ToolTip, % BarraOpciones.opcion[5].indicadorID funciona
						;ToolTip, % BarraOpciones.x no funciona
						;ToolTip, % InterfaceGlobal.x no funciona
						;segun los datos anteriores conlcuyo que el erro es que no se verifica que la posicione de la interface global sea creada con satisfaccion, en el caso de prueba dicha interface
						;no existe sir  embargo el script sigue operativo. Debo agregar manejo de errores a la creacion de el objeto interface.					
						;Sleep 5000
						;activar(BarraOpciones.opcion[4])
						if ( !BarraOpciones.opcion[4].estaActiva() )
						{
							;ToolTip, el inventario no se detectado
							Sleep 3000
							;espero un tiempo de unos 3 segundos porque es estraño que el inventario no este activo: puede ser intervencion humana o quien sabe que
							Sleep 3000
							punteroA(BarraOpciones.opcion[4].area)
							pausaMin()
							click
							;Despues hay que esperar que la opcion se active, aun no se cuanto tiempo es lo normal
							Sleep 1000
						}
									
						if (arbolObjetivoExiste)
						{
							;ToolTip, Arbol objetivo existe
							;Sleep 2000
							if (!cortandoArbol)
							{
								;ToolTip, No se esta cortando
								;Sleep 2000
								;en caso de que se escoja cortar el arbol que se corta anteriormente
								if (punteroPos = arbolObjetivo.num)
								{
									pausaMin()
									Click
									;ToolTip, what
									sleep 100
									arbolActual := arbolObjetivo
									punteroPos := arbolActual.num
									arbolSiguiente := siguienteEntreArboles(arbolActual, Arboles)
									cortandoArbol :=  true
								}
								else
								{
									;Todo debe pasarse por referenica
									cortarArbol(arbolObjetivo) ;puede altera la global cortandoArbol a true
									arbolActual := arbolObjetivo
									punteroPos := arbolActual.num

									;para saber arbol siguiente debo saber la pos de cada arbol, la pos esta en su num, por eso
									arbolSiguiente := siguienteEntreArboles(arbolActual, Arboles) ;debo crear una funcion para saber que arbol le sigue a cual. Puede ser enumerando los arboles
									;puede ser arboles.siguiente(). arboles.actual(). arboles.objetivo() y etc
									cortandoArbol :=  true
								}
								
								
								
							}				
					
							if (cortandoArbol)
							{
								;ToolTip, Ahora se esta cortando
								;Sleep 2000
								;Vigilo el inventario mientras este cortando, o lo vigilo antes de cualquier cosa
								;BarraOpciones.Inventory.actualisar()
								;ir boatr es primario, una condicion antes que todo.UNA CONDICIONAL!
								;el inventaio debe estar visibe justo antes de evaluar si esta lleno, o mejor dicho, el invetario solo se puede evaluar si esta activo
								if (BarraOpciones.Inventory.estaLLeno())
								{
									;DETENGO EL CORTADO Y ME VOY A BOTAR
									BotarItems := true
									;RESET()
									
									arbolObjetivo := 0 ;Es el siguiene arbol a cortar
									arbolObjetivoExiste := false ;para indicar que existe un arbol para ir a cortarlo
									arbolActual :=  0 ;Arbol actual es el que esta siendo cortado actualmente
									arbolSiguiente := 0 ;Es el arbol que le sigue al actual
									proximoArbol := 0 ;Es el arbol mas proximo que esta activo
									cortandoArbol := false ;Bandera para indicar si se esta cortando arbol
									punteroPos := 0 ;puntero se encuentra fuera de algun arbol.
				
								}
								else
								{
									;En caso de que le inventaio no este lleno, puedo continuar con lo demas
									;Identifica al proximoArbol, el mas cercano que esta en pie (en el orden en que fueron creados)
									;ToolTip, Detectar proximo arbol
									;Sleep 2000
									proximoArbol := detectarProximoArbol(arbolActual, arbolSiguiente, arboles)
									;ToolTip, % "Proximo arbol = " proximoArbol
									;Sleep 2000
									
									;si proximo arbol existe
									;si proximo el proximo arbol esta en una posision diferente al puntero entonces muevo el puntero al proximo arbol
									if (proximoArbol != 0)
									{
										if (punteroPos != proximoArbol.num)
										{
											punteroA(proximoArbol.area)
											punteroPos := proximoArbol.num
										}
									}
									
								
									;Vigilo si ya el arbol no esta
									resultado := arbolActual.estaCortado()
									;ToolTip, % "Arbol actual cortado? = " resultado
									;Sleep 2000
									if (resultado = 1)
									{
										cortandoArbol := false
										;ELIJO PROXIMO OBJETIVO, SACADO DE proximoArbol
										;si proximo arbol no se encontro entonces no existe ArbolObejtivo
										if (proximoArbol = 0)
										{
											arbolObjetivoExiste := false
											arbolObjetivo := 0 ;vacio
										}
										else
										{
											;en caso de que exista un proximo arbol
											;Todavia existe un arborObjetivo, arbolObjetivoExiste := true
											arbolObjetivo := proximoArbol
										
										}
									
									}
									else if (resultado = 0)
									{
										;el arbol sigue en pie
									}
									else if(resultado = -1)
									{
										;se salio de lugar
										;RESET()
										;MsgBox, buelva a la posicion inicial.
										;DETENER()
									}
									else
									{
										;cosa mas loca, esto no debe pasar
										;MsgBox, WTF!
									
									}
									
									
								}
								
							
							}
							else
							{
								;no se esta cortando un arbol. no se hace nada, solo se continua
							}
						}
						else
						{
							;el arbol objetivo no exite todavia
							;ToolTip, arbolo objetivo no existe
							;Sleep 4000
						}
				
					} 
					else
					{
						;Tooltip, Botar activado
						;Sleep 2000
						
						
							;en caso de que el cliente no este marcado como pegado
							if (!clienteNoReacciona)
							{
								;
								;en caso de que el inventaio ya este activo continuo con el botado
								;la funcion botar siguiente no me parece que deba ser parte de la clase inventario, esa logica debe estar definida en otra parte
								Local faltaRecorrido := inventory_botarItemSiguiente()
								if (!faltaRecorrido)
								{
									;Se ha llegado a la ultimo celda. 
									;Debo comprobar si se boto todo antes de continuar. Esto es por si acaso se quedo pegado la ventana.
									if (BarraOpciones.Inventory.estaLLeno())
									{
										;se presume que la ventana esta pegada y hai que esperar hasta que reaccione
										clienteNoReacciona := true
									}
									else
									{
										;la logica de botar item incluye la comprobacion de la tarea. Significa que la bandera de trabajo terminado debe levantarse
										;cuando se ha comprobado que se boto como es debido. Y para comprobar es necesario que el cliente este activo.
										;en caso de que el inventaio no este lleno se presume que se botaron las cosas y el cliente no esta pegado
										;puedo mejorar la presicicion indicando que se boto todo solo cuando TODO LO QUE HABIA YA NO ESTA, eso sirve para cuando el cliente se queda 
										;pegado en medio de un botado, esperar a que todo se bote para continuar es una forma de hacerlo. Un problema con este es que siempre se esperar a que
										;todo se caiga para continuar con la tarea, incluso en ocasiones que no se esperarn como cuando un cliente que estaba pegado ya reacciono y ya se puede continuar
										;pero no se continua sino hasta que se haya botado todo.
										botarItems := false ;ya se botaron todos los items
										;desde aqui se presume que todo esta reseteado
									}
									
								}
							}
							else
							{
								;en caso de que el cliente se presuma pegado
								;compruebo constantemente si el invetario se bota, esto indica que el cliente ya no esta pegado
								if (BarraOpciones.Inventory.estaLLeno())
									{
										;se presume que la ventana esta pegada y hai que esperar hasta que reaccione
										clienteNoReacciona := true
									}
									else
									{
										;si el inventario ya no esta lleno se presume que el cliente reacciono
										clienteNoReacciona := false
									}
							
							}
						
				
						
					}
				
					if (_DETENER)
					{
						;El script ha recivido la orden de detener, Ojo no es la _CERRAR
						MsgBox, Detenido.
						Break
					}
					Sleep 10
				} ;fin del loop
					
				
				
				
			}
			else
			{
				;Los arboles no han sido identificados
				ToolTip, Error. Los arboles no han sido cargados.
				sleep 8000
			}
			
			

		}
		else
		{
			MsgBox, Defina un area para cada arbol que quiera cortar.
		}
			
	
	
	}
	else
	{
		;no se han cargado los componetes, quisas deba enviar un msg
		return 0
	}
	
	
	

} ;fin de funcion principal

;mejor seria COMPONENTES:= [GLOBAL, BARRA, CHAT ETC]. CARGAR_COMPONENTES(COMPONENTES) Y LISTO!!!
;carga los componentes que voy a usar en este script
cargarComponentes()
{
	Global
	if (cargar_InterfaceGlobal() = 1)
	{
		if (cargar_BarraOpciones() = 1)
		{	
			;se cargaron los componentes :)
			COMPONENTES_CARGADOS := true
			return 1
		}
		else
		{
			return 0
		}
	}
	else
	{
		return 0
	}	
} ;fin de funcion


;crea un arbol por cada area, devuelve 0 si algun arbol no se pudo cargar
crearArbolPorArea(Areas)
{
	Global
	Local arboles := []
	Local estado := [] ;para guardar el estado de los arboles, respondido por el usuario
	Local cG
	;Esto debe funcionar diferente
	;Para cada area se le pide al usuario cierta informacion
		;Estado del arbol
			;activo o inactivo
	
		
	loop, % Areas.length()
	{
		;Devuelve lo que respondio el usuario
		;las preguntas deben ser parte de la gui, pero deben estar al frente
		;0x20+0x04
		MsgBox, 0x24, Debes responder: , ¿El arbol %A_index% esta en pie en este momento?,
		WinActivate, ahk_id %VENTANA_EN_USO%
		WinWaitActive, ahk_id %VENTANA_EN_USO%
		PixelGetColor, cG, (Areas[A_index].x1 +((Areas[A_index].x2 - Areas[A_index].x1)//2)), (Areas[A_index].y1 +((Areas[A_index].y2 - Areas[A_index].y1)//2))
		IfMsgBox, Yes
		{
			;necesito el punto en el centro del area es el x1 + (ancho//2) con ancho x2 -x1
			;(Areas[A_index].x2 // 2) esto
			arboles[A_index] := new _Arbol(A_index, Areas[A_index], cG, "", (Areas[A_index].x1 +((Areas[A_index].x2 - Areas[A_index].x1)//2)), (Areas[A_index].y1 +((Areas[A_index].y2 - Areas[A_index].y1)//2)))
		}
		else
    	{
			;el arbol esta cortado
			arboles[A_index] := new _Arbol(A_index, Areas[A_index], "", cG, (Areas[A_index].x1 +((Areas[A_index].x2 - Areas[A_index].x1)//2)),  (Areas[A_index].y1 +((Areas[A_index].y2 - Areas[A_index].y1)//2)))
		}
		
		;esto debe suceder dentro de la ventana de runescape, debo entrar antes de buscar el color
		
		;Devuelve BGR
		;El punto para buscar el pixel o el indicador, sera el del centro, o cercano al centro porque es truncado
		
		
		;se fijo el color activo o el inactivo dependiendo de lo que responda el usuario (Son brebes configuraciones...)
		
	}		
	;si no hubo algun error
	return arboles
	
			
} ;fin de funcion






;Comiensa a cortar un arbol, sinonimo de clickA
cortarArbol(ByRef arbol)
{
	Global
	punteroA(arbol.area)
	pausaMin()
	click
	;debe ser clickA(arbol.area)
}
;devuelve el objeto arbol mas proximo que este en pie
detectarProximoArbol(Byref Actual, Byref Siguiente, Byref Todos)
{
	Global
	;tal parece que no necesito a Actual
	;busca entre TODOS (incluso el actual) comensando desde SIGUIENTE al arbol PROXIMO
	Local i := Siguiente.num
	Local result := 0
	;recorres el tamanio completo, desde el siguiente hasta el actual
	loop, % Todos.length()
	{	
		;comienso desde siguiente
		result := Todos[i].estaCortado()
		;ToolTip, % "arbol " A_index "cortado? = " result
		;sleep 4000
		if (result = 0)
		{
			;el arbol no esta cortado
			return Todos[i]
		}
		else if(result = -1)
		{
			MsgBox,Error.Fallo funcion estaCortado() en detectarProximoArbol.
		}
		;si i indica al ultimo arbol entonces debe pasar a indicar el primero
		if (i < Todos[Todos.length()].num)
		{
			i++
		}
		else
		{
			i := Todos[1].num ;resulta que es igual a i := 1
		}
	}
	
	;si los recorri todos y ninguno estaba en pie, significa que todos los arboles estan cortados.
	;en ese caso return 0 indica tal situacion
	return 0
}

;decide que arbol sigue despues del actual, porque conoce todos los arboles. Deberia retornar el arbol, no su numero
siguienteEntreArboles(ByRef ArbolActual, ByRef TodosLosArboles)
{
	Global
	Local max, min, actual
	;como la func es global creo que puedo hacer max := arboles.length()
	max := TodosLosArboles.length()
	min := 1 ;el inicial es el primero de todos los arboles, normalmente el 1
	actual := ArbolActual.num
	if (actual < max)
	{
		;actual es menor a maximo
		if (actual >= min)
			{
				;actual es menor a maximo, y mayor o igual min
				actual++
			}
			else
			{
				;actual es menor a min, es algo bien raro que no debe pasar, pero por si las moscas return min
				actual := min
			}
	}
	else
	{
		;si actual no es menor a max, significa que es igual o mayor
		if (actual = max)
		{
			actual :=  min
		}
		else if (actual > max)
		{
			;aqui paso algo raro que no debio haber pasado
			actual := min
		}		
	}
	;ToolTip, % "siguiente entre arboles =" actual
	;Sleep 3000
	
	loop, % TodosLosArboles.length()
	{
		if (TodosLosArboles[A_index].num = actual)
		{
			;ToolTip, % "siguiente entre arboles =" A_index
			;Sleep 3000
			return TodosLosArboles[A_index]
		}
	}
	return 0 ;hubo un error
}


;Elige un arbol de entre los posibles de forma aleatoria. si dicho arbol no esta en pie se busca el primer arbol en pie (CUALQUIERA) de entre los posibles y lo retorna
eligeArbolObjetivo( ByRef arboles)
{
	Global
	Local resultado := 0
	Local i := 0
	Local cuenta := arboles.length()
	;ToolTip, eligiendo arbol objetivo
	;Sleep 1000
	Random, i, 1, cuenta
	
	if (arboles[i].estaCortado() = 0)
	{
		return arboles[i]
	}
	else
	{
		loop, % cuenta
		{
			resultado := arboles[A_index].estaCortado()
			if (resultado = 0)
			{
				return arboles[A_index]
			}
			else if(resultado = -1)
			{
				MsgBox, Error. fallo funcion estaCortado() en eligeArbolObejtivo.
			}
			else if(resultado = 1)
			{
				;el arbol esta cortado, debe buscar otro
				;return 0
			}
		
		}
	
		;si ningun arbol esta activo return 0 debe indicar ese estado
		return 0
	
	}
	
	;en caso de que ninguno este en pie para el momento , retorno 0
	return 0
}



;esta funcion no debe se parte de este documento
;cada ves que es ejecutada bota el item que se le indico
;Mejor que haga click en el, y activando shift se hace de esto un botado
;Devuelve 1 si aun quedan items por botar, devuelve 0 cuando ya no quedan items
;funcion de logica del sistema que utilisa las interfaces para llevar una operacion repetitiva a cabo. 
inventory_botarItemSiguiente()
{
	Global
	;se presume que la barra de opciones ya existe, porque esto solo se usa en ese caso. Pero por si acaso yo lo voy a verificar
	;antes de botar el siguiente item me aseguro de que la ventana del inventario este activado, activar(BarraOpciones.opcion[4])
	if (InterfaceGlobal.existe)
	{
		if(BarraOpciones.existe)
		{
			;continuo con todo lo mio
			static primeraEjecucion := true
			static actual:= 1
			Local estaBloqueada := false
			Local CELDAS_BLOQUEADAS := BarraOpciones.Inventory.CELDAS_BLOQUEADAS
			
			;tooltip, actual igual %actual%
			;sleep 1000
				
				
			if primeraEjecucion
			{
				Send {Shift down}
				;tooltip, shift down
				sleep 1000
			}

			;Se presume que todas las casillas estan llenas. Las que estan bloqueadas siempre se consideren llenas aunque no lo esten realmente
			;compruebo si la celda actual esta bloqueada
			;si creo una propuedad en cada celda para saber si esta bloqueada seria tan facil como, if celda actual.establoqueada, no hagas nada y listo!
			loop, % CELDAS_BLOQUEADAS.length()
			{
				;evaluo si la casilla actual esta bloqueada
				
				if (CELDAS_BLOQUEADAS[A_index] = actual)
				{
					estaBloqueada := true
				}
						
			}
					
			if !estaBloqueada
			{
				;si la casilla no esta bloqueada, ya puedo botar  lo que hay en ella. Pero primero me aseguro de que el inventario esta activo. Y quisas deba agregar otra comprobacion para saber
				;si hay algo actualmente en la casilla.Se puede botar en toda casilla que haya algo, siemrpe que no este bloqueada.

				if (!BarraOpciones.opcion[4].estaActiva() )
				{
					;ToolTip, el inventario no se detectado
					Sleep 3000
					;espero un tiempo de unos 3 segundos porque es estraño que el inventario no este activo: puede ser intervencion humana o quien sabe que
					Sleep 3000
					punteroA(BarraOpciones.opcion[4].area)
					pausaMin()
					click
					;Despues hay que esperar que la opcion se active, aun no se cuanto tiempo es lo normal
					Sleep 1000
				}
				punteroA(BarraOpciones.Inventory.celda[actual].area, 1)
				pausaMin()
				Click
				;CELDAS_LLENAS[actual] := false ;la casilla actual ya no esta llena, esto ya no lo estoy usando
							
			}
					
				
				
				
				if actual = 28
				{
					sleep 100 ;espero 100 para darle tiempo suficiente a punteroA() de realisar su accion.
					Send {Shift up}
					;tooltip, shift up
					sleep 1000
					actual := 1
					primeraEjecucion := true
					return 0 ;botado de items terminado

				}
				actual++ ;el limite es 28
				primeraEjecucion := false
				return 1 ;indica que todavia quedan items por botar. o mejor dicho, que no se ha llegado a la celda final
		
		}
		else
		{
			;WTF no se puede botar si la barra de opciones no existe
			ToolTip, Error
			return 0
		}
		
	}
	else
	{
		;WTF no se puede botar si la interfaceGlobal no existe en un principio
		ToolTip, Error
		return 0
	
	}
	
} ;fin de funcion





;todos[i].siguienete decuelve el arbol siguiente, porque cada arbol sabe quien le sigue, de esta forma puedo hacer una lista circular
;podre hacer arboles.LIST() con una funcion LIST() que no pertenece a arboles?. seia algo asi LIST(THIS) ETC RECIVE el objeto para listar
;no funciona tipo toggle so es un boton de presion.
detener()
{
	Global
	_DETENER := true
}
	
^i::
	ini_script()
return

^a::
	defineArea()
return

esc::
	exitapp
return

;todas las teclas ecepto las ya definidas deben detener el script. Pero por el momento con spacion basta.
;el prefijo indica que la tecla espacion opera normalmente y a la ves activa detener()
;~Space::
Space::
	detener()
	;debe apagar la alarma en caso de que este activa
	;apagarAlarma()
return

^r::
	reload
return
