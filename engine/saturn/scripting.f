: start:  ( class -- ) :noname swap 'onstart ! ;
: single  one me constant  persistent# flags or! ;
: halt  0 0 vx 2v! ;

\ 4-way input
: left?  ( -- flag )  <left> kstate  <pad_4> kstate or  ; \ 0 0 joy x -0.25 <= or ;
: right?  ( -- flag ) <right> kstate  <pad_6> kstate or ; \ 0 0 joy x 0.25 >= or ;
: up?  ( -- flag )    <up> kstate  <pad_8> kstate or    ; \ 0 0 joy y -0.25 <= or ;
: down?  ( -- flag )  <down> kstate  <pad_2> kstate or  ; \ 0 0 joy y 0.25 >= or ;

: udlrvec  ( -- x y )
  0 0
  left? if  -1 u+  then
  right? if  1 u+  then
  up? if    -1 +   then
  down? if   1 +   then ;

\ : /ones  ( ... xt n class -- ... )
\   swap 0 do  dup one >r dup >r execute r> r>  loop  2drop ;
\
\ : ones  ( n class -- )  .. -rot /ones ;

: put  ( x y actor -- )  's x 2v! ;

: is?  swap class @ = ;

create dummy  /actorslot /allot

