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

eightFunction(fun(X, formals(F), body(B))) --> [fun], id(X), formals(F), body(B), ['}']
.

id(str(X)) --> [X], {atomic(X), string_chars(X, ['"'|_])}
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

body([]), ['}'] --> ['}'], ['}']
.

body([S | L]) --> statement(S), body(L)
.

body([S | L]) --> ['{'],  statement(S), body(L)
.

comparison(comp(L,R, cmp(X))) --> [L], [X], [R]
.
comparison(comp(L,R, cmp(I))) --> ['!'],['('],[L], [X], [R],[')'],{hash_inverse(X,I)}
.

statement(empty) --> [;]
.
/*Se pone un cut porque solo una vez tiene que venir en cada función*/
statement(S) --> letStatement(S)
.
statement(S) --> callStatement(S)
.
statement(S) --> returnStatement(S)
.
statement(S) --> assignStatement(S)
.
statement(S) --> ifStatement(S)
.
statement(S) --> whileStatement(S)
.

/*Regla para el let*/
letStatement(let(S)) -->  [let], ['{'], assignStatementList(S),['}']
.
assignStatementList([]), ['}'] --> ['}']
.
assignStatementList([F| R]) --> assignStatement(F), [;], assignStatementList(R)
.
/*Regla para el while*/
whileStatement(while(C,body(B))) --> [while],['('], comparison(C), [')'], ['{'], body(B), ['}']
.
/*Regla para el if*/

ifStatement(if(C,ifbody(B))) --> [if],['('], comparison(C), [')'], ['{'], body(B), ['}']
.
/*Regla para el if else*/
ifStatement(if(C,ifbody(B),else(E))) --> [if],['('], comparison(C), [')'], ['{'], body(B), ['}'] , [else], ['{'], body(E), ['}']
.
/*Regla para el if sin */
ifStatement(if(C,ifbody(B))) --> [if],['('], comparison(C), [')'], statement(B)
.
/*Regla del if y else sin { }*/
ifStatement(if(C,ifbody(B),else(E))) --> [if],['('], comparison(C), [')'], statement(B), [else], statement(E)
.
/*Regla para el return*/
returnStatement(return(E)) --> [return], expression(E)
.
/*Regla para la assignacion*/
assignStatement(assign(L, R)) --> id(L), ['='], expression(R)
.
/*Regla para la llamada de funciones */
callStatement(cll(X,S)) --> id(X), args(S)
.
scall(scll(X,S)) --> id(X), args(S)
.
args(S) --> ['('], argsList(S), [')']
.
argsList([]), [')'] --> [')']
.
argsList([I]) --> scall(I), argsList([])
.
argsList([I]) --> expression(I), argsList([])
.
argsList([I, J | L]) --> expression(I), [','], expression(J), argsList(L)
.

expression(E) --> addExpression(E)
.

expression(E) --> subExpression(E)
.

addExpression(operation(oper('+'), L, R)) --> mulExpression(L), ['+'], addExpression(R), {!}
.
addExpression(M) --> mulExpression(M)
.

addExpression(M) --> divExpression(M)
.

subExpression(operation(oper('-'), L, R)) --> mulExpression(L), ['-'], subExpression(R), {!}
.

subExpression(M) --> mulExpression(M)
.

subExpression(M) --> divExpression(M)
.
mulExpression(operation(oper('*'), L, R)) --> factor(L), ['*'], {write(R)},callStatement(R), {!}
.
mulExpression(operation(oper('*'), L, R)) --> factor(L), ['*'],mulExpression(R),{!}
.

mulExpression(F) --> factor(F)
.

divExpression(operation(oper('/'), L, R)) --> factor(L), ['/'], divExpression(R), {!}
.

divExpression(F) --> factor(F)
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

hash_inverse('>','<=').
hash_inverse('>=','<').
hash_inverse('<','>=').
hash_inverse('<=','>').
hash_inverse('==','!=').
hash_inverse('!=','==').
