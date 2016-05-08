fixed

\ assets
\ pushpath cd
      image testcard.image    data/images/test_up_down_32x32.png
      image area000.image     data/images/Hpz6lWy.png
\ 16 16 tileset   TILESET0      data/images/longhouse 16x16 bgtiles.png
\ 16 16 spriteset SPRSET0       data/images/longhouse 16x16 sprites.png
\ 8 8   spriteset SPRSET1       data/images/longhouse 8x8 sprites.png
\ 16 24 spriteset SPRSET_GUY    data/images/guy.png
\ poppath


\ constants
: extents  0 0 5120 5120 ;
1000 constant #boxes

\ variables
#boxes extents 2nip collisionGrid boxGrid
