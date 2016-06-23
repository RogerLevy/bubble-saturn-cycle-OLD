actor super
  var sc  \ shoot counter
  var ac  \ animation counter
  var mode  \
class traveler

\ ------------------------------------------------------------------------------
\ Thexder Controls
94 100 / constant fric#
1 4 / constant force#
8 3 / constant limit#
: limit  ( -- ) vx 2v@ hypot limit# > if  vx 2v@ angle limit# vector vx 2v!  then ;
: friction ( -- ) vx 2v@ fric# uscale vx 2v! ;
: accel  ( x y -- ) force# uscale vx 2v+! ;

: controls ( -- )  udlrvec accel friction limit ;

: orientation ( -- angle )
  flags @ hitflags# and not
  udlrvec or and if  vx 2v@  angle  else
  udlrvec or if  udlrvec  angle  else  ang @  then  then ;
: orient  ( -- )  ang @  orientation  0.2 anglerp  ang ! ;

: thexder  act>  controls  clampVel  orient ;

\ ------------------------------------------------------------------------------

: anmfrm>  ( -- n )  vx 2v@ magnitude 1.5 + 15 / ac +!  ac @ 1 and ;

traveler start:
  -9 -9 boxx 2v!  18 18 w 2v!  32 12 orgx 2v!
  csolid# cedible# or cpickup# or cemis# or cnpc# or cmask !
    cplayer# cflags !
  thexder
  show>  anmfrm> SPR_EARWIG showSprite'
;
