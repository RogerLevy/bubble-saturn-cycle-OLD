doming +order

fixed


actor super
  var w            \ hitbox dimensions
  var h
  /cbox field ahb  \ Actor Hit Box
  var boxx         \ typically negative
  var boxy 

  var HP           \ health points
  var maxHP        \ max health points
  var ATK
  var DEF

  var flip         \ allegro flip flags
  var ang          \ angle
  var orgx         \ display origin (normally positive, from top-left of image)
  var orgy

  var cflags
  var cmask

  var 'hit         \ ( you=other -- )

\  staticvar initData  \ see commonInit config below for param order.

extend actor

include engine\saturn\task-sf.f


: hit>  r> code> 'hit ! ;
: hit   'hit @ execute ;

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
\ Zone types

1
  enum talky
  enum interest
  enum usable
drop

\ -----------------------------------------------------------------------------

actorBit
  bit static#
  bit top#
  bit bottom#
  bit left#
  bit right#
to actorBit

top# bottom# left# right# or or or constant hitflags#

\ -----------------------------------------------------------------------------
\ rendering stuff

: showImage  ( image -- )  bmp @  x 2v@ 2af  flip @  al_draw_bitmap ;

\ : af-fit  ( w h w h -- af-sx af-sy )
\   1f rot 1f f/ 1f rot 1f f/ 2sf swap ;

: fitImage  ( image -- )
  with  o bmp @  0 0 2af  o imageDims 2af  x 2v@ 2af  w 2v@ 2af  flip @  al_draw_scaled_bitmap ;


: showSprite'  ( spr# set# -- )
  sprite>af
    1 1 1 1 4af  disporg 2af  x 2v@ 2af  1 1 2af  ang @ radians 1af  flip @
    al_draw_tinted_scaled_rotated_bitmap_region ;

: showCbox
  ahb cbox@ 1 1 2- 2over 2+ 4af  1 1 1 1 4af  1 1af  al_draw_rectangle ;

\ -----------------------------------------------------------------------------
\ some map data utilities
doming +order
: @dims  " width" @attr " height" @attr ;
: /dims  ( -- )  @dims w 2v! ;
doming -order

: clampVel  ( -- ) x 2v@  vx 2v@  2+  extents  w 2v@ 2-  2clamp  x 2v@ 2-  vx 2v! ;
