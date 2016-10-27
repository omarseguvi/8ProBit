/*
EIF400 loriacarlos@gmail.com
*/
run :- working_directory(O, '../src/8bits.compile'), 
   writeln('Loading compiler'),
   [eightCompiler],
   writeln('Compiler loaded'),
   working_directory(_, O),
   working_directory(_, '..'),
   working_directory(OF, OF),
   atom_concat('*** Working in ', OF, Cdir),
   writeln(Cdir)
. 

:- run.
 