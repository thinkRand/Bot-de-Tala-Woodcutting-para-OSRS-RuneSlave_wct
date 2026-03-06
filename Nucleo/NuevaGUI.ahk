;la gui debe localisarse por fuera de la ventana que tiene a runscape (no debe quedar por ensima), 
;debe aparecer a un lado de la ventana de runescape sea cual sea(si no hay espacio se deb ajustar el tamnio de la ventana de RL), en caso de que la ventana no deje espacio entonces se reduce el espacio  para que 

;siempre que el foco este sobre la ventana de esta gui, se debe volver a la ventana en uso, y ejecutar el comando alli.

;Crear las partes de la GUI
;El tamanio, la posicion son dependientes de la ventana de Rune lite. O mejor dicho la ventana se debe crear y luego se debe ajustar el tamanio de la ventana de RL
ini_gui()
{
	Global 
	Gui, RuneSlave_wct:New, HwndRSlaveGuiHwnd Resize MinSize, RuneSlave_wct
	Gui, -AlwaysOnTop
	Gui, RuneSlave_wct:Add, Text, , Eventos:
	Gui, RuneSlave_wct:Add, Edit, xm w200 r5 ReadOnly +Wrap vControl_msg, Sin eventos...
	;la coordenadas deben cambiar para aparecer visibles a un lado del cliente runescape.Xcenter Y0 W200 H120 NA 
	Gui, RuneSlave_wct:Show, ,
}


;lo que quiero es mantener la gui en el top de cualquier gui inclusive la de runescape, pero sin ponerla activa, es decir que no se tenga la fijacion en esta gui, solo que se vean los mensajes
guiMsg(msg)
{
	Global
	static i = 1
	static text := ""
	text := text i "  " msg
	;se daja la hwnd vacio para poner nuevo contenido en el control
	GuiControl, %RSlaveGuiHwnd%:, Control_msg, %text%
	i++
	text .= "`n"
	
}

;devuelve la respuesta del usuario
;debe mostrar una entrada di informacion que debe posarce por encima de todo pidendo informacion de si el arbol esta o no activo




;funcion de window spy, pr guiarme ;)
UpdateText(ControlID, NewText)
{
	; Unlike using a pure GuiControl, this function causes the text of the
	; controls to be updated only when the text has changed, preventing periodic
	; flickering (especially on older systems).
	static OldText := {}
	global hGui
	if (OldText[ControlID] != NewText)
	{
		GuiControl, %hGui%:, % ControlID, % NewText
		OldText[ControlID] := NewText
	}
}

ini_gui()

;a::guiMsg("hola mundo...")