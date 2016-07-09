\ crawl drop-in - reloaded for every class that includes it


\ to use, just call ADVANCE to move forward , turning around corners , or ABOUT , to switch directions

\ there is a current orientation and a current "up"
\ we check in front of, and below the object.
\  if there is an obstacle directly in front of the hitbox, we turn in the direction of "up" and re-ground
\  if there is no ground underneath, we turn in the direction of "down" and re-ground
\ we don't use sensors.  we use the entire hitbox and check it against the box spacial hash.


  var up  \ angle
  var fwd \ angle


: up>  up @ ;
: down>  up @ 180 + 360 mod ;

0 value (speed)

\ this word takes the current "down" and aligns the current actor to the "floor" of the given cbox.
: reground  ( cbox -- )
  down> (speed) vector  x 2v@  2+
;

1
  bit corner#
  bit obstacle#
drop

: advance  ( speed -- result )
  to (speed)

