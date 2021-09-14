.ORIG X3000
START		LEA R0,MYMSG
		JSR PUTSMSG
AGAIN 		JSR GETCHAR
		JSR PUTCHAR 
END		BR AGAIN
;--------------------------------
GETCHAR 	LDI R0,KBRS		
		BRZP GETCHAR
		LDI R0,KBDR;	R0=dato no direccion
		RET
;---------------------------------
PUTCHAR		ST R0,PCR0 	;se almacena el caracter
PUTCHAR2	LDI R0,DSR	;R0=dato no direccion
		BRZP PUTCHAR2
		LD R0,PCR0
		STI R0,DDR
		RET		;JMP R7
;---------------------------------
PCR0		.FILL 0
;---------------------------------
PUTSMSG     ST  R0,PMR0 	
	    LDR R0,R0,#0 	
	    BRz PUTSMSGE 	
	    ST R7,PMR7 		
	    JSR PUTCHAR		
	    LD R7,PMR7		
	    LD R0,PMR0		
	    ADD R0,R0,#1	
	    BRnzp PUTSMSG 	
PUTSMSGE    RET 		
;---------------------------------
PMR0		.FILL 0
PMR7		.FILL 0
KBRS		.FILL XFE00
KBDR		.FILL XFE02
DSR		.FILL XFE04
DDR		.FILL XFE06
MYMSG		.STRINGZ "\n HOLA BIENBENIDO \npor favor digita cualquier caracter:"
.END