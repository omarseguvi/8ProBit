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
						format(Out,'
  .true: DB "true"
	DB 0;
	.false: DB "false"
	DB 0;\n',[]),
							genCodeList(Out, L)

.

%asm instruction ---------------------------------------
genCode(Out,asmins(N)) :- !, format(Out, '\n\t~a ;', [N])
.

genCode(Out,asmins(N, P1)) :- !,fixname(N, P1,PP1),format(Out, '\n\t~a ~a;', [N, PP1])
.

genCode(Out,asmins(N, P1, P3)) :- !,fixname(N,P1,PP1),fixname(N, P3,PP3),
									format(Out, '\n\t~a ~a , ~a;', [N, PP1, PP3])
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

genCode(_, E ) :- throw(E).

genCodeList(Out, L) :- genCodeList(Out, L, ' ')
.
genCodeList(_, [], _).
genCodeList(Out, [C], _) :- genCode(Out, C).
genCodeList(Out, [X, Y | L], Sep) :- genCode(Out, X),
                                format(Out, '~a', [Sep]),
                                genCodeList(Out, [Y | L], Sep)
.

%statements para arreglar lo de []
isVar(F,X) :- atom_length(X,L)
            , L > 1, \+ F = 'CALL'
            , \+ number(X)
            , \+ sub_string(F, _,1, _,'J')
            , \+ sub_string(X, _,6, _,'string').

fixname(F, X,Y) :- isVar(F, X) -> concat('[', X, X1),
							concat(X1, ']', Y);
							X = Y
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
