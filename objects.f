doming +order

fixed

actor super
  var w            \ hitbox dimensions
  var h
  /cbox field ahb  \ Actor Hit Box
  var boxx
  var boxy 

  var HP           \ hit points
  var maxHP        \ max hit points
  var ATK
  var DEF

  var flip         \ allegro flip flags
  var ang          \ angle
  var orgx         \ display origin (normally positive)
  var orgy


\  staticvar initData  \ see commonInit config below for param order.
extend actor

: disporg  orgx 2v@ ;

decimal
  create lookupTbl  0 , 2 , 1 , 3 ,
  : tmx>aflip  cells lookupTbl + @ ;
  : /flip  decimal " gid" @attr 30 >> tmx>aflip flip ! fixed ;
  actor onMapLoad:  /flip ;
fixed

\ -----------------------------------------------------------------------------

\ : initData:  ( class -- <data,> ) here swap initData ! ;
\
\ actor initData: 16 , 16 ,
\
\ :noname  [ is commonInit ]
\   me class @ initData @  @+ w !  @+ h !  drop ;

\ -----------------------------------------------------------------------------

actorBit
  bit top#
  bit bottom#
  bit left#
  bit right#
to actorBit

top# bottom# left# right# or or or constant hitflags#

\ -----------------------------------------------------------------------------

: clampVel  x 2v@  vx 2v@  2+  extents  w 2v@ 2-  2clamp  x 2v@ 2-  vx 2v! ;

: ahb>actor  [ ahb me - ]# - ;

: putCbox  boxx 2v@ 2+  w 2v@  ahb cbox! ;

: updateCbox  x 2v@  putCbox ;

\ : boxXY  x 2v@  boxx 2v@ 2+ ;

\ -----------------------------------------------------------------------------

: showImage  ( image -- )  bmp @  x 2v@ 2af  flip @  al_draw_bitmap ;

: showSprite'  ( spr# set# -- )
  sprite>af
    1 1 1 1 4af  disporg 2af  x 2v@ 2af  1 1 2af  ang @ radians 1af  flip @
    al_draw_tinted_scaled_rotated_bitmap_region ;

: showCbox
  ahb cbox@ 1 1 2- 2over 2+ 4af  1 1 1 1 4af  1 1af  al_draw_rectangle ;

\ -----------------------------------------------------------------------------
\ simple bounding box physics

\ push current actor out of given ahb and set appropriate flags
: ?lr  ( box -- )
  [ right# left# or invert ]# flags and!
  vx @ 0> if
    x1 @  ahb x2 @ #1 + -  vx @ +  x +!  right#
  else
    x2 @ #1 +  ahb x1 @ -  vx @ +  x +!  left#
  then
  flags or! ;

: ?tb  ( box -- )
  [ bottom# top# or invert ]# flags and!
  vy @ 0> if
    y1 @  ahb y2 @ #1 + -  vy @ +  y +!  bottom#
  else
    y2 @ #1 +  ahb y1 @ -  vy @ +  y +!  top#
  then
  flags or! ;


:noname  nip ?lr  drop false ;
: moveX  ( -- )
  vx @ -exit
  x 2v@  vx @ u+  putCbox
  ahb literal boxGrid checkCbox
;
:noname  nip ?tb  drop false ;
: moveY  ( -- )
  vy @ -exit
  x 2v@  vy @ +  putCbox
  ahb literal boxGrid checkCbox
;

: ?0vx
  flags @ right# left# or and if  0 vx !  then
  flags @ top# bottom# or and if  0 vy !  then ;

: dynamicBoxPhysics
  hitflags# flags not!
  moveX  moveY  ?0vx  vx 2v@ x 2v+!
  updateCbox ;

\ -----------------------------------------------------------------------------
\ load game object scripts
\  keep these as uncoupled as possible.

include objects\box
include objects\traveler
include objects\homearea
include objects\bgobj
include objects\trilobite
