fixed

/image safetable spritesets

: spriteset  ( w h string count -- <name> )  ( -- id )
  spritesets entry >r  <zfilespec> al_load_bitmap r@ initImage  r> subdivide ;

: sprite>af  ( subimage# spriteset# -- afsx afsy afsw afsh )  spritesets id> afsubimg ;

variable flipFlags  \ the idea is that this will help in writing your own blit functions

\ Quick and easy standard functions. anything more complicated than this isn't helpful.
: drawSpriteFlip  ( subimage# spriteset# flip -- )
  flipFlags !  sprite>af  at@ 2af  flipFlags @  al_draw_bitmap_region ;

: drawSprite  ( subimage# spriteset# -- )  0 drawSpriteFlip ;


: #sprites  ( spriteset# -- n )
  spritesets id> numSubimages @ ;

: spriteSize  ( spriteset# -- w h )
  spritesets id> subw 2v@ ;

