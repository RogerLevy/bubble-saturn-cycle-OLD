actor super
  var w            \ hitbox dimensions
  var h
  /cbox field ahb  \ Actor Hit Box

  var HP           \ hit points
  var maxHP        \ max hit points
  var ATK
  var DEF

extend actor

actorBit
bit top#
bit bottom#
bit left#
bit right#
to actorBit


: clampVel  x 2v@  vx 2v@  2+  extents  w 2v@ 2-  2clamp  x 2v@ 2-  vx 2v! ;

: ahb>actor  [ ahb me - ]# - ;
: drawCbox    info @ -exit  ahb cbox@ 2over 2+ 4af  1 1 1 1 4af  1 1af  al_draw_rectangle ;
: updateCbox  x 2v@  w 2v@  ahb cbox! ;


cgridding +order

  \ push current actor out of given ahb and set appropriate flags
  : ?lr  ( ahb -- )
    [ right# left# or invert ]# flags and!
    vx @ 0> if
      x1 @  ahb x2 @ -  1 +  x +!  right#
    else
      x2 @  ahb x1 @ -  1 -  x +!  left#
    then
    flags or!  0 vx !  ;

  : ?tb  ( ahb - )
    [ bottom# top# or invert ]# flags and!
    vy @ 0> if
      y1 @  ahb y2 @ -  1 +  y +!  bottom#
    else
      y2 @  ahb y1 @ -  1 -  y +!  top#
    then
    flags or!  0 vy !  ;

cgridding -order

:noname  nip ?lr  drop false ;
: do-x  ( -- )
  vx @ -exit
  x 2v@  vx @ u+  w 2v@  ahb cbox!
  ahb literal boxGrid checkCbox
;
:noname  nip ?tb  drop false ;
: do-y  ( -- )
  vy @ -exit
  x 2v@  vy @ +  w 2v@  ahb cbox!
  ahb literal boxGrid checkCbox
;


actor super class box
actor super class explorer

box start:
  extents 2nip 2rnd x 2v!
  128 128 2rnd 5 5 2max w 2v!
;
\ the size of each box is randomized here.


explorer start:
  36 16 w 2v!
  act>  vx udlrvec  clampVel  do-x do-y
  show> x 2v@ -12 -8 2+ at  0 SPR_EARWIG drawSprite
;


