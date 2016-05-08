fixed

actor single cam
explorer single player

\ generate random boxes
\ : /boxes  ( -- )
\   boxGrid resetCgrid
\   #boxes 0 do  box one  ahb boxGrid addCbox  loop ;
\
\ /boxes

: *box  ( x y w h -- )  box one  w 2v! x 2v!  updateCbox  ahb boxGrid addCbox ;

\ camera
create m  16 cells /allot

: camTransform  ( -- matrix )
  m al_identity_transform
  m  cam 's x 2v@ 2pfloor 2negate 2af  al_translate_transform
  m ;

: camTrack  ( -- )
  player 's x 2v@  player 's w 2v@ 2halve 2+
  gfxw gfxh 2halve  2-  extents 2clamp  cam 's x 2v! ;

: camRender  ( ---)
  camTrack
  0.5 0.5 0.5 1.0 clear-to-color
  camTransform
  dup  factor @ dup 2af  al_scale_transform
    al_use_transform
  area000.image bmp @ 0 0 2af 0 al_draw_bitmap
  0 all> show ;


\ piston config
' camRender is render
: step2  0 all>  vx 2v@ x 2v+!  updateCbox ;
:noname  [ is sim ]  step1  step2  numFrames ++ ;


\ new game
: dropPlayer  player stage add  252 258 player put ;
: loadMap  ( n -- )
  cleanup  boxGrid resetCgrid  drop  " data\maps\test-coldata.f" included ;
: newGame ( -- )  0 loadMap  dropPlayer ;


\ initialization
newGame
