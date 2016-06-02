fixed

actor single cam
traveler single player

\ generate random boxes
\ : /boxes  ( -- )
\   boxGrid resetCgrid
\   #boxes 0 do  box one  ahb boxGrid addCbox  loop ;
\
\ /boxes

: *box  ( x y w h -- )  box one  w 2v! x 2v!  updateCbox  ahb boxGrid addCbox ;


\ baseline matrix
transform baseline

: /baseline
  baseline  al_identity_transform
  baseline  factor @ dup 2af  al_scale_transform
  baseline  al_use_transform  ;


\ camera
create m  16 cells /allot

: camTransform  ( -- matrix )
  m al_identity_transform
  m  cam 's x 2v@ 2pfloor 2negate 2af  al_translate_transform
  m ;

: camTrack  ( -- )
  player 's x 2v@  player 's w 2v@ 2halve  2+
  gfxw gfxh 2halve  2-  extents 2clamp  cam 's x 2v! ;


: cls  0 0 0 1 clear-to-color ;

: showAll  0 all>  show ;
: showBoxes  info @ -exit  0 all>  drawCbox ;
: camRender  ( -- )
  cls
  /baseline
  parared.image  cam 's x 2v@ 0.4 0.4 2*  drawWallpaper
  camTrack
  camTransform  dup  factor @ dup 2af  al_scale_transform
    al_use_transform
  showAll
  showBoxes ;


\ piston config
' camRender is render
: step2  0 all>  vx 2v@ x 2v+!  updateCbox ;
:noname  [ is sim ]  step1  step2  1 +to #frames ;


\ new game
\ : dropPlayer  player stage add  252 238 player put ;
\ : loadMap  ( n -- )
\   drop  cleanup  boxGrid resetCgrid  " data\maps\test-coldata.f" included ;
\ : newGame ( -- )  0 loadMap  dropPlayer ;

