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
	JSR 	GETL
	ADD	R4, R4, #-2	;Salto de funcionalidad
	BRNZ 	ORDENAR		;Salto a ordenar si la opcion es ordenar o conocer el mayor
	BRP	MULTIPL		;Salto a encontrar multiplos

MENU1	.STRINGZ "Ingrese la funcionalidad que desea: \n 1)Ordenar ascendentemente"
MENU2	.STRINGZ "\n 2)Imprimir el menor numero"
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




ORDENAR		LD R4, N1 
		OUTERLOOP   	ADD R4, R4, #-1 ; loop n - 1 times
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
	ADD R0, R0, #0
	BRN NEG2
	BRZP NORMALITO
NEG2	ST R0, GUARDR0
	LD R0, SIGNMEN
	OUT
	LD R0, GUARDR0
	NOT R0, R0
	ADD R0, R0, #1
NORMALITO 	JSR PRINT	
		JSR NEWLN
	LD R0, INITL2
	JMP R0
GUARDR0 .BLKW 1
MULTIPL 	ADD R4, R4, #-1
		BRP AGAIN
		LD R4, N1;
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
PRINTM1		ADD R0, R0, #0
		BRn NEGATIVE
		BRzp NORMIX
NEGATIVE	ST R0 SAVER0
		LD R0 SIGNMEN
		OUT
		LD R0 SAVER0
		NOT R0, R0
		ADD R0, R0, #1

NORMIX		JSR PRINT
		JSR NEWLN
SALTO1		ADD R4, R4, #-1
		ADD R2, R2, #1
		BRNZP PRINTMUL
FINISH2 LD R0 INITL2
	JMP R0;
SIGNMEN .FILL x002D
SAVER0	.BLKW 1
AGAIN 	LD R0 INITL2
	JMP R0		
INITL2 .FILL x3000
;PRINT IMPRIME EL NUMERO EN LA BASE DADA POR R1, EL NUMERO ALMACENADO EN R0
PRINT
	ST	R7, PRT7	
	ST	R6, PRT6	
	ST	R5, PRT5	
	ST	R4, PRT4	
	ST	R3, PRT3	
	ST	R2, PRT2	
	AND R7 R7 0 	
	AND R6 R6 0 	 
	AND R5 R5 0 	 
	AND R4 R4 0 	 
	AND R3 R3 0 	 
	AND R2 R2 0 	 
	; GUARDO EL VALOR DE R0
	ST R0 CURRENT 	
	
	;checker for decimal 
	LEA R6 STORE	
	LEA R7 ASCI 	
	LDR R4 R7 0  
	ADD R2 R2 -15 
	ADD R2 R2 -1 	
	ADD R2 R1 R2 
	
	AND R2 R2 0 	
	BRNZP 3			
	AND R5 R5 0 	
	ADD R5 R5 R2	 
	BRZ DISPLAY 		;MOSTRAR
	JSR DIVIDE		;SE SALTA A LA DIVISION
	ADD R3 R3 R4 	
	STR R3 R6 0		
	ADD R6 R6 1 	
	ADD R0 R2 0 	;
	BRNZP -9		; VUELVE A INICIAR EL PROGRAMA CON EL OTRO DIGITO

DISPLAY
	AND R7 R7 0
	AND R5 R5 0
	ADD R6 R6 -1
	LDR R5 R6 0 	
	ADD R7 R5 0 	
	BRZ 4  			
	ADD R0 R5 0 	
	TRAP x21 	
	ADD R6 R6 -1 	
	BRNZP -7 		
END	
	AND R0 R0 0 	

	LD R0 CURRENT 	
	



	LD	R7, PRT7
	LD	R6, PRT6
	LD	R5, PRT5
	LD	R4, PRT4
	LD	R3, PRT3
	LD	R2, PRT2
	RET		
CURRENT 	.FILL x0000
PRT7	.BLKW	1	
PRT6	.BLKW	1	
PRT5	.BLKW	1	
PRT4	.BLKW	1	
PRT3	.BLKW	1	
PRT2	.BLKW	1	
ASCI 	.FILL 	x0030	
DIGITS	.STRINGZ "0123456789ABCDEF"
BUFFER	.FILL	x0000	
STORE	.BLKW	18

;---------------------DIVIDIR---------------
;R0 - NUMERADOR,  R1 - DIVISOR
;: R2 - COCIENTE,   R3 - RESIDUO
DIVIDE	
	ST	R7, DIV7	
	ST	R6, DIV6	
	ST	R5, DIV5	
	ST	R4, DIV4		

	AND R7 R7 0 	
	AND R6 R6 0 	
	AND R5 R5 0 	
	AND R4 R4 0 	
	AND R3 R3 0 	
	AND R2 R2 0 
	ADD R3 R0 0	
	ADD R5 R1 0 	 
	NOT R5 R5 		
	ADD R5 R5 1 	
	ADD R6 R3 R5 	  ;DIVISONES SUSCESIVAS
	BRN 3 			; SALIR
	ADD R2 R2 1 	; CONTADOR
	ADD R3 R3 R5 	; RESTO LO DEL RESIDUO
	BRNZP -5 		; SALTO AL INICIO DE LA DIVISION



	LD R7, DIV7 	
	LD R6, DIV6 	
	LD R5, DIV5 	
	LD R4, DIV4 	
	
	RET		
