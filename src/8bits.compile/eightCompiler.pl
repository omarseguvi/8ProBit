/*
EIF400 loriacarlos@gmail.com
*/

:- [eightEmiter].

compile(InPath, OutPath, Filename) :-
   atom_concat(InPath, Filename, PathInFile),
   exists_file(PathInFile), !,
   format('*** Compiling :"~a" *** ~n', [PathInFile]),
   parse(PathInFile, P),
   writeln(P),
   atom_concat(OutPath, Filename, PathOutFile),
   atom_concat(PathOutFile, '.asm', JsOutFile),
   format('*** Writing   :"~a" *** ~n', [JsOutFile]),
   genCodeToFile(JsOutFile, P)
.
compile(InPath, _, Filename) :-
   atom_concat(InPath, Filename, PathInFile),
   format('*** File Not found :"~a" *** ~n', [PathInFile]),
   fail
.
compile(Filename) :- compile('cases/', 'output/', Filename)
.
% Demo test case
compile :- compile('helloWorld.8bit')
.

main :-
    writeln('*** Starting compilation ***'),
    current_prolog_flag(argv, AllArgs),
   [E|_] = AllArgs,
    compile(E),
	writeln('*** Sucessful compilation ***'), !
.
main :-
    writeln('*** Provide an existin test case file ***')
.
