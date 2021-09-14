	.ORIG	x3000
LOOP1	 
	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0	
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0
	JSR	GETDATOS
	LEA	R0, MENU1	;Despliega el menu
	TRAP	x22
	LEA	R0, MENU2
	TRAP 	x22
	LEA	R0, MENU3
	TRAP 	x22
	LEA	R0, MENU4
	TRAP 	x22
	ADD	R4, R4, #-2	;Salto de funcionalidad
	BRNZ 	ORDENAR		;Salto a ordenar si la opcion es ordenar o conocer el mayor
	BRP	MULTIPL		;Salto a encontrar multiplos
	;AND	R1, R1, #0	;R1 = 10 (output base 10 DECIMAL)
	;ADD	R1, R1, #10
	;JSR	PRINT		;Print the integer in decimal
	;JSR	NEWLN		;Move cursor to the start of a new line

MENU1	.STRINGZ "Ingrese la funcionalidad que desea: \n 1)Ordenar decendentemente"
MENU2	.STRINGZ "\n 2)Imprimir el mayor numero"
MENU3 	.STRINGZ "\n 3)Imprimir los multiplos de 8"
MENU4 	.STRINGZ "\n 4)Ingresar nuevamente los datos \n"

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




ORDENAR		LD R4, N 
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
	LD R0, INITL2
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
FINISH2 LD R0 INITL2
	JMP R0;		
INITL2 .FILL x3000
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

N		.FILL X0000
NUMVECT		.BLKW 40;   2*20

PRINTLIST 	LD R4, N;
		LEA R2 NUMVECT
PRINTNUMBER		
		ADD R4, R4, #0
BRZ FINISH1				
		LDR R0, R2, #0
		BRn PRINTMENOS
		BRzp PRINTNORM1
		ST R0, CARGAR0
PRINTMENOS	LD R0, SIGNOM1
		OUT
		LD R0, CARGAR0
		NOT R0, R0
		AND R0, R0, #1

PRINTNORM1	AND R1, R1, #0
		ADD R1, R1, #10
		JSR PRINT
		JSR NEWLN
		ADD R4, R4, #-1
		ADD R2, R2, #1
		BRNZP PRINTNUMBER
FINISH1 LD R0 INITL
	JMP R0;
SIGNOM1 .FILL x002C
CARGAR0 .BLKW 1
INITL	.FILL x3000
L .BLKW 1

L1 .FILL x0003


GETL 
	;TAMBIEN IRA LA FUNCION QUE CAPTURE L, ES DE MI COMPAÑERO
	LD R4, L1
	ST R4, L
	RET

   	
GETDATOS  	;R0:almacenamos el caracter ingresado
		;R1 almacenamos el digito ingresado(normalizado)
		;R2: cantidad de digitos(6 o 2)
		;R3: resgistro temporal
		;R4: almacenamos el numero completo
		;R5,R6 Registros temporales
;
		ADD R6,R7,#0;---------------------PARA QUE RETORNE AL TERMINAR LA CAPUTA
		ST R6,RETORNO
GETDATOS_2	AND R2,R2,#0
		AND R4,R4,#0 
		AND R5,R5,#0
		ST R5,BANDERA
		LEA      R0,MSG_N
       		PUTS                    ;; Prints the null-terminated string
		

;----------------------capturar el dato-----------------------------
RECIBIR 	GETC              
		JSR NORMALIZAR	
;----------------------numeros-------------------------------------
		ADD R1,R1,#-9
		BRZ DIRECCION
		ADD R1,R1,#9
		ADD R1,R1,#-8
		BRZ DIRECCION
		ADD R1,R1,#8
		ADD R1,R1,#-7
		BRZ DIRECCION
		ADD R1,R1,#7
		ADD R1,R1,#-6
		BRZ DIRECCION
		ADD R1,R1,#6
		ADD R1,R1,#-5
		BRZ DIRECCION
		ADD R1,R1,#5
		ADD R1,R1,#-4
		BRZ DIRECCION
		ADD R1,R1,#4
		ADD R1,R1,#-3
		BRZ DIRECCION
		ADD R1,R1,#3
		ADD R1,R1,#-2
		BRZ DIRECCION
		ADD R1,R1,#2
		ADD R1,R1,#-1
		BRZ DIRECCION
		ADD R1,R1,#1
		ADD R1,R1,#-0
		BRZ DIRECCION
		ADD R1,R1,#3 ;Verificamos si es el signo(-)
		BRZ DIRECCION
		ADD R1,R0,#-10
		BRZ DIRECCION ;Verificamos si es un enter 
		BRNP RECIBIR;
