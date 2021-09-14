        .ORIG    x3000
START   ;R0:almacenamos el caracter ingresado
	;R1 almacenamos el digito ingresado(normalizado)
	;R2: cantidad de digitos(6 o 2)
	;R3: resgistro temporal
	;R4: almacenamos el numero completo
	;R5,R6 Registros temporales
	AND R2,R2,#0
	;ADD R2,R2,#2 
	AND R4,R4,#0 
	AND R5,R5,#0
	;ADD R5,R5,#1
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
		LD R3,CONTADOR
		LD R1,SIG
		BRNZ NUM_POSITIVOS
		;Sacamos complemento a2
		LD R0,AUX2
		NOT R0,R0
		ADD R0,R0,#1
NUM_POSITIVOS	STR R0,R3,#0 ;Almacenamos los digitos acumulados
		STR R4,R3,#1
		ADD R3,R3,#2
		ST R3,CONTADOR
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
		
		JSR TERMINAR;----------------------CONECTAR CODIGO COMPAÑERO		
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
RET_DIVICION 	LD R3,CONTADOR
		STR R0,R3,#0; Almacenamos los 4 ultimos digitos del numero 
		STR R1,R3,#1; Almacenamos los 1 primeros digitos del numero	
		ADD R3,R3,#2
		ST R3,CONTADOR
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
BANDERA 	.FILL X0000
NUM_DATOS	.FILL X0000
CONTADOR	.FILL X3200; Direccion para almacenar los datos
AUX1		.FILL #0 ;Se utliza para almacenar el dato (R4)de manera temporal
AUX2		.FILL #0 ;Se utiliza para mantener el numero de 4 digitos
SIG   		.FILL x0000
ERROR   	JSR ENTER
		LEA R0,MSG_E
		PUTS
		JSR ENTER
		BRNZP START
		
;-----------------------MENSAJES O MENU--------------------------------------
MSG_N   	 .STRINGZ "Ingrese el numero ENTERO entre 10 y 20: "   
       
MSG_DA    	.STRINGZ "Ingrese los Datos: "   

MSG_END		.STRINGZ "LOS DATOS FUERON ALMACENADOS "
   
MSG_E    	.STRINGZ "Ingresó UN NUMERO INCORRECTO "   
        .END