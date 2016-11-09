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
                            

main_data: 
main: 
	PUSH 2; 
	PUSH 3; 
	POP B; 
	POP A; 
	ADD A , B; 
	PUSH A; 
	POP A; 
	MOV a , A; 
	PUSH 2; 
	PUSH 3; 
	POP B; 
	POP A; 
	ADD A , B; 
	PUSH A; 
	POP A; 
	MOV b , A;