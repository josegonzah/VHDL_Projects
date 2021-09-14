	.ORIG	x3000
LOOP1	LEA	R0, MENU1	;Despliega el menu
	TRAP	x22
	LEA	R0, MENU2
	TRAP 	x22
	LEA	R0, MENU3
	TRAP 	x22
	JSR 	GETN		;Cantidad de veces que se capturará
	JSR 	GETL		;FuncionalidaD
	JSR	GETNUMBER 
	ADD	R4, R4, #-2	;Salto de funcionalidad
	BRNZ 	ORDENAR		;Salto a ordenar si la opcion es ordenar o conocer el mayor
	BRP	MULTIPL		;Salto a encontrar multiplos
	;AND	R1, R1, #0	;R1 = 10 (output base 10 DECIMAL)
	;ADD	R1, R1, #10
	;JSR	PRINT		;Print the integer in decimal
	;JSR	NEWLN		;Move cursor to the start of a new line

MENU1	.STRINGZ "Ingrese la funcionalidad que desea: \n 1)Ordenar ascendentemente"
MENU2	.STRINGZ "\n 2)Imprimir el mayor numero"
MENU3 	.STRINGZ "\n 3)Imprimir los multiplos de 8 \n"

;Subroutine NEWLN*************************************************************
;Advances the console cursor to the start of a new line
NEWLN	
	ST	R7, NEW7	;Save working registers
	ST	R0, NEW0

	LD	R0, NL		;Output a newline character
	TRAP	x21

	LD	R0, NEW0	;Restore working registers
	LD	R7, NEW7
	RET			;Return
;Data
NL	.FILL	x000A	;Newline character x0A
NEW0	.BLKW	1	;Save area - R0
NEW7	.BLKW	1	;Save area - R7




ORDENAR		LD R4, N ; N tiene la dirección de memoria en donde está n
		OUTERLOOP   ADD     R4, R4, #-1 ; loop n - 1 times
            		BRNZ    SORTED      ; 
            		ADD     R5, R4, #0  ; Initialize inner loop counter to outer
           		 LEA      R3,NUMVECT    ; NUMEROS TIENE LA PRIMERA DIRECCION EN MEMORIA DE LOS NUMEROS
		INNERLOOP   LDR     R0, R3, #0  ; ALMACENA EN R0 EL ELEMENTO
            		LDR     R1, R3, #1  ; ALMACENA EN R1 EL ELEMENTO CONSECUTIVO
            		NOT     R2, R1       
            		ADD     R2, R2, #1  ; COMPLEMENTO A 2
            		ADD     R2, R0, R2  ; SI EL RESULTADO NO ES NEGATIVO ES PORQUE ESTÁ EN DESORDEN Y SE DEBE INTERCAMBIAR DE POSICIÓN
            		BRNZ    SWAPPED     
            		STR     R1, R3, #0  ;
            		STR     R0, R3, #1  ; INTERCAMBIO DE POSICIONES
		SWAPPED     ADD     R3, R3, #1
            		ADD     R5, R5, #-1 
            		BRP     INNERLOOP   
            		BRNZP   OUTERLOOP
		SORTED  LD R3 L
			ADD R3, R3, #-2
			BRz MAYOR ;YA QUE TENGO LA LISTA ORDENADA ENTONCES COJO EL ULTIMO NUMERO EN LA FUNCION MAYOR
			JSR PRINTLIST
MAYOR	 LEA R2, NUMVECT
	LDR R0, R2, #0
	AND R1, R1, 0
	ADD R1, R1, #10
	JSR PRINT	
	JSR NEWLN
	LEA R0, FINISH1
	JMP R0
MULTIPL 	LD R4, N;
		LEA R2 NUMVECT
PRINTMUL	
		AND R5, R5, #0
		ADD R5, R5, #7
		ADD R4, R4, #0
BRZ FINISH2				
		LDR R0, R2, #0
		AND R1, R1, #0
		ADD R1, R1, #10
		AND R6, R5, R0
		BRZ PRINTM1
		BRNP SALTO1 
PRINTM1		JSR PRINT
		JSR NEWLN
SALTO1		ADD R4, R4, #-1
		ADD R2, R2, #1
		BRNZP PRINTMUL
FINISH2 HALT;		
;Subroutine PRINT*************************************************************
;Displays an unsigned integer in any base up to 16, e.g. binary, octal, decimal
;Parameters - R0: the integer - R1: the base
PRINT
	ST	R7, PRT7	;Save the working Registers
	ST	R6, PRT6	;Save the working Registers
	ST	R5, PRT5	;Save the working Registers
	ST	R4, PRT4	;Save the working Registers
	ST	R3, PRT3	;Save the working Registers
	ST	R2, PRT2	;Save the working Registers
	AND R7 R7 0 	; Clears the register 
	AND R6 R6 0 	; Clears the register 
	AND R5 R5 0 	; Clears the register 
	AND R4 R4 0 	; Clears the register 
	AND R3 R3 0 	; Clears the register 
	AND R2 R2 0 	; Clears the register 
	; save current value 
	ST R0 CURRENT 	; Load
	
	;checker for decimal 
	LEA R6 STORE	; Loads R5 with area we will 
	LEA R7 ASCI 	; Loads R7 with x0030
	LDR R4 R7 0 	; Gets the value inside of the memory location
	ADD R2 R2 -15 	; Checker 
	ADD R2 R2 -1 	; makes it -16
	ADD R2 R1 R2 	; checks if the value is zero
	
	AND R2 R2 0 	; Clears R2, 
	BRNZP 3			; skips the first part
	AND R5 R5 0 	; Clears R5
	ADD R5 R5 R2	; Checks to see if R0 is empty 
	BRZ DISPLAY 	; offsets to the end of program
	JSR DIVIDE		; Divides the current value
	ADD R3 R3 R4 	; Adds the value with R7
	STR R3 R6 0		; Stores the content of R6 into that memo location
	ADD R6 R6 1 	; increments the memory location of R6\
	ADD R0 R2 0 	; Stores the new value from R2 into R0 
	BRNZP -9		; loop the program

