
4 cells struct /rect
: rect  ( x y w h -- <name> ) create  2swap swap , , swap , , ;
: @x    @ ;                            : !x    ! ;
: @y    cell+ @ ;                      : !y    cell+ ! ;
: @w    cell+ cell+ @ ;                : !w    cell+ cell+ ! ;
: @h    cell+ cell+ cell+ @ ;          : !h    cell+ cell+ cell+ ! ;
: @xy   2v@ ;                          : !xy   2v! ;
: @wh   cell+ cell+ 2v@ ;              : !wh   cell+ cell+ 2v! ;

include engine\modules\rects-generics

marker dispose
1 2 3 4 rect r
include engine\modules\rects-tests
dispose
