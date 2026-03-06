;El objetivo es diseñar todas las funciones que pueda acceder a la informacion de la interface. Esta sera usada por otras funciones para definir operaciones.

/*
	debo incluir solo datos de las interfaces como :
		-las posiciones relativas a la ventana:
			constante x , la posicion relativas a la ventana no cambian, lo que puede cambiar es la posicion de la ventana , pero eso debe ser manejado por el ENTORNO
			constante y
			
		-los identificadoes
		constante	nombre 
		constante id:
		
		-las caracteristicas utiles:
		color de la base, no de los componentes
		constante margen
		constante width
		constante heigth
		
		-Listar los componentes
			constante componentes[]
		;debo identifcar las variables que tiene una interface;  cuales son dinamicas (necesitan actualisacion constante porque cambian con el tiempo) y cuales son constantes(no cambian con el tiempo)
		
la interface cliente esta compuesta de las siguientes subInterfaces
	-InterfaceGlobalContenedora
			_MenuBarraChat:
				_Public, para escribir msg
				_Trade, para aceptar o hacer trade
				_Game, para leer msj del juego (you has mine some rock!)
			_MenuBarraOpciones
				1_CombatOptions
				2_Skills
				3_QuestList
				4_Inventory
					-abierto/cerrado
					-todas las casillas permitidas llenas
					-celdas bloqueadas
				5_WorndEquipment
				6_Prayer	
				7_Magic
				8_FriendList
				9_AccountManagement
				10_ClanChat
				11_Options
				12_Emotes
				13_MusicPlayer
				
				
			_MenuMiniMapa
				_CerrarRS
				_Brujula
				_MinitorEXP
				_Vida
				_Prayer
				_Energia
				_HabilidadArma

La interface principal es la interface global contenedora, esta contiene la parte visible de runescape, en ella se pueden encontrar todas las demas interfaces utiles.



*/

;las interfaces reflejan la posicion d cada cosa, y contiene toda esa informacion.
;la logica asociada a las interfaces(todo codigo destinado a recuperar informacion y ejecutar acciones) deberia ser apartado de la clase?
;Los metodos de inventario deberian ser apartados de la interface Inventory?
;Por el momento creo que los definire juntos, con el objetivo de hacer Inventory.botarItemSiguiente() 



#include Nucleo/Monitor.ahk
#Include Nucleo/NuevoEntorno.ahk
class _InterfaceCliente
{
        ID := 0 ;para que la maquina la identifique con facilidad
		interfacePadreID := 0 ;0 es el screen
        nombre := "" ;para yo identificarla con facilidad
        x:= 0 ;pos x
        y := 0 ;pos y
        ancho := 0 ;el width
        largo := 0 ;el heigh
		existe := false
       ; interfacesHijo ;lista de todas las interfaces que contiene
}

;La interfaceGlobal lo posee todo, y cada sub interface debe poseer sus coordenadas relativas a esta.Si un componente contiene otro de igual forma solo la interfaGlobal se usa para definir su posicion
;las variables de las interfaces deben ser locales y no tener relacion con globales
class _InterfaceGlobalContenedora extends _InterfaceCliente
{
	Monitor := {}
	__New(x, y, width, heigth, padre)
	{
		;posicion relativa a su padre, en este caso el padre de esta inteface es la ventana de runelite, esa pos es muy importante porque ayudara a conocer la pos de todas las demas 
		ID := 1
		this.nombre := "interfaceGlobalContenedora"
		this.x := x
		this.y := y
		this.ancho := width
		this.alto := heigth
		this.interfacePadreID := padre
		this.Monitor := new _Monitor(x, y)
		this.existe := true
		
	}
}

;las clases incorporan un obejto monitor, es un objeto solo para las interfaces y no debe ser usado en algun otro lado



;Como las clases se declaran como objetos globales al inicio del script, al llenarlos de informacion estas se carga de forma automatica. Pero esto es un problema de eficiencia, si no yo no voy a usar una 
;sub interface entonces no debo cargar nada de ella, debo dejarla tan vacia como pueda

