;YYYYMMDDHH24MISS format.


;comprueba si fecha limite fue alcansada y devuelve true si  la fecha fue alcansada o superada, en caso contrario devuelve false
estaExpirado()
{
	;14 de febrero de 2021
	FECHA_LIMITE := "20210214"
	;la fecha actual es A_Now
	;resto la fecha actual a fecha limite
	EnvSub, FECHA_LIMITE, A_Now, Days
	
	
	if (FECHA_LIMITE <= 0)
	{	
		;MsgBox %FECHA_LIMITE%
		return true
	}
	else
	{
		;MsgBox %FECHA_LIMITE%
		return false
	}

}

;para indicar la situacion, un simple msg
msgExpirado()
{
		MsgBox, El script esta pasado de fecha limite. Contacte al proveedor para adquirir una nueva licencia.
}