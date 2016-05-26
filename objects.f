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
decimal
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
fixed


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

: ~dims  128 128 2rnd 5 5 2max w 2v! ;

: *randomBox  extents somewhere at  box one ~dims ;




actor super
  var sc  \ shoot counter
  var ac  \ animation counter
class explorer

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

: transformed
  r>
  al_get_current_transform >r
  t al_identity_transform
  t w 2v@ 2negate 2af al_translate_transform
  t vx 2v@ angle 1f d>r 1sf al_rotate_transform
  t x 2v@ 2af al_translate_transform
  t r@ al_compose_transform
  t al_use_transform
  call
  r> al_use_transform ;

: animated
  \ vx 2@ magnitude dup 1 < if drop 0 exit then  #frames 8 / * 1 and ;
  vx 2v@ magnitude 1.5 + 15 / ac +!
  ac @ 1 and ;


explorer start:
  18 18 w 2v!
  act>  controls  clampVel  do-x do-y
  show>  0 0 at ( x 2v@ -14 -7 2+ at )  transformed  animated SPR_EARWIG drawSprite
;