;como saber si un objeto se formo con exito, y como saber si exiten dichas propiedades en un objeto.
;Lo que pasa es que nevesito hacer comprovaciones de los objetos que voy a usar para crear otros a la ves que nevesito comprobar que un objeto se formo con todas sus variables y metodos.
class _MenuBarraOpciones extends _InterfaceCliente
{
	;##################################################
	;buscar la posicion relativa de la barra segun la interface global
	;x603 y 467 -- con tamanio x1032 y503
	;xRelativaInterfeceGlobal := interfaceGlobalContenedora.ancho - 429
	;yRelativaInterfeceGlobal :=interfaceGlobalContenedora.alto - 36
	;##################################################
	;buscar el ancho y largo de las opciones.
	;ancho d636-h669,d735 h767: alto d467-h502  
	;ancho = 34-33 ;parece que algunas opciones tienen un acho un poco mas grande
	;alto = 36 ;parece que todas las opciones tienen la misma altura
	;##################################################
	;buscar el color base de las opcines, y el color cuando cambia a estado activo, y un punto de referencia que sea igual para todas las opciones de la barra
	;color normal 627481, activo 1d2671
	
	;para inidicar cual opcion esta activa en el momento, debe ser monitoreada?
	;opcionActiva := 0
	opcion := []
	Monitor := {} ;una referencia al objeto monitor global, quisas no sea una referencia!
	Inventory := {}
	__New(ByRef InterfaceGlobal)
	{
		Global
		;dependiendo del tamanio disponible en interfaceGlobalContenedora variara la posicion de la barra
		
		this.ID := 11
		interfacePadreID := InterfaceGlobal.ID
		nombre := "MenuBarraOpciones"
		;la posicion debe ser relativa a la ventana, para conocerla tambien necesito la pos de la interfaGlobal
		this.x :=  InterfaceGlobal.ancho - 429 + InterfaceGlobal.x 
		this.y := InterfaceGlobal.alto - 36 + InterfaceGlobal.y
		;debo asegurarme de que el monitor se pase por referencia y no por valor
		this.Monitor := interfaceGlobal.Monitor
		this.existe := true ;deberia esperar al final
		
		caracteristicasOpciones := {alto:36, ancho:33, colorBase:"0x627481", colorActivo:"0x1D2671"}
		this.alto := caracteristicasOpciones.alto
		this.ancho := ((caracteristicasOpciones.ancho * 13 )-1)
		;opcionList := {4:_InventarioNormal}
		

		;defino las propiedades de cada opcion individualmente, solo en caso de que sea diferente en algunas opciones
		;pi son las pociciones relativas de los indicadores para cada opcion
		pi := []
		pi[1] := [16, 4]
		pi[2] := [25, 14]
		pi[3] := [4, 4]
		pi[4] := [4, 4]
		pi[5] := [ 4, 16]
		pi[6] := [5, 5]
		pi[7] := [5,5]
		pi[8] := [4,4]
		pi[9] := [26,8]
		pi[10] := [5, 9]
		pi[11] := [5,10]
		pi[12] := [ 5, 16]
		pi[13] := [12, 3]
		
		;ci son los colores activo y base, que se esperan en los indicadores de cada opcion, en BGR
		cI := []
		cI[1] := ["0x5A6A74","0x192264"]
		cI[2] := ["0x41494D","0x10153C"]
		
		cI[3] := ["0x627481","0x1B246B"]
		cI[4] := ["0x627481","0x1B246B"]
		cI[5] := ["0x5E717C","0x1B246B"]
		cI[6] := ["0x697C8A","0x1D2671"]
		
		cI[7] := ["0x697C8A","0x1D2671"]
		cI[8] := ["0x627481","0x1B246B"]
		cI[9] := ["0x3B454A","0x10153C"]
		
		cI[10] := ["0x697C8A","0x1D2671"]
		cI[11] := ["0x697C8A","0x1D2671"]
		cI[12] := ["0x5A6A74","0x192264"]
		cI[13] := ["0x5F7381","0x1B246B"]
		
		;Defino pos, area y color de cada opcion, ;son en total 13 opciones en la barra de opciones.
		;Tambien defino pos de cada indicador.
		Local x1 := this.x
		Local y1 := this.y
		Local y2 := y1 + caracteristicasOpciones.alto 
		Local x2 := 0
		;con esto puedo hacer punteroA(BarraOpciones.opcion.1.area) ; .area puede ser suprimido si averiguo como hacer que un objeto devuela un resultado predeterminado
		loop, 13
		{
			Local x2 := x1 + caracteristicasOpciones.ancho 
			;la pos del indicador varia para cada opcion
			;la pos de cada opcion esta ecpresada en coordenadas relativas a la interfaGlobal, pero deben estar expresadas segun la Ventana, para esto debo sumar la pos de la interfaceGlobal
			this.opcion[A_index] := new this._opcion(x1 , y1 , x2, y2, interfaceGlobal.Monitor.agregarIndicador(x1 + pi[A_index][1], y1 + pi[A_index][2]), cI[A_index][1], cI[A_index][2], interfaceGlobal.Monitor)
			
			;Debo asegurarme de que al iniciar cada indicador su color actual coincide exactamente con su color base o su colo activo,
			;de lo contrario mandar error y decir, error de inicialisasion, imposible iniciar la barraOpciones
			;porque no se encontro el indicador de la opcion X.
		
			/*
			;ahora verifico el indicador 
			cA := ""
			cA := _Monitor.colorActualIndicador(this.opcion[A_index].indicadorID)
			
			if (cA = cI[A_index][1] or cA = cI[A_index][2])
			{
				;el incicador tiene un color conocido, todo bien
			
			}
			{
				;algo a pasado y el color del indicador no es normal. Puede que sea un error al calcular las coordenadas o algo.
				MsgBox  Error de inicialisasion. Imposible iniciar la barra de opciones porque el indicador de la opcion %A_index% no tiene un color valido.
				;ahora tengo que detener la creacion de la barra de opciones, pero como?
				this.existe := false
				;el objeto aun posee datos, esto se puede resolver creando una funcion this.borrarTodo()
				return ""
			}
			
			*/
			
			;tooltip, % this.opcion[A_index].x
			;sleep 1000
			x1 := x2 
		}
		
		;paso a crear cada ventana Inventory, Magic etc
		;Puedo pasarle la interfaceGlobal solamente, ya que esta contiene al monitor global. Aparte de eso ya es posible crear al Monitor aparte de la Interface GLobal, para que esten separados y esto me parece mas logico
		
		this.Inventory := new this._Inventory(interfaceGlobal ,interfaceGlobal.Monitor)
		
		
		
		
		
		
		;BarraOpciones.Monitor.Actualisar() cada indicador de la barra de opciones. ; esto no tiene logica por ahora, pero quiero crear algo similar
		
		
		;o if BarraOpciones.opcionActiva = Magic.OpcionPos entonces se tien abierta la ventana Magic, pero esto requiere mantener actualisada la variable opcionActivas
		;enrealidad quiero hacer BarraOpciones.Magic_Ventana.enchantlv3
		
		;puedo definir la clase para la ventana. y cada ventana debe tener un ID, y una relacion entre su opcion como OpcionID, para saber a que opcion corresponden, lo unico que nesecito de la ventana es la posicion,
		;las posiciones de la ventana son globales para todas las opcines, pero los componentes de cada ventan de opcion varian
	
	
		;BarraOpciones.Magic.ventana esto devuelve el area de la ventana de Magic, estoy pensando en BarraOpciones.Magic devuelva el area de la ventana, para saber si esta activa debo usar la relacion con la opcion en la barra
	

		;si hago BarraOpciones.Magic me estoy refiriendo a la ventana
		;si hago BarraOpciones.Opcion.4 me estoy refiriendo al boton
		;ambas guardan relacion logica, cuando boton esta activo entonces ventana existe, una ventana esta activa siempre que su opcion correspondiente este activa
		
		
		
	}
	
