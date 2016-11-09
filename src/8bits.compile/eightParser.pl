/*
EIF400 loriacarlos@gmail.com
*/
:- dynamic table/2.
:- [eightLexer]
.
testParser(P) :-
    parse('../helloWorld.8bit', P)
.
parse(File, Prog) :-
    tokenize(File, Tokens),
	eightProgram(Prog, Tokens, []) %no deben sobrar cosas el []
.

eightProgram(eightProg(FL)) --> eightFunList(FL)
.

eightFunList([]) --> []
.
eightFunList([F|R]) --> eightFunction(F), eightFunList(R)
.
eightFunction(fun(X, formals(F), body(B))) --> [fun], id(X), formals(F), ['{'], body(B), ['}']
.
id(id(X)) --> [X], {atomic(X)}
.

formals(L) --> ['('], idList(L), [')']
.

idList([]), [')'] --> [')']
.
idList([I])  --> id(I), idList([])
.
idList([I, J | L]) --> id(I), [','], id(J), idList(L)
.

body([]), ['}'] --> ['}']
.
body([S | L]) --> statement(S), body(L)
.

statement(empty) --> [;]
.
statement(S) --> callStatement(S)
.
%statement(S) --> letStatement(S)
%.
statement(S) --> returnStatement(S)
.
statement(S) --> assignStatement(S)
.


/*letStatement(let(S)) --> ['let'], ['{'], assignStatementList(S), ['}']
.
assignStatementList([]), ['}'] --> ['}']
.
assignStatementList([I]) --> assignStatement(I) , assignStatement([])
.
assignStatementList([I, J | L]) --> assignStatement(I), [';'], assignStatement(J), assignStatementList(L)
.*/

returnStatement(return(E)) --> [return], expression(E)
.
assignStatement(assign(L, R)) --> id(L), ['='], expression(R)
.
/*Regla para callStatement*/
callStatement(cll(X,S)) --> id(X), args(S)
.
args(S) --> ['('], argsList(S), [')']
.
argsList([]), [')'] --> [')']
.
argsList([I]) --> expression(I), argsList([])
.
argsList([I, J | L]) --> expression(I), [','], expression(J), argsList(L)
.

expression(E) --> addExpression(E)
.
addExpression(operation(oper('+'), L, R)) --> mulExpression(L), ['+'], addExpression(R), {!}
.
addExpression(M) --> mulExpression(M)
.
mulExpression(operation(oper('*'), L, R)) --> factor(L), ['*'], mulExpression(R), {!}
.
mulExpression(F) --> factor(F)
.

factor(E) --> ['('], expression(E), [')']
.
factor(num(N)) --> [A], {atom_number(A, N)}
.
factor(X) --> id(X)
.

operator(oper(O)) --> {member(O, ['+', '*', '-', '/']), !}
.

string_atom(S, A) :- atom_string(A, S).
