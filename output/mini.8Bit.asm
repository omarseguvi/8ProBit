.init: 
	MOV D, 232
	JMP main


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
                            

hello_data: 
	x: DB 0; 
	y: DB 0; 
hello: 
	PUSH x; 
	PUSH 1; 
	POP B; 
	POP A; 
	ADD A , B; 
	PUSH A; 
	POP A; 
	MOV a , A; 
	PUSH x; 
	PUSH y; 
	POP B; 
	POP A; 
	ADD A , B; 
	PUSH A;