;-----------------------------------DIRECCIONAMIENTO----------------------
DIRECCION	LD R3,BANDERA
		ADD R3,R3,#0
		BRP DATOS ; Verificamos si esta capturando el numero N o los datos 
		OUT 
		ADD R1,R0,#-10	
		BRZ SALTO_DATOS;Verificamos si ingreso un enter
		ADD R2,R2,#1
		ADD R3,R2,#0
		ADD R3,R3,#-2
		BRZ ALMACENAR_NUM;Verificamos si ingreso dos digitos-------------???????????????
		JSR MULT_10; R4<-Mantenemos el digito ingresado
		BRNZP RECIBIR

;------------------PASSAR A OTRO ESTADO---TENER EN CUENTA,REINICIAR LOS REGISTROS R2,R4--------
ALMACENAR_NUM	JSR MULT_10		
SALTO_DATOS	ADD R3,R4,-10
		BRN ERROR ;Si el nimero es menor que 10
		ADD R3,R4,-15
		ADD R3,R3,-5
		BRP ERROR;Si el numero es mayor que 20
		JSR ESPACIO
		JSR ENTER
		LEA R0, MSG_DA;------------------------------>>Mostramos mensaje Mensaje
		PUTS
		ST R4,NUM_DATOS	
		AND R2,R2,#0
		AND R4,R4,#0	
		AND R0,R0,#0 ;-|----Reiniciamos los registros
		ADD R0,R0,#1
		ST R0,BANDERA
		BRNZP RECIBIR			
			
;-------------------------MOSTRAR DATOS-------------------------

SHOW		OUT 
		JSR MULT_10; Acumulamos el digito en R4	
		ST R4,AUX1; guardadmos el dato acomulado de manera temporal
		ADD R3,R2,#-4;		
		BRZ MANTENER;-----verificamos si es el digito 4 Y lo guardamos temporalmente
		ADD R3,R2,#-5
		BRZ ALMACENAR
		ADD R2,R2,#1
		BRNZP RECIBIR
MANTENER        ST R4,AUX2
		ADD R2,R2,#1
		AND R4,R4,#0;
		BRNZP RECIBIR
;------------------------------------multiplicacion----------------------------------						
MULT_10   	ADD R3,R4,R4  ; R3 ==  2*R4
        	ADD R3,R3,R3  ; R3 ==  4*R4
        	ADD R3,R3,R4  ; R3 ==  5*R4
        	ADD R3,R3,R3  ; R3 == 10*R4
		ADD R6,R7,#0
		JSR NORMALIZAR
		ADD R4,R3,R1  ; sumamos el digito ingresado
		ADD R7,R6,#0
		RET