DISPLAY
	AND R7 R7 0
	AND R5 R5 0
	ADD R6 R6 -1
	LDR R5 R6 0 	; Loads the content of R6 into R5
	ADD R7 R5 0 	; Check to see if the content at R6 is zero
	BRZ 4  			; Offsets to the end of the program 
	ADD R0 R5 0 	; Adds the item into this spot
	TRAP x21 		; Out puts the char to the console 
	ADD R6 R6 -1 	; decrements the location
	BRNZP -7 		; loops the program
END	
	AND R0 R0 0 	; Clears R0

	LD R0 CURRENT 	; loads RO with the mmemory location of current val
	



	LD	R7, PRT7
	LD	R6, PRT6
	LD	R5, PRT5
	LD	R4, PRT4
	LD	R3, PRT3
	LD	R2, PRT2
	RET			;Return
;Data
CURRENT 	.FILL x0000	; place to store the current value
PRT7	.BLKW	1	;Save Area R7
PRT6	.BLKW	1	;Save Area R6
PRT5	.BLKW	1	;Save Area R5
PRT4	.BLKW	1	;Save Area R4
PRT3	.BLKW	1	;Save Area R3
PRT2	.BLKW	1	;Save Area R2
ASCI 	.FILL 	x0030	; Saves the asci addition
DIGITS	.STRINGZ "0123456789ABCDEF"	;Digits
BUFFER	.FILL	x0000	;0-marker for the end of the buffer
STORE	.BLKW	18	;Output Buffer

;Subroutine DIVIDE************************************************************
;Perform integer division to obtain Quotient and Remainder
;Parameters (IN)  : R0 - Numerator,  R1 - Divisor
;Parameters (OUT) : R2 - Quotient,   R3 - Remainder
DIVIDE	
	ST	R7, DIV7	;Save the working Registers
	ST	R6, DIV6	;Save the working Registers
	ST	R5, DIV5	;Save the working Registers
	ST	R4, DIV4	;Save the working Registers	

	AND R7 R7 0 	;Clears R7
	AND R6 R6 0 	;Clears R6
	AND R5 R5 0 	;Clears R5 
	AND R4 R4 0 	;Clears R4
	AND R3 R3 0 	;Clears R3
	AND R2 R2 0 	;Clears R2
	ADD R3 R0 0		; copies the numerator into the remainder
	ADD R5 R1 0 	; Copies the value in  divisor over into R5 
	NOT R5 R5 		; negates R5 
	ADD R5 R5 1 	; Adds 1 to R5 
	ADD R6 R3 R5 	
	; checks to see if the remainder when subtracted by the divisor
	; if that value is still greater than or equal to the divisor  
	BRN 3 			; exits the loop 
	ADD R2 R2 1 	; increment the value in R2 
	ADD R3 R3 R5 	; Minus the diviser from the remainder 
	BRNZP -5 		; ofsets the program to loop over 



	LD R7, DIV7 	; loads back up registers
	LD R6, DIV6 	; loads back up registers
	LD R5, DIV5 	; loads back up registers
	LD R4, DIV4 	; loads back up registers
	
	RET			;Return
;Data
DIV7 	.BLKW 	1 	; Save area R7
DIV6 	.BLKW 	1 	; Save area R6
DIV5 	.BLKW 	1 	; Save area R5
DIV4 	.BLKW 	1 	; Save area R4



PRINTLIST 	LD R4, N;
		LEA R2 NUMVECT
PRINTNUMBER		
		ADD R4, R4, #0
BRZ FINISH1				
		LDR R0, R2, #0
		AND R1, R1, #0
		ADD R1, R1, #10
		JSR PRINT
		JSR NEWLN
		ADD R4, R4, #-1
		ADD R2, R2, #1
		BRNZP PRINTNUMBER
FINISH1 HALT;
GETN	
	;Aqui ira la funcion que capture N de mi compañero, hoy solamente escriberemos en memoria el numero, luego reeplazamos
	LD R4, N1
	ST R4, N 	
	RET
GETNUMBER
	;AQUI IRA LA FUNCION QUE CAPTURE LOS N NUMEROS
	AND R6, R0, 0
	LD R1, N
	LEA R2, NUMVECT
	ADD R1, R1, #0
LOOPGET	BRz FINISH
	
	STR R6, R2, #0
	;NECESITO PREGUNTAR COMO AUMENTAR EL NUMERO EN EL APUNTADOR AL PRIMER NUMERO DEL BLKW	
	ADD R3, R3, 1
	ADD R6, R6, 1
	ADD R2, R2, 1
	ADD R1, R1, -1
	BRnzp LOOPGET
FINISH	RET	
		

N1 .FILL x000A
N .BLKW 1
NUMVECT .BLKW 20 

GETL 
	;TAMBIEN IRA LA FUNCION QUE CAPTURE L, ES DE MI COMPAÑERO
	LD R4, L1
	ST R4, L
	RET
L1 .FILL x0003
L .BLKW 1
  .END