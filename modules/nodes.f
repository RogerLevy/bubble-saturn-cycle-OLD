decimal

\ /CLASS supports rudimentary static vars for classes.
\  static vars are not inherited.  they have to be set for each individual class
\  as needed.  NTS: implement proper static var inheritence later if needed
\  to add and assign static vars,
\    <superclass> SUPER
\      ...
\      STATICVAR <name>
\      ...
\    CLASS <name>
\    ...
\    <value> class <static var> !

0  xvar prevClass  xvar nextClass  xvar isize  xvar classSize  value /class

variable firstClass
variable lastClass

package class-defs
  : (class-min-size)  14 cells  /class cell- cell- max ;
  : class   ( super isize -- <name> )
    create
    here  lastClass @ , 0 ,  dup  lastClass @ nextClass !  lastClass !
    ( isize ) ,
    cell+ cell+   here  (class-min-size)  move  (class-min-size)  /allot
    class-defs -order ;
  : extend  class ; 
end-package
: super  dup isize @  class-defs +order ;        ( class -- super isize )
\ : extend  !  class-defs -order ;


: staticvar  ( -- <name> )  /class xvar to /class ;



0
  xvar class  xvar prev  xvar next  xvar parent

create node  here dup firstClass ! lastClass !
  0 , ( isize ) , /class ,  14 cells /allot

: sizeof  isize @ ;                                                     ( obj -- i )
: obj  here swap  dup ,  isize @ cell- /allot ;                                 ( class -- obj )
: list  create  0 ( length ) , 0 ( first ) , 0 ( tail ) , ;

0  xvar length  xvar first  xvar tail   drop                                    \ internal

fixed

: (unlink)  ( node -- )
  dup prev @ if  dup next @  over prev @ next !  then
  dup next @ if  dup prev @  over next @ prev !  then
  dup prev off  next off ;

: remove  ( node list -- )
  dup 0= if  2drop exit  then
  over parent @ 0= if  2drop exit  then  \ not already in any list
  over parent @ over <> if  2drop exit  then  \ not in given list
  >r
  r@ length --
  r@ length @ if
    dup r@ first @ = if  dup next @  r@ first !  then
    dup r@ tail @ = if  dup prev @  r@ tail !  then
  else
    r@ first off  r@ tail off
  then
  r> ( list ) drop  ( node ) dup parent off  (unlink) ;
: add  ( node list -- )
  dup 0= if  2drop exit  then
  over parent @ if
    over parent @ over = if  2drop exit  then  \ already in given list
    over dup parent @ remove  \ if already in another list, remove it first
  then
  >r
  r@ over parent !
  r@ length ++
  r@ length @ 1 = if
    dup r@ first !
  else
    r@ tail @
    over prev !  dup r@ tail @ next !
  then
  r> tail ! ;
: itterate  ( ... xt list -- ... )   ( ... obj -- ... )
  first @  begin  dup while  dup next @ >r  over >r  swap execute  r> r> repeat  2drop ;
: <itterate
  tail @  begin  dup while  dup prev @ >r  over >r  swap execute  r> r> repeat  2drop ;

:noname  ( list node -- list )  over swap parent ! ; ( xt )

: graft  ( list1 list2 -- )  \ move the contents of list2 to list1
  locals| b a |
  b length @  ?dup -exit  a length +!  b length off
  a tail @ b first @ prev !
  a tail @ if    b first @ a tail @ next !  
           else  b first @ a first !
           then
  b tail @ a tail ! 
  b first off  b tail off
  a ( xt ) LITERAL over itterate drop  \ change the parent of each one
  ;

: popNode  ( list -- node )  dup tail @ dup rot remove ;



\ --- test ---

marker dispose
node obj constant a
node obj constant b
node obj constant c
list l 
a l add
b l add
c l add
: test   <> abort" list test failed" ;

l length @ 3 test
l popnode c test
  l length @ 2 test
    l tail @ b test
l popnode b test
  l length @ 1 test
    l tail @ a test
l popnode a test
  l length @ 0 test
    l tail @ 0 test
    
cr .( PASSED: lists )
dispose
