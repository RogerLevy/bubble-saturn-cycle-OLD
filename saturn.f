fixed

\ single objects
" actor" script single cam
" traveler" script single player
" zone" script drop

\ dialog stuff

variable 'dialog  \ for now this is just a flag.

: dialog>  'dialog on  ; \ r> code> 'dialog ! ;


\ zone stuff

: drawTalkIcon  ( -- )  talk-icon.image bmp @  player 's x 2v@ 22 - 2af  0  al_draw_bitmap ;

create dummy  /actorslot /allot
:noname  ( zone you=other -- zone )
  you class @ zone <> ?exit
  >r  dup 's zonetype @  you 's zonetype @ hex <= if  drop  you  then  r> ;
: currentZone  ( me=actor -- zone | 0 )
  dummy  literal check  dup dummy = if  drop 0  then ;

: untrigger  ( zone -- )
  ?dup -exit
  dup resetZone
  's zonetype @ case
    talky of  'dialog off  endof
  endcase ;

0 value lastZone
: zones
  player 's currentZone dup not if
    lastZone untrigger
  else
    dup 's zonetype @ case
      talky of  <a> kpressed if  player 's currentZone trigger  then  endof
    endcase
  then
  ( zone ) to lastZone ;

: drawEmoticons
  player 's currentZone ?dup -exit  's zonetype @ case
    talky of  'dialog @ NOT if  drawTalkIcon  then  endof
  endcase ;


\ baseline matrix
transform baseline

: /baseline  ( -- )
  baseline  al_identity_transform
  baseline  factor @ dup 2af  al_scale_transform
  baseline  al_use_transform  ;


\ camera
create m  16 cells /allot

: camTransform  ( -- matrix )
  m al_identity_transform
  m  cam 's x 2v@ 2pfloor 2negate 2af  al_translate_transform
  m ;

: track ( -- )
  player 's x 2v@  player 's w 2v@ 2halve  2+
  gfxw gfxh 2halve  2-  extents 2clamp  cam 's x 2v! ;

: camview
  camTransform  dup  factor @ dup 2af  al_scale_transform
  al_use_transform ;

: para  parared.image  cam 's x 2v@ 0.4 0.4 2*  drawWallpaper ;

: cls  ( -- )  0 0 0 1 clear-to-color ;
: ui ( -- )  drawEmoticons  ;
: all  ( -- ) 0 all>  show ;
: boxes ( -- )  info @ -exit  0 all>  showCbox ;
: camRender  ( -- )  cls  /baseline  para  track  camview  all ui boxes ;

: logic  ( -- )  0 all> act ;

\ piston config
' camRender is render
:noname  [ is sim ]  physics  zones  logic  1 +to #frames ;
