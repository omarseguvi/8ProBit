.init: 
	MOV D, 232;
	JMP main;
	.UNDEF: DB 255;
  .true: DB "true"
	DB 0;
	.false: DB "false"
	DB 0;

fibo_data: 
	fibo_ra: DB 0; 
	fibo_n: DB 0; 
	fibo_a: DB 0; 
	fibo_b: DB 0; 
	fibo_t: DB 0; 
main_data: 
	main_ra: DB 0; 
	main_string0: DB "fibo(3)="; 
	 DB 0; 
fibo: 
	POP C; 
	POP A; 
	PUSH [fibo_n]; 
	PUSH [fibo_ra]; 
	MOV [fibo_ra] , C; 
	MOV [fibo_n] , A; 
	PUSH 1; 
	POP A; 
	MOV [fibo_a] , A; 
	PUSH 1; 
	POP A; 
	MOV [fibo_b] , A; 
	PUSH 0; 
	POP A; 
	MOV [fibo_t] , A; 
while: 
	PUSH [fibo_n]; 
	PUSH 0; 
	POP B; 
	POP A; 
	CMP A , B; 
	JNE out; 
	PUSH [fibo_a]; 
	POP A; 
	MOV [fibo_t] , A; 
	PUSH [fibo_b]; 
	POP A; 
	MOV [fibo_a] , A; 
	PUSH [fibo_b]; 
	PUSH [fibo_t]; 
	POP B; 
	POP A; 
	ADD A , B; 
	PUSH A; 
	POP A; 
	MOV [fibo_b] , A; 
	PUSH [fibo_n]; 
	PUSH 1; 
	POP B; 
	POP A; 
	SUB A , B; 
	PUSH A; 
	POP A; 
	MOV [fibo_n] , A; 
	JMP while; 
out: 
	PUSH [fibo_a]; 
	JMP epilogo; 
epilogo: 
	POP A; 
	MOV C , [fibo_ra]; 
	POP B; 
	MOV [fibo_ra] , B; 
	POP B; 
	MOV [fibo_n] , B; 
	PUSH A; 
	PUSH C; 
	RET ; 
main: 
	PUSH main_string0; 
	CALL print_string; 
	POP A; 
	PUSH 3; 
	CALL fibo; 
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
                            
