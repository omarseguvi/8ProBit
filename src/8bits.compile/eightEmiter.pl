/*
EIF400 loriacarlos@gmail.com
*/

:-['eightParser']
.



testEmiter :-
    testParser(P),
	genCode(P)
.


genCodeToFile(File, P) :-
   open(File, write, Out),
   genCode(Out, P),
   close(Out)
.
genCode(P) :- genCode(user_output, P)
.
genCode(Out, eightProg(L)) :- !,
							format(Out,'.init: \n',[]),
                            format(Out,'\tMOV D, 232;\n',[]),
                            format(Out,'\tJMP main;\n',[]),
							format(Out,'\t.UNDEF: DB 255;\n',[]),
							genCodeList(Out, L)
							%findall(E,prt(E),L), write(L)
                            %genCodePrintss(Out)
							%genCodePrints(Out)
.

genCodePrints(Out) :- prt(R), atom_string(R) = atom_string(prt(print_string)) ,format(Out,'\n
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
    \n', [])
.

 genCodePrints(Out) :- prt(Q), atom_string(Q) = atom_string(prt(print_number)), format(Out,'\n
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
    \n',[])
  .
/*
  genCodePrintss(Out) :- !, print(print_boolean), format(Out,'\n
  print_boolean:
  POP C;
  POP A;
  PUSH C;
  CMP A, 0;
  JNE .print_false;
  PUSH .true
  JMP .pb_exit:
  .print_false:
  PUSH .false
  JMP .pb_exit:
  .pb_exit:
  CALL print_string;
  POP C;
  POP C;
  PUSH .UNDEF
  PUSH C
  RET
  \n'
	,[])
  .*/
/*
%cambio
genCode(Out, fun(N,F,B)) :- !,    (main,a,main_a: DB 0;)            (hello,b,hello_b: DB 0;)
    insert_funActual(N)),
    %format(Out, 'function ', []),
    genCode(Out, N),
	format(Out, ':', []),
	genCode(Out, F),
	genCode(Out, B)
.
genCode(Out, formals(L)) :- !,
     format(Out, '(', []),
     insert_value(L),
     genCodeList(Out, L, ', '),
	 format(Out, ')', [])
.
%cambio
genCode(Out, body(L)) :- !,
   format(Out, '\n', []),
   genCodeList(Out, L, ' ')
   %format(Out, '}', [])
.
genCode(Out, atom(N)) :- !, format(Out, '~a ', [N])
.
genCode(Out, id(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, num(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.*/

%asm instruction ---------------------------------------
genCode(Out,asmins(N)) :- !,format(Out, '\n\t~a ;', [N])
.

genCode(Out,asmins(N, P1)) :- !,format(Out, '\n\t~a ~a;', [N, P1])
.

genCode(Out,asmins(N, P1, P3)) :- !,format(Out, '\n\t~a ~a , ~a;', [N, P1, P3])
.

genCode(Out, tag(N)) :- !,format(Out, '\n~a:', [N])
.

genCode(Out, vardecla(N)) :- !,format(Out, '\n\t~a: DB 0;', [N])
.

genCode(Out, stringdecla(N, V)) :- !,format(Out, '\n\t~a: DB ~a; \n\t DB 0;', [N, V])
.
genCode(Out, print_string) :- !, genCodePrintS(Out)
.
genCode(Out, print_number) :- !, genCodePrintN(Out)
.
genCode(Out, print_boolean) :- !, genCodePrintB(Out)
.



%-------------------------------------------------------
/*
genCode(Out, operation(O, L, R)) :- !,
    genCodeList(Out, [L, O, R])

.
genCode(Out, empty) :- !,  format(Out, '; ', [])
.
genCode(Out, assign(I, E)) :-  !,
   genCode(Out, operation(oper('='), I, E))

.
%cambios
genCode(Out, amsList(L)) :-  !,
	 genCodeList(Out, L)

.
genCode(Out, return(E)) :- !, format(Out, 'return ', []),
                              genCode(Out, E)
.
*/
genCode(_, E ) :- throw(E).

genCodeList(Out, L) :- genCodeList(Out, L, ' ')
.
genCodeList(_, [], _).
genCodeList(Out, [C], _) :- genCode(Out, C).
genCodeList(Out, [X, Y | L], Sep) :- genCode(Out, X),
                                format(Out, '~a', [Sep]),
                                genCodeList(Out, [Y | L], Sep)
.


genCodePrintS(Out) :- !,format(Out,'\n
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
                            \n', [])
.

genCodePrintN(Out) :- !, format(Out,'\n
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
  \n',[]).

genCodePrintB(Out) :- !, format(Out,'\n
print_boolean:
POP C;
POP A;
PUSH C;
CMP A, 0;
JNE .print_false;
PUSH .true
JMP .pb_exit:
.print_false:
PUSH .false
JMP .pb_exit:
.pb_exit:
CALL print_string;
POP C;
POP C;
PUSH .UNDEF
PUSH C
RET
\n',[]).
