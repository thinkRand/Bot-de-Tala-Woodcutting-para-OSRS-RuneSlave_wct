;Listas, pilas , colas y algo mas.


;puede ser un objeto lista con una funcion siguiente()


siguienteNumeroEnLista(minimo, actual, maximo)
{		
	;minimo, actual y maximo debe ser enteros positivos
	; si minimo es 0, se ara return 0 es varias condiciones, sera algun error?
	;MsgBox, minimo %minimo% actual %actual% maximo %maximo%
	
	if (maximo > minimo)
	{
		if (actual < maximo)
		{
			return (actual+1)
		}
		else if (actual = maximo)
		{	
			return minimo
		}
	}
	else if (minimo = maximo or actual = maximo) ; en el caso en que minimo es igual maximo siempre se cumple que actual es iagual a ambos
	{	
		return minimo
	}
	else
	{
		tooltip, fallo funcion siguienteNumeroEnLista()
		return 0  
	}
		
}