	insertarOpcionActiva(opcionID)
	{
		this.opcionActiva := opcionID
	}
	
	;BarraOpciones.opcionActiva(), lee los indicadores de cada opcion en busca de la opcion activa y retorna el Num de la Opcion
	opcionActiva()
		{
			Global
			Local resultado
			;Se que son exactamente 13 opciones, ni mas ni menos, y cuento con ello.Solo una esta activa a la vez
			loop, 13
			{
				resultado := this.opcion[A_index].estaActiva()
				if (resultado = true)
				{
					return, A_index
					;Tooltip, % "Op " A_index " = " BarraOpciones.opcion[A_index].estaActiva()
				}
				
			}
			;en caso de que ninguna opcion tenga un valor true devuelvo 0
			return 0
			
		}
		
	
	
	


	class _Inventory
	{
		ID := 0
		nombre := ""
		opcionID := 0
		interfacePadreID := 0
		x := 0
		y := 0		
        ancho := 0
        largo := 0
        margenInternoIzq := 0
        margenInternoArr := 0
        colorBase := "0x29353E" ;es tambien el colorBase de todas las celdas
        celda := []
		Monitor := {} ;espero que sea una referencia al monitor global, y que no sea una copia
        ;ventanaPadre
        ;creo que tambien le voy a tener que pasar el monitor global
		CELDAS_BLOQUEADAS := [] 
        __New(ByRef InterfaceGlobal, ByRef MonitorGlobal)
        {
			Global
			this.ID := 114
			this.nombre := "Inventario"
			this.opcionID := 4
			this.interfacePadreID := InterfaceGlobal.ID
			;las posiciones de la ventana Inventory son relativas a la InterfaceGlobal, la ventana SunAwtFrame2
            this.x := InterfaceGlobal.ancho - 204 + InterfaceGlobal.x
            this.y := InterfaceGlobal.alto -311 + InterfaceGlobal.y
			this.ancho := 200
			this.alto := 280
			this.margenInternoIzq := 13
        	this.margenInternoArr := 11
			this.colorBase := "0x29353E"
			this.Monitor := MonitorGlobal ; &MonitorGlobal?
			this.CELDAS_BLOQUEADAS := [29] ;la casillas 1, 2 y la 3 estan bloqueadas, su contenido no sera botado, esto es una constante
            ;comienso a ubicar cada celda
            Local x1 := this.x + this.margenInternoIzq
			Local y1 := this.y + this.margenInternoArr
            caracteristicasCelda := {ancho:32,alto:32 ,margenArriba:4, margenIzquierdo:10}
            count := 1
			;7 filas
			loop, 7
			{	
				y1 := y1 + caracteristicasCelda.margenArriba
				y2 := y1 + caracteristicasCelda.alto
				;4 columnas
				loop, 4
				{
					
					x1 := x1 + caracteristicasCelda.margenIzquierdo
					x2 := x1 + caracteristicasCelda.ancho
					
					this.celda[count] := {x:x1, y:y1, area:{x1:x1, y1:y1, x2:x2, y2:y2}, ancho:caracteristicasCelda.ancho, alto:caracteristicasCelda.alto, indicadorID: this.Monitor.agregarIndicador(x1+16, y1+16)}
					x1 := x2
					count++
				}
				y1 := y2
				x1 := this.x + this.margenInternoIzq
			}	
				
        }
        
