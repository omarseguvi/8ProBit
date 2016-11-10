.init: 
	MOV D, 232;
	JMP main;
	.UNDEF: DB 255;

  .true: DB "true"
	DB 0;
	.false: DB "false"
	DB 0;

fact_data: 
	fact_ra: DB 0; 
	fact_n: DB 0; 
	fact_f: DB 0; 
main_data: 
	main_ra: DB 0; 
	main_string0: DB "fact(5)="; 
	 DB 0; 
fact: 
	POP C; 
	POP A; 
	PUSH [fact_n]; 
	PUSH [fact_ra]; 
	MOV [fact_ra] , C; 
	MOV [fact_n] , A; 
	PUSH 1; 
	POP A; 
	MOV [fact_f] , A; 
while: 
	PUSH [fact_n]; 
	PUSH 0; 
	POP B; 
	POP A; 
	CMP A , B; 
	JBE out; 
	PUSH [fact_f]; 
	PUSH [fact_n]; 
	POP B; 
	POP A; 
	MUL B; 
	PUSH A; 
	POP A; 
	MOV [fact_f] , A; 
	PUSH [fact_n]; 
	PUSH 1; 
	POP B; 
	POP A; 
	SUB A , B; 
	PUSH A; 
	POP A; 
	MOV [fact_n] , A; 
	JMP while; 
out: 
	PUSH [fact_f]; 
	JMP epilogo; 
epilogo: 
	POP A; 
	MOV C , [fact_ra]; 
	POP B; 
	MOV [fact_ra] , B; 
	POP B; 
	MOV [fact_n] , B; 
	PUSH A; 
	PUSH C; 
	RET ; 
main: 
	PUSH main_string0; 
	CALL print_string; 
	POP A; 
	PUSH 5; 
	CALL fact; 
	CALL print_number; 
	POP A; 
	HLT ; 

	print_string:
		POP C
		POP B
		PUSH C
	.print_string_loop_01:
		MOV C, [B]
		CMP C, 0
		JE .print_string_exit
		MOV [D], C
		INC D
		INC B
		JMP .print_string_loop_01
	.print_string_exit:
		POP C
		PUSH .UNDEF
		PUSH C
		RET
                            
 

print_number:
	POP C
	POP A
	PUSH C
.number_to_Stack:
	MOV B,A;
	DIV 10;
	MUL 10;
	SUB B, A;
	PUSH B;
	CMP A, 0;
	JE .number_to_display;
	DIV 10;
	JMP .number_to_Stack;
.number_to_display:
	POP A;
	CMP A,C;
	JE .exit;
	ADD A, 0x30;
	MOV [D], A;
	INC D;
	JMP .number_to_display;
	.exit:
	PUSH .UNDEF
	PUSH C
	RET
  
