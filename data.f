fixed

\ assets
      image testcard.image    data/images/test_up_down_32x32.png
      image area000.image     data/images/Hpz6lWy.png
  64 32 spriteset SPR_EARWIG  data/images/earwig.png
\ 16 16 tileset   TILESET0      data/images/longhouse 16x16 bgtiles.png


\ constants
: extents  0 0 5120 5120 ;
1000 constant #boxes

\ variables
#boxes extents 2nip collisionGrid boxGrid
