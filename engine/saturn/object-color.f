actor super
  \ Allegro color

  var fcolor
  : fr  fcolor ;
  var fg
  var fb
  var fa
extend actor

: !color   ( r g b a -- )  4af fcolor ~!+ ~!+ ~!+ ~!+ drop ;
: 8b dup $ff and c>p ;
: hex>color  8b >r 8 >> 8b >r 8 >> 8b >r 8 >> 8b nip r> r> r> ;
: !hex    ( i -- )  hex>color !color ;

\ : red!  ( n allegro-color -- ) >r 1af r> ! ;
\ : green!  ( n allegro-color -- ) >r 1af r> cell+ ! ;
\ : blue!  ( n allegro-color -- ) >r 1af r> cell+ cell+ ! ;
\ : alpha!  ( n allegro-color -- ) >r 1af r> cell+ cell+ cell+ ! ;
