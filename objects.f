doming +order

fixed

actor super
  var w            \ hitbox dimensions
  var h
  /cbox field ahb  \ Actor Hit Box

  var HP           \ hit points
  var maxHP        \ max hit points
  var ATK
  var DEF

  var flip         \ allegro flip flags

\  staticvar initData  \ see commonInit config below for param order.
extend actor

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

\ -----------------------------------------------------------------------------

: clampVel  x 2v@  vx 2v@  2+  extents  w 2v@ 2-  2clamp  x 2v@ 2-  vx 2v! ;

: ahb>actor  [ ahb me - ]# - ;
: drawCbox    ahb cbox@ 1 1 2- 2over 2+ 4af  1 1 1 1 4af  1 1af  al_draw_rectangle ;
: updateCbox  x 2v@  w 2v@  ahb cbox! ;

\ -----------------------------------------------------------------------------

: drawImage  bmp @  x 2v@ 2af  flip @  al_draw_bitmap ;

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
  x 2v@  vx @ u+  w 2v@  ahb cbox!
  ahb literal boxGrid checkCbox
;
:noname  nip ?tb  drop false ;
: moveY  ( -- )
  vy @ -exit
  x 2v@  vy @ +  w 2v@  ahb cbox!
  ahb literal boxGrid checkCbox
;

\ -----------------------------------------------------------------------------

actor super class box

: *box  ( x y w h -- )  box one  w 2v! x 2v!  updateCbox  ahb boxGrid addCbox ;

\ -----------------------------------------------------------------------------

actor super
  var sc  \ shoot counter
  var ac  \ animation counter
class traveler

\ 14 f constant radius#
94 100 / constant fric#
1 4 / constant force#
8 3 / constant limit#
: limit  ( -- ) vx 2v@ hypot limit# > if  vx 2v@ angle limit# vector vx 2v!  then ;
\ : shoot 5 channel *gun* playsmp { generate bullet vx 2! } ;
: friction ( -- ) vx 2v@ fric# uscale vx 2v! ;
: accel  ( x y -- ) force# uscale vx 2v+! ;
\ : collisions radius# /orbs life +! 1 channel bell playsmp ( life @ . ) ;
\ : ?shoot sc ++ sc @ 1 and if <z> key if 0 14 f shoot then ;; then <a> key if 0 -14 f shoot then ;

: controls ( -- )
  udlrvec accel friction limit ( ?shoot { collisions } restrict ) ;

\ : loc 512 2/ 384 2/ 30 + 2f x 2! ;
\ : initship ship loc controls draw radius> i circ ;

transform t
transform oldm
: transformed
  r>
  0 0 at  
  al_get_current_transform oldm /transform move
  t  al_identity_transform
  t  -32 -12 2af al_translate_transform
  t  vx 2v@ angle 1f d>r 1sf al_rotate_transform
  t  x 2v@ 8 8 2+ 2pfloor 2af al_translate_transform
  t  oldm al_compose_transform
  t  al_use_transform
  call
  oldm al_use_transform ;

: animated
  \ vx 2@ magnitude dup 1 < if drop 0 exit then  #frames 8 / * 1 and ;
  vx 2v@ magnitude 1.5 + 15 / ac +!
  ac @ 1 and ;


: ?0vx
  flags @ right# left# or and if  0 vx !  then
  flags @ top# bottom# or and if  0 vy !  then ;

: dynamicBoxPhysics
  right# left# bottom# top# or or or flags not!
  moveX  moveY  ?0vx  vx 2v@ x 2v+!
  updateCbox ;

traveler start:
  18 18 w 2v!
  act>  controls  clampVel
  physics>  dynamicBoxPhysics
  show>  transformed  animated SPR_EARWIG drawSprite
;

\ -----------------------------------------------------------------------------

actor super class homearea
homearea start:  show>  area000.image drawImage ;


create w01a02bgObj
  w01_a02_bg001.image ,
  w01_a02_bg002.image ,
  w01_a02_bg003.image ,
  w01_a02_bg004.image ,
  w01_a02_bg005.image ,
  w01_a02_bg006.image ,
  w01_a02_bg007.image ,
  w01_a02_bg008.image ,
  w01_a02_bg009.image ,
  w01_a02_bg010.image ,
  w01_a02_bg011.image ,
  w01_a02_bg012.image ,
  w01_a02_bg013.image ,
  w01_a02_bg014.image ,
  w01_a02_bg015.image ,
  w01_a02_bg016.image ,
  w01_a02_bg017.image ,
  w01_a02_bg018.image ,

create bgObjTables
  w01a02bgObj , w01a02bgObj ,

actor super
  var subtype  \ index into current bg object table (pointed to by tbl)
  var tbl  \ index into bgObjTables
class bgobj

: img>  bgObjTables tbl @ th @  subtype @ th @ ;

bgobj start:  show>  img>  drawImage ;

: /subtype  ( -- )
  " gid" @attr $fffffff and  me class @ firstgid @  -  subtype ! ;
bgobj onMapLoad:  /subtype  /flip ;


actor super class trilobite

:noname [ is onLoadBox ]  " width" @attr " height" @attr *box ;

doming -order
