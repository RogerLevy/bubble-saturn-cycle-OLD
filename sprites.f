fixed

/image safetable spritesets

: spriteset  ( w h string count -- <name> )  ( -- id )
  spritesets entry >r  <zfilespec> al_load_bitmap r@ initImage  r> subdivide ;

: drawSpriteFlip  ( spriteset# subimage# flip -- )
  >r  swap spritesets id> afsubimg  at@ 2af  r>  al_draw_bitmap_region ;

: drawSprite  ( spriteset# subimage# -- )
  0 drawSpriteFlip ;

: #sprites  ( spriteset# -- n )
  spritesets id> numSubimages @ ;

: spriteset-size  ( spriteset# -- w h )
  spritesets id> subw 2v@ ;

