\ -----------------------------------------------------------------------------
\ load our data

include objpack-sc/data

\ -----------------------------------------------------------------------------
\ player stuff

player as  " traveler" script become
  100 100 player put

\ -----------------------------------------------------------------------------
\ map tokens
\ tokens all have stack diagram ( -- )

: player-drop  at@ dropPoint 2v! ;
: eagle-dialog   @dims talky zone>  trigger>  dialog>  *moan*  ;

\ -----------------------------------------------------------------------------
include objpack-sc/scripts/bubblefx
