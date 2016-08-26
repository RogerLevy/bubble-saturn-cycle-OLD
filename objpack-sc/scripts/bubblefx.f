
\ -----------------------------------------------------------------------------
\ bubble stuff

include objpack-sc/bubble

\ :proc bubbly  player 's x 2v@ at  me  bubble one  -1 vy !  as ;
:task bubbly
  begin  player 's x 2v@ at  me  bubble one   1 2 rnd + expire
    -1 vy !  as  3 frames again ;


variable bgbubbles  bgbubbles on

: *bgbubble
  cam 's x 2v@  0 gfxh 2+  -70 10 2+  gfxw 140 + 0  somewhere at
  me  bubble one  -1 vy !  1 0 0 1 !color  -100 zdepth +!    0 cflags !  0 cmask !
  as ;

:task bubblefx
  begin  20 50 rnd + frames  bgbubbles @ if  *bgbubble  then  again ;