		;Antes era actualisar, pero no planeo ocupar tanto procesamiento en actualisarlo a cada rato.Devuel un verdadero o falso
        estaLLeno()
		{
			Global
			;Local TODAS_LAS_CELDAS_PERMITIDAS_LLENAS := true
			Local estaBloqueada := false
			Local CELDAS_LLENAS := [] ;contraparte de cada celda para indicar cuales estan llenas
			Local i := 1
			;esta verga siempre es 28, pa que conio lo hago asi?
			loop, % this.celda.length()
			{
				estaBloqueada := false	
				;Busco si la celda i esta bloqueada
				loop, % this.CELDAS_BLOQUEADAS.length()
				{
					if (this.CELDAS_BLOQUEADAS[A_index] = i)
					{
						estaBloqueada := true
						;MsgBox, celda %i% esta bloqueada
						break
					}
				}
				
				if !estaBloqueada
				{
					;color base es el color base del inventario, y por consiguiente tambien de todas las celdas
					if (this.Monitor.colorActualIndicador(this.celda[i].indicadorID) != this.colorBase)
					{
						;si el indicador cambio significa que esta casilla esta llena
						CELDAS_LLENAS[i] := true 
						;si una casillas esta llena debo saber que contiene, esto lo are despues porque puede perjudicar el rendimiento, y no es necesario ahora mismo
					}
					else
					{
						;si el indicador no cambio entonces esta celda esta vacia
						;MsgBox, celda %i% esta vacia
						;sleep 2000
						CELDAS_LLENAS[i] := false
						;como existe una casilla permitida que esta vacia, entonces TODAS_LAS_CASILLAS_LLENAS es falso
						;TODAS_LAS_CELDAS_PERMITIDAS_LLENAS := false
						;MsgBox, todas las celdas permitidas llenas falso
						return false ;hay una celda permitida que no esta llena
						
					}
					
				}
				else
				{
					;en caso de que este bloquada igual compruebo si esta llena
					;El codigo que sigue es redundate he innecesario, se puede hacer CELDAS_LLENAS[I] := TRUE Y LISTO!
					/*
					if (this.Monitor.colorActualIndicador(this.celda[i].indicadorID) != this.colorBase)
					{
						;si esta llena y bloqueada la anoto en celdsa llenas, igual las celdas bloqueadas siempre tienen que estar en modo llenas
						;punteroA(INVENTARIO_NORMAL.celda[i].area)
						;MsgBox, celda %i% esta llena
						
						;sleep 2000
						;si el indicador cambio significa que esta casilla esta llena
						CELDAS_LLENAS[i] := true 
						;si una casillas esta llena debo saber que contiene, esto lo are despues porque puede perjudicar el rendimiento, y no es necesario ahora mismo
						
					}
					else
					{
						;si la celda esta vacia pero esta bloqueada la marco como una casilla llena, porque estas celdas no se cuentan, nunca se botaran
						;punteroA(INVENTARIO_NORMAL.celda[i].area)
						;si el indicador no cambio entonces esta celda esta vacio
						;MsgBox, celda %i% esta vacia
						;sleep 2000
						CELDAS_LLENAS[i] := true
					}
					*/
					CELDAS_LLENAS[i] := true ;esta celda esta bloqueada y no importa que contenga, no se botara, se marca como llena para efectos de comprobar si todas las casillas estan llenas
		
		
				}
		
				i++
		
			}
			;recorri todas las celdas y no halle una que no este llena
			return true ;todas las casillas permitidas llenas
			
	
		
		
		
		
		} ;fin de funcion
		
