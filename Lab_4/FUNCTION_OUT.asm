		.ORIG X3000
		LD R0,CHAR 
		JSR OUT_CHAR 
		HALT 		;Hay que crear la funcion para halt 
OUT_CHAR	ST R0,PCR0 	;se almacena el caracter
OUT_CHAR2	LDI R0,DSR	;R0=dato no direccion
		BRZP OUT_CHAR2
		LD R0,PCR0
		STI R0,DDR
		JMP R7		;RET 
CHAR		.FILL #77	;SOLO PARA LA PRUEBA 
PCR0		.FILL 0
DSR		.FILL XFE04
DDR		.FILL XFE06
.END