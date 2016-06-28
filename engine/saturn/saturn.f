fixed

\ single objects
" actor" script single cam
" traveler" script single player

\ dialog stuff

variable 'dialog  \ for now this is just a flag.

: dialog>  'dialog on  ; \ r> code> 'dialog ! ;


\ zone stuff

: drawTalkIcon  ( -- )  talk-icon.image bmp @  player 's x 2v@ 22 - 2af  0  al_draw_bitmap ;

: which  over 's zonetype @  over 's zonetype @ <= if  nip  else  drop then ;

:noname  ( zone you=other flag -- zone flag )
  you zone is? -exit  >r  ( zone ) you  which  r> ;
: currentZone  ( me=actor -- zone | 0 )
  dummy  literal detect  dup dummy = if  drop 0  then ;

: ?zone  ( -- zone | [earlyout] )  player 's currentZone ?dup ?exit r> drop ;

: talk/  'dialog off ;
jumptable zone/  ' noop , ' talk/ ,
: ?talk  <a> kpressed -exit  player 's currentZone trigger ;
jumptable ?trigger  ' noop , ' ?talk ,
: ?talkicon  'dialog @ ?exit  drawTalkIcon ;
jumptable emoticon  ' noop , ' ?talkicon ,

: untrigger  ( zone -- )  ?dup -exit  dup resetZone  's zonetype @ zone/ ;

0 value lastZone
: zones
  player 's currentZone dup not if
    lastZone untrigger
  else
    dup lastZone <> if  lastZone untrigger  then
    dup 's zonetype @ ?trigger
  then
  ( zone ) to lastZone ;

: drawEmoticons  ?zone 's zonetype @ emoticon ;


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
: overlays ( -- )  drawEmoticons  ;
: all  ( -- ) 0 all>  show ;
: boxes ( -- )  info @ -exit  0 all>  showCbox ;
: camRender  ( -- )  cls  /baseline  para  track  camview  all  overlays boxes ;

: logic  ( -- )  0 all> act ;

\ piston config
' camRender is render
:noname  [ is sim ]  physics  zones  logic  1 +to #frames ;