		;la funcion botar siguiente no me parece que deba ser parte de la clase inventario, esa logica debe estar definida en otra parte
		;Debe botar el item que esta seleccionado actualmente hasta que se hayan botado todos
		;botarItemSiguiente()
		
		
	
		
		
		
		
        ;_actualizar()
        ;_botarItemSiguiente()
        ;_bloquearCelda(i,j,k)
		;_botarItem(i, j)
	
	
	
	}



	;devo buscar que la memoria no se gaste si no se va a usar esto. Todo de iniciar vacio
	class _opcion
		{
			
			x := 0
			y := 0
			area := {}
			colorActivo := ""
			colorBase := ""
			indicadorID := 0
			Monitor := {}
			
			;son varias opciones, como puedo definir una poscion estatica para cada una. Quierio hacerlo porque no me parece logico pasarle la posicion a cada opcion, o quisas si es mas logico! tengo que pensarlo mas, per tal como esta funciona
			__new(x1, y1, x2, y2, indicadorID, colorBase, colorActivo, ByRef Monitor)
			{
				;la posicion de cada opcion depende inicialmente de la posicion de la barra de opciones. Puedo suprimir la entrada de esa informacion
				this.x := x1
				this.y := y1
				this.area := {x1:x1, y1:y1, x2:x2, y2:y2}				
				this.indicadorID := indicadorID
				this.colorBase := colorBase
				this.colorActivo := colorActivo
				this.Monitor := Monitor
			}
			
