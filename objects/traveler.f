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
 
: orient
  flags @ hitflags# and not
  udlrvec or and if
    ang @  vx 2v@ angle  0.2 anglerp  ang !
  then ;

: anmfrm>  ( -- n )  vx 2v@ magnitude 1.5 + 15 / ac +!  ac @ 1 and ;

traveler start:
  -9 -9 boxx 2v!
  18 18 w 2v!
  32 12 orgx 2v!
  act>  controls  clampVel
  physics>  dynamicBoxPhysics  orient
  show>  anmfrm> SPR_EARWIG showSprite'
;
