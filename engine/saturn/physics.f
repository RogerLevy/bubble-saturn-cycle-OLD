1000 extents 2nip collisionGrid boxGrid
2000 extents 2nip collisionGrid dynGrid

cgridding +order

\ physics rules

\  cflags defines the physics properties and "groups" of an object
\  cmask  defines what objects an object can "detect"
\  if an object's cflags are all 0 it won't be able to be detected by anything.
\  if cgroup is all 0 it disables detecting other objects


\ the flags:
cbit
  bit CSOLID#    \ makes an object solid
  bit CPLAYER#
  bit CNPC#
  bit CPICKUP#
  bit CEDIBLE#
  bit CPMIS#     \ player missile
  bit CEMIS#     \ enemy missile
  bit CSLIPPERY#
  bit CSPIKES#
  bit CZONE#
to cbit

\ for now (6/19) we do a simplified physics algorithm that goes like this:
\ pass 1: update dynamic grid (velocity+)
\ pass 2: check dynamic grid (solid dynamic objects not yet supported.)
\ pass 3: check box grid, pushing things out and setting velocity axes to 0 as needed


: ahb>actor  ( ahb -- actor )  [ ahb me - ]# - ;
: putCbox  ( x y -- )  boxx 2v@ 2+  w 2v@  ahb cbox! ;
: hitbox  ( -- x1 y1 x2 y2 )  x 2v@ boxx 2v@ 2- w 2v@ 2over 2+ ;

\ -----------------------------------------------------------------------------
\ simple bounding box physics

\ push current actor out of given ahb and set appropriate flags
: ?lr  ( box -- )
  [ right# left# or invert ]# flags and!
  vx @ 0> if   x1 @  ahb x2 @ #1 + -  vx @ +  x +!  right#
          else x2 @ #1 +  ahb x1 @ -  vx @ +  x +!  left#  then
  flags or! ;

: ?tb  ( box -- )
  [ bottom# top# or invert ]# flags and!
  vy @ 0> if   y1 @  ahb y2 @ #1 + -  vy @ +  y +!  bottom#
          else y2 @ #1 +  ahb y1 @ -  vy @ +  y +!  top#  then
  flags or! ;


: ahead  ( xt grid x y -- )  putCbox ahb -rot checkCbox ;

:noname  ( b1 b2 -- )  nip ?lr  drop false ;
: moveX  vx @ -exit  literal boxGrid  x 2v@  vx @ u+  ahead ;

:noname  ( b1 b2 -- )  nip ?tb  drop false ;
: moveY  vy @ -exit  literal boxGrid  x 2v@  vy @ +  ahead ;


: ?0vx
  right# left# or set? if  0 vx !  then
  top# bottom# or set? if  0 vy !  then ;

: /boxes  hitflags# flags not!  moveX  moveY  ?0vx ;

: !dyns
  dynGrid resetGrid
  0 stage all>
    cflags @ -exit
    x 2v@ vx 2v@ 2+ putCbox
    ahb dynGrid addCbox
;

: cfilter  you 's cflags @ and ;

0 value xt
:noname  nip  ahb>actor to you  xt execute  ;
: detect  ( ... me=actor xt -- ... ) ( true you=other -- keepgoing? )
  x 2v@ putCbox  xt >r  to xt  ahb literal dynGrid checkCbox  r> to xt ;

:noname  nip  ahb>actor to you  cmask @ cfilter -exit  hit ;
: /dynamic
  !dyns
  0 stage all>
    cmask @ -exit
    ahb literal dynGrid  cflags @ if  checkGrid  else  checkCbox  then
;

: /static  0 stage all>  cmask @ CSOLID# and -exit  /boxes ;

: corral  x 2v@ boxx 2v@ 2+ 4 4 2max 4064 4064 w 2v@ 2- 2min boxx 2v@ 2- x 2v! ;

: /pos   0 stage all>  vx 2v@ or -exit  vx 2v@ x 2v+!  corral  x 2v@ putCbox ;

: physics  /dynamic /static /pos ;

: does-detect  does> @ detect ;
: detector:  create  here 0 ,   does-detect  :noname swap !  ;

cgridding -order