			;busca si esta opcion esta activa, puedo hacerlo con un rastre en el area o con una lectura de indicador, eligo lo segundo porque es mas rapido
			
			estaActiva()
			{
				;Como pixel get color  actua segun las coordendas de la ventana, el monitor conoce las coordenadas de la ventana y traduce las coordenadas relativas a la interfaceGlobal a relativas a la ventana.
				;debo asegurarme de conocer al objeto monitor de la clase superior a esta
				;Tooltip, % "En funcion esta activa. Monitor tiene xG = " this.Monitor.xG
				;sleep 5000
				;las variables no debe tener nombre parecidos a variables Globales, o debe restringirse a que todo aqui es local
				
				colorEnIndicador := this.Monitor.colorActualIndicador(this.indicadorID)
				;tooltip, % c
				;sleep 1000
				if (colorEnIndicador  = this.colorBase)
				{
					return false
				}
				else if(colorEnIndicador = this.colorActivo)
				{
					return true
				}
				else
				{
					;Tooltip, % "c = " c "colorBase = " this.colorBase "colorActivo = " this.colorActivo
					;sleep 1000
					;el color no se reconoce
					 return -1
				}
			}
		}


	/*
	actualisar()
	{
		;opciones.indicador
	
	
	}
	
	
	
;por el momento solo quiero probar el inventario normal y la barra de opciones
	class _Magic
	{
		opcionID := 7
		opcionPosX := 
		opcionPosY := 
		opcionAncho := 
		opcionAlto := 
		opcionColorBase := 
		opcionIndicador := new Indicador(opcionPosX+ , opcionPosY+, opcionColorBase)
		contenedorPosX :=
		contenedorPosy :=
		contenedorAncho
		contenedorAlto
		celda := [] ;celdas o componentes, cada celda puede ser un objeto con nombre de spell, id, y tamanio de celda o area, y pos
		spellList := ["confuse", "enchantlvl1",,]
		__New(x, y)
		{
			
		celda[i] := {spellID:, x:, y:, area:, spellNombre:spellList[i], }
		celda[celda[i].spellNombre] := ByRef celda[i]
		
		celda[1].area
		celda[enchantlvl4].area
		
		}

	}
	*/

	
} ;fin de class










;crea un objeto global llamado InterfaceGlobal, es parte de interface, porque es parte de su logica
;devuelve 1 en caso de que la interface se cargue con exito, 0 en caso contrario
cargar_InterfaceGlobal()
{
	Global
	cargarEntorno()
	if EXISTE_ENTORNO
	{
			
				;defino las acciones a tomar para el caso de cada cliente
				;el 100% de los casos NOMBRE_PROCESO_EN_USO es un tipo de cliente valido
				switch (NOMBRE_PROCESO_EN_USO)
				{
					case "RuneLite.exe":
						;Detecto la posicion de la frame conocida como SunAwtCanvas2,la misma esta dentro de la ventana de runelite SunAwtFrame
						Local Control := 0
						Local X, Y, anchoControl, altoControl
						ControlGet, Control, Hwnd, , SunAwtCanvas2, ahk_id %VENTANA_EN_USO%
						;en caso de que no detecte o no consiga la interface que busco debo mandar un error.Se puede usar ErrorLevel, se pone en 0 en caso de todo bien y en 1 en caso de que aya error
						if (Control)
						{
						
							ControlGetPos, X, Y, anchoControl, altoControl, , ahk_id %Control%
							;esto crea la global InterfaceGlobal
							InterfaceGlobal := new _InterfaceGlobalContenedora(X, Y, anchoControl, altoControl, Control)
							return 1
						}
						else
						{
							MsgBox, Error en la creacion de los componentes. No se pudo encontrar la interface que contiene el cliente runescape.
							return 0
						}
						
						
						
						
						
						
										
					case "OSbuddy.exe":
					return
					case "OldSchool.exe":
					return
					default:
					return 0
				}
	}
	else
	{
		MsgBox El entorno no se ha definido. No se puede continuar
		return 0
	}
} ;fin de funcion


