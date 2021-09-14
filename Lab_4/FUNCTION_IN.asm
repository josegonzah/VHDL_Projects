		.ORIG X3000
		JSR IN_CHAR 
		HALT 
IN_CHAR	 	LDI R0,KBRS		
		BRZP IN_CHAR
		LDI R0,KBDR;	R0=dato no direccion
		ST R0,PCR0 	;se almacena el caracter
PUT_CHAR	LDI R0,DSR	;R0=dato no direccion
		BRZP PUT_CHAR
		LD R0,PCR0
		STI R0,DDR
		JMP R7
;----------------------------
PCR0		.FILL 0
KBRS		.FILL XFE00
KBDR		.FILL XFE02
DSR		.FILL XFE04
DDR		.FILL XFE06
.END