DIV7 	.BLKW 	1 	
DIV6 	.BLKW 	1 	
DIV5 	.BLKW 	1 	
DIV4 	.BLKW 	1 	

N		.FILL X0000
N1		.BLKW 1
NUMVECT		.BLKW 20;  

PRINTLIST 	LD R4, N1;
		LEA R2 NUMVECT
PRINTNUMBER		
		ADD R4, R4, #0
		BRZ FINISH1				
		LDR R0, R2, #0
		BRn PRINTMENOS
		BRzp PRINTNORM1
		

PRINTMENOS	ST R0, CARGAR0
		LD R0, SIGNOM1
		OUT
		LD R0, CARGAR0
		NOT R0, R0
		ADD R0, R0, #1

PRINTNORM1	AND R1, R1, #0
		ADD R1, R1, #10
		JSR PRINT
		JSR NEWLN
		ADD R4, R4, #-1
		ADD R2, R2, #1
		BRNZP PRINTNUMBER
FINISH1 	LD R0 INITL
		JMP R0;
SIGNOM1 	.FILL x002D
CARGAR0 	.BLKW 1
INITL		.FILL x3000
L		.BLKW 1

L1 		.FILL x0003


GETL 		ST R7,RETORNO
GETL2		BRNZP RECIBIR

GETL3		AND R4, R4, #0
		ADD R3,R0,#-10
		BRZ GETL2 ;Verificamos si es un enter
		OUT
		JSR MULT_10		
		ADD R3,R4,#-1
		BRN ERROR2 ;Si el nimero es menor que 1
		ADD R3,R4,#-4
		BRP ERROR2;Si el numero es mayor que 4
		JSR ENTER
		ST R4,L
		AND R3,R3,#0
		ST R3,BANDERA;Reiniciamos bandera para poder ingresar datos nuevamente 
		LD R7,RETORNO
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
;BANDERA: =0 Captura N, =1 Captura los datos , =2 Captura el Menu
DIRECCION	LD R3,BANDERA
		ADD R3,R3,#-2
		BRZ GETL3 ;SALTAOS A GETL
		ADD R3,R3,#2
		ADD R3,R3,#-1
		BRZ DATOS ; Verificamos si esta capturando el numero N o los datos 
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
		ST R4,N
		ST R4, N1
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

ALMACENAR	LD R3,AUX2
		AND R5,R5,#0
		LD R6,DIV
		NOT R6,R6
		ADD R6,R6,#1
LOOP_DIV	ADD R5,R5,#1
		ADD R3,R3,R6
		BRZP LOOP_DIV
		LD R6,DIV
		ADD R4,R3,R6
		JSR MULT_10
    		ST R4,AUX1; guardadmos el dato acomulado de manera temporal 
		BRNZP GUARDAR
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
		LD R3,N
		ADD R3,R3,#-1
		ST R3,N		
		BRP RECIBIR ;SE VERIFICA SI TERMINA DE INGREAR LOS N DATOS
		JSR ENTER
		LEA R0,MSG_END
		PUTS
		JSR ENTER
		ST R2,CONTADOR;reiniciamos contador
		ADD R4,R4,#2
		ST R4,BANDERA;Pasamos al Menu
		AND R4,R4,#0
		LD R7,RETORNO		
		RET
		;JSR TERMINAR;----------------------CONECTAR CODIGO COMPAÑERO		
;-----------------------------------PARTICIONAMOS EL NUMERO SI INGRESA UN ENTER-------------------------
IN_ENTER	ADD R3,R2,#0;
		BRZ RECIBIR  ;Verificamos si NO ingreso datos
		ADD R3,R2,#-1
		BRZ RECIBIR  ;Verificamos si se ingreso un signo segido de un enter 
GUARDAR		LD R1,AUX1
		LD R0,SIG
		BRNZ GUARDAR1;Verificamos si es positivo o no
		NOT R1,R1
		ADD R1,R1,#1
GUARDAR1	LEA R0,NUMVECT;-----------------
		LD R3,CONTADOR
		ADD R5,R0,R3
		STR R1,R5,#0; Almacenamos el datos en la direccion NUMVECT+CONTADOR
		ADD R3,R3,#1
		ST R3,CONTADOR;Aumentamos contador+1 
		BRNZP NEX_DATA

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
CONTADOR	.FILL #0; Contardor para sumar al NUMVECT
DIV		.FILL #1000
DIR		.FILL X3200
AUX1		.FILL #0 ;Se utliza para almacenar el dato (R4)de manera temporal
AUX2		.FILL #0 ;Se utiliza para mantener el numero de 4 digitos
SIG   		.FILL x0000
ERROR   	JSR ENTER
		LEA R0,MSG_E
		PUTS
		JSR ENTER
		BRNZP GETDATOS_2
ERROR2 		LEA R0,MSG_E2
		PUTS
		BRNZP GETL2
MSG_E2		.STRINGZ "\nEsa opcion no esta en el Menu \n"
		
;-----------------------MENSAJES O MENU--------------------------------------
MSG_N   	 .STRINGZ "Ingrese el numero ENTERO entre 10 y 20: "   
       
MSG_DA    	.STRINGZ "Ingrese los Datos: "   

MSG_END		.STRINGZ "Sus datos fueron almacenados "
   
MSG_E    	.STRINGZ "Ingresó UN NUMERO INCORRECTO "   
        .END