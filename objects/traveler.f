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
  t  ang @ 1f d>r 1sf al_rotate_transform
  t  x 2v@ 8 8 2+ 2pfloor 2af al_translate_transform
  t  oldm al_compose_transform
  t  al_use_transform
  call
  oldm al_use_transform ;
 
: orient
  flags @ hitflags# and not if
    ang @  vx 2v@ angle  0.2 anglerp  ang !
  then ;

: animated
  \ vx 2@ magnitude dup 1 < if drop 0 exit then  #frames 8 / * 1 and ;
  vx 2v@ magnitude 1.5 + 15 / ac +!
  ac @ 1 and ;


traveler start:
  18 18 w 2v!
  act>  controls  clampVel
  physics>  dynamicBoxPhysics  orient
  show>  transformed  animated SPR_EARWIG drawSprite
;