;----------------------------ALMACENAR---(SE ALMACENA A PARTIR DE X3100------------------------------------

ALMACENAR	LD R0,AUX2
		LEA R3,NUMVECT;    LD R3,CONTADOR
		LD R1,SIG
		BRNZ NUM_POSITIVOS
		;Sacamos complemento a2
		LD R0,AUX2
		NOT R0,R0
		ADD R0,R0,#1
NUM_POSITIVOS	STR R0,R3,#0 ;Almacenamos los digitos acumulados
		STR R4,R3,#1
		ADD R3,R3,#2
		ST R3,NUMVECT ;  CONTADOR
		AND R4,R4,#0   
		ADD R2,R2,#1
		ADD R3,R2,#-6
		BRZ NEX_DATA		
		BRNZP RECIBIR
;--------------------------------NORMALIZAMOS EL DATO-----------------------
NORMALIZAR      AND R1,R1,#0 ;Normalizamos el numero restando 48=>0
		ADD R1,R1,R0
		ADD R1,R1,#-15
		ADD R1,R1,#-15
		ADD R1,R1,#-15
		ADD R1,R1,#-3 ;
		RET
;--------------------------SIGNO------------------------------
SIGNO		ADD R2,R2,#0
		BRP RECIBIR; Verificamos si estan el la pocision(0)
		OUT
		AND R5,R5,#0
		ADD R5,R5,#1
		ST R5,SIG
		ADD R2,R2,#1; pasamos a capturar el primer digito
		BRNZP RECIBIR

;---------------------CONTRL DE CANTIDAD DE DATOS----------------
DATOS		ADD R3,R0,#-10
		BRZ IN_ENTER; Verificamos si es un enter
		JSR NORMALIZAR 
		ADD R3,R1,#3
		BRZ SIGNO; Verificamos is es un signo
		ADD R2,R2,#0
		BRP SHOW
		JSR MULT_10;--A R4 Le acumulamos el digito
		ST R4,AUX1
		OUT
		ADD R2,R2,#2; Salto dos digitos ya en la posicion (0) no se ingreso el (-)
		BRNZP RECIBIR
		
;---------------NUEVO DATO-----------REINICIAMOS LOS REGISTROS PARA UN NUEVO DATO--------
NEX_DATA	AND R2,R2,#0 ;cantidad de digitos de los datos del nuevo dato
		AND R4,R4,#0 
		ST R4,SIG
		JSR ESPACIO		
		LD R3,NUM_DATOS
		ADD R3,R3,#-1
		ST R3,NUM_DATOS		
		BRP RECIBIR ;SE VERIFICA SI TERMINA DE INGREAR LOS N DATOS
		JSR ENTER
		LEA R0,MSG_END
		PUTS
		JSR ENTER
		LD R7,RETORNO
		RET
		;JSR TERMINAR;----------------------CONECTAR CODIGO COMPAÑERO		
;-----------------------------------PARTICIONAMOS EL NUMERO SI INGRESA UN ENTER-------------------------
IN_ENTER	ADD R3,R2,#0;
		BRZ RECIBIR  ;Verificamos si NO ingreso datos
		ADD R3,R2,#-1
		BRZ RECIBIR  ;Verificamos si se ingreso un signo segido de un enter 
		LD R1,AUX1
		ADD R3,R1,-9 ;Verificamos si el numero es de mas de una sifra 
		BRP DIVIDIR;;verificamos 
		LD R0,SIG
		BRNZ RET_DIVICION;Verificamos is es positivo o no
		NOT R1,R1
		ADD R1,R1,#1
		AND R0,R0,#0		
RET_DIVICION 	LEA R3,NUMVECT  ;LD R3,CONTADOR
		STR R0,R3,#0; Almacenamos los 4 ultimos digitos del numero 
		STR R1,R3,#1; Almacenamos los 1 primeros digitos del numero	
		ADD R3,R3,#2
		ST R3,NUMVECT ;  CONTADOR
		BRNZP NEX_DATA
DIVIDIR		AND R0,R0,#0
LOOP		ADD R0,R0,#1;   R0--> CONTADOR 
		ADD R1,R1,-10
		BRZP LOOP
		ADD R1,R1,#10;
		ADD R0,R0,#-1;Tercer digito
		LD R3,SIG
		BRNZ RET_DIVICION;Verificamos is es positivo o no
		NOT R0,R0
		ADD R0,R0,#1				
		BRNZP RET_DIVICION

ESPACIO		AND R0,R0,#0
		ADD R0,R0,#15
		ADD R0,R0,#15
		ADD R0,R0,#2
		ADD R6,R7,#0
		OUT 
		ADD R7,R6,#0
		RET
ENTER		AND R0,R0,#0
		ADD R0,R0,#13
		ADD R6,R7,#0
		OUT 
		ADD R7,R6,#0
		RET		
TERMINAR	HALT
RETORNO		.FILL #0
BANDERA 	.FILL X0000
NUM_DATOS	.FILL X0000
;CONTADOR	.FILL X3200; Direccion para almacenar los datos
AUX1		.FILL #0 ;Se utliza para almacenar el dato (R4)de manera temporal
AUX2		.FILL #0 ;Se utiliza para mantener el numero de 4 digitos
SIG   		.FILL x0000
ERROR   	JSR ENTER
		LEA R0,MSG_E
		PUTS
		JSR ENTER
		BRNZP GETDATOS_2
		
;-----------------------MENSAJES O MENU--------------------------------------
MSG_N   	 .STRINGZ "Ingrese el numero ENTERO entre 10 y 20: "   
       
MSG_DA    	.STRINGZ "Ingrese los Datos: "   

MSG_END		.STRINGZ "Sus datos fueron almacenados "
   
MSG_E    	.STRINGZ "Ingresó UN NUMERO INCORRECTO "   
        .END