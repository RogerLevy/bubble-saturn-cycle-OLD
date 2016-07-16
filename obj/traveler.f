actor super
  var sc  \ shoot counter
  var ac  \ animation counter
  var mode  \
class traveler

\ ------------------------------------------------------------------------------
\ Thexder Controls
94 100 / constant fric#
1 6 / constant force#
8 3 / constant limit#
: limit  ( -- ) vx 2v@ hypot limit# > if  vx 2v@ angle limit# vector vx 2v!  then ;
: friction ( -- ) vx 2v@ fric# uscale vx 2v! ;
: accel  ( x y -- ) force# uscale vx 2v+! ;

: controls ( -- )  udlrvec accel friction limit ;

: orientation ( -- angle )
  hitflags# set?
  udlrvec or and if  vx 2v@  angle  else
  udlrvec or if  udlrvec  angle  else  ang @  then  then ;

: ?upright  360 + 360 mod  dup 90 >= over 270 <= and FLIP_V and flip ! ;

: orient  ( -- )  ang @  orientation  0.2 anglerp  ?upright  ang ! ;

: thexder  act>   controls  orient ;

\ ------------------------------------------------------------------------------

: anmfrm>  ( -- n )  vx 2v@ magnitude 1 + 15 / ac +!  ac @ 1 and ;

traveler start:
  -7 -7 boxx 2v!  14 14 w 2v!  32 12 orgx 2v!
  csolid# cedible# or cpickup# or cemis# or cnpc# or cmask !
    cplayer# cflags !
  thexder
  show>  anmfrm> SPR_EARWIG showSpriteRS
;