cargar_BarraOpciones()
{
	Global
	if (InterfaceGlobal.existe)
	{
		BarraOpciones := new _MenuBarraOpciones(InterfaceGlobal)
		return 1
	}
	else
	{
		MsgBox, No se puede continuar porque la InterfaceGlobal no esta definido.
		return 0 ;indica un error
	}
} ;fin de funciones




























;activar(BarraOpciones.opcion[4])








prueba_interface()
{
	GLobal
	if (InterfaceGlobal.existe)
	{
		;defino las interfaces que voy a usar
		BarraOpciones := new _MenuBarraOpciones(InterfaceGlobal)
		
		;pruebo las interfaces
		MouseMove InterfaceGlobal.x, InterfaceGlobal.y, 20
		Sleep 2000
							
		MouseMove, BarraOpciones.x, BarraOpciones.y, 20
		Sleep 2000
						
		Tooltip, Probando Posiciones
		Sleep 2000
		loop, % BarraOpciones.opcion.length()
		{
			MouseMove, BarraOpciones.opcion[A_index].x, BarraOpciones.opcion[A_index].y
			Sleep 2000
			;Asi no deben indicarce los indicadores, pero es curioso que la clase padre contenga esa informacion. puedo suponer que padre recoje todo, eso es util
			MouseMove, BarraOpciones.Monitor.indicadores[A_index].x, BarraOpciones.Monitor.indicadores[A_index].y
								
			PixelGetColor, c, BarraOpciones.Monitor.indicadores[A_index].x , BarraOpciones.Monitor.indicadores[A_index].y
			if(c = BarraOpciones.opcion[A_index].colorBase)
			{
				Tooltip, el color base coincide
			}
			else
			{
				Tooltip, % "El color base no coincide actual = " . c . "base = " . BarraOpciones.opcion[A_index].colorBase
			}
			Sleep 8000
			Click
			Sleep 2000
								
			PixelGetColor, c, BarraOpciones.Monitor.indicadores[A_index].x , BarraOpciones.Monitor.indicadores[A_index].y
			if(c = BarraOpciones.opcion[A_index].colorActivo)
			{
				Tooltip, el color activo coincide
			}
			else
			{
				Tooltip, % "El color activo no coincide actual = " . c . "activo = " . BarraOpciones.opcion[A_index].colorActivo
			}
			Sleep 8000
			;Tooltip, % BarraOpciones.opcion[A_index].indicadorID
			;Tooltip, % _Monitor.indicadores[A_index].x
			;Tooltip, % "Opcion " . A_index . " estaActiva = " . BarraOpciones.opcion[A_index].estaActiva()
		}
							
							
					
		Tooltip, Probando funcion estaActiva()
		Sleep 2000
		loop, 100
		{
			loop, 13
			{
				if (BarraOpciones.opcion[A_index].estaActiva())
					{
						Tooltip, % "Op " A_index " = " BarraOpciones.opcion[A_index].estaActiva()
					}
				Sleep 30
			}
								
		}
							
		Tooltip, Probando funcion opcionActiva()
		Sleep 2000
		loop, 20
		{
			Tooltip, % "la opcion activa es " BarraOpciones.opcionActiva()
			sleep 1000
		}
						
		Tooltip, Probando posicion de Inventory
		Sleep 2000
							
		MouseMove, BarraOpciones.Inventory.x, BarraOpciones.Inventory.y, 20
		Sleep 2000
							
		loop, 28
		{
			MouseMove, BarraOpciones.Inventory.celda[A_index].x, BarraOpciones.Inventory.celda[A_index].y
			Sleep 3000
								
			MouseMove, _Monitor.indicadores[BarraOpciones.Inventory.celda[A_index].indicadorID].x, _Monitor.indicadores[BarraOpciones.Inventory.celda[A_index].indicadorID].y
								
		}



	}
	else
	{
		MsgBox, La interface Global no esta definida.
	
	}
}