fixed
/RND

\ standard game services (core game lexicon)
include engine\saturn\gameorama

\ graphics services
include engine\modules\swes\sprites
\ include engine\modules\swes\tilesets
\ include engine\modules\swes\tilemap
\ include engine\modules\swes\tilemap-collision
\ include engine\modules\swes\layers

\ load other services
include engine\modules\stride2d
include engine\modules\collision-grid
include engine\modules\gameutils
include engine\modules\wallpaper
include engine\modules\tiled-level

\ engine specific stuff
include engine\saturn\scripting.f

\ constants
: extents  0 0 4096 4096 ;
actor single cam
actor single player

\ variables
0 value you  \ for collisions
#1 value cbit  \ collision flag counter
variable 'dialog  \ for now this is just a flag.

\ game-specific data
include data

\ more engine specific stuff
include engine\saturn\objects.f
include engine\saturn\physics.f
include engine\saturn\box.f

fixed


:noname [ is oneInit ]
  at@  startx 2v!
  1 1 1 1 !color
  csolid# cmask !
  ;


player as  " traveler" script become


include obj\bubble

\ :proc bubbly  player 's x 2v@ at  me  bubble one  -1 vy !  as ;
:task bubbly
  begin  player 's x 2v@ at  me  bubble one   1 2 rnd + expire
    -1 vy !  as  3 frames again ;


variable bgbubbles  bgbubbles on

: *bgbubble
  cam 's x 2v@  0 gfxh 2+  -70 10 2+  gfxw 140 + 0  somewhere at
  me  bubble one  -1 vy !  1 0 0 1 !color
  as ;

:task bubblefx
  begin  20 50 rnd + frames  bgbubbles @ if  *bgbubble  then  again ;

: ?pointcull
  x 2v@ 2dup  cam 's x 2v@ 80 80 2-  gfxw gfxh 160 160 2+  2over 2+
  overlap? ?exit  me unload ;

' ?pointcull bubble 'cull !

: cull  0 stage all>  me class @ 'cull @ execute ;


include engine\saturn\zones.f


\ camera/rendering
transform baseline

: /baseline  ( -- )
  baseline  al_identity_transform
  baseline  factor @ dup 2af  al_scale_transform
  baseline  al_use_transform  ;

: drawTalkIcon  ( -- )  talk-icon.image bmp @  player 's x 2v@ 22 - 2af  0  al_draw_bitmap ;
: ?talkicon  'dialog @ ?exit  drawTalkIcon ;
jumptable emoticon  ' noop , ' ?talkicon ,

: drawEmoticons  ?zone 's zonetype @ emoticon ;

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
: batch  al_hold_bitmap_drawing ;
: cls  0 0 0 1 clear-to-color ;
: overlays  drawEmoticons  ;
: all  0 stage all>  show ;
: boxes  info @ -exit  0 stage all>  showCbox ;
: camRender
  cls  /baseline  para  track  camview  1 batch  all  overlays  0 batch  boxes ;

: logic  0 stage all> act ;

\ piston config
' camRender is render
:noname  [ is sim ]  physics  zones  logic  multi  cull  1 +to #frames ;
