;Graficos define la logica para mostrar las partes del sistema al usuario. Esto sirve para hacer comprobaciones de que la interface esta vien hubicada.
;Solo muestra lineas que rodean los bordes de cada interface que haya sido creada, incluso las DEFINIDAS POR EL USUARIO

/*

  cada INTERFACE debe ser identificada y deve ser transparente y mostrar solo un borde que no debe superar las dimensiones normales de el espacion de la gui, es decir que la
  linea que remarque una gui debe esta dentro de la misma, no por fuera, y no debe causar ningun inconveniente para hacer clip a travez de ella.


*/



Box_Draw(X, Y, W, H, guiNombre := "") {
  ; No longer adding to the height since using only a single rectangle
  If(W < 0)
    X += W, W *= -1
  If(H < 0)
    Y += H, H *= -1
  Gui, guiNombre:New
  Gui,+E0x20 +ToolWindow -Caption +AlwaysOnTop +LastFound 
  ; Set window to 50% transparency
  WinSet,Transparent,128
  Gui,Color, 0xFF0000
  
  
 Gui, Show, % "x"X " y"Y " w" W " h" H " NA"
}

Box_Draw_R(X, Y, W, H, ventanaPadre := 1) {
  ; No longer adding to the height since using only a single rectangle
  If(W < 0)
    X += W, W *= -1
  If(H < 0)
    Y += H, H *= -1
  Gui, New
  ;se puede usar +Parent y +Owner para hacer que una venta sea hija de otra
  ;MsgBox % ventanaPadre
  WinGetPos, vX, vY, vAncho, vLargo,ahk_id %ventanaPadre%
  Gui,+E0x20 +ToolWindow -Caption +AlwaysOnTop +LastFound
  ; Set window to 50% transparency
  WinSet,Transparent,128
  Gui,Color, 0xFF0000
  X += vX
  Y += vY
  Gui, Show, % "x"X " y"Y " w" W " h" H " NA"
}

Box_Destroy()
{
  Gui, Destroy
}


; Box_Hide - Hides the GUI.
/*Box_Hide() {
  Gui,Hide
}
*/
/*; Initialize the script and overlay
#SingleInstance,force
SetBatchLines, -1
SetWinDelay, -1
Box_Init("FF0000")

; Track the mouse position and draw an overlay over the control being hovered over
/*Loop {
  MouseGetPos, , , Window, Control, 2
  WinGetPos, X1, Y1, , , ahk_id %Window%
  ControlGetPos, X, Y, W, H, , ahk_id %Control%
  if (X)
    Box_Draw(X + X1, Y + Y1, W, H)
  Sleep, 10
}
*/
; Convenient way to quit (useful when not using transparency—oops)
