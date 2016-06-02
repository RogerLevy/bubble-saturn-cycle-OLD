fixed

\ assets
      image testcard.image    data/images/test_up_down_32x32.png
      image area000.image     data/images/Hpz6lWy.png
      image parared.image     data/images/parallax_darkred.png

      image parared.image     data/images/parallax_darkred.png

      image w01_a02_bg001.image  data/images/W01_A02_BG001.png
      image w01_a02_bg002.image  data/images/W01_A02_BG002.png
      image w01_a02_bg003.image  data/images/W01_A02_BG003.png
      image w01_a02_bg004.image  data/images/W01_A02_BG004.png
      image w01_a02_bg005.image  data/images/W01_A02_BG005.png
      image w01_a02_bg006.image  data/images/W01_A02_BG006.png
      image w01_a02_bg007.image  data/images/W01_A02_BG007.png
      image w01_a02_bg008.image  data/images/W01_A02_BG008.png
      image w01_a02_bg009.image  data/images/W01_A02_BG009.png
      image w01_a02_bg010.image  data/images/W01_A02_BG010.png
      image w01_a02_bg011.image  data/images/W01_A02_BG011.png
      image w01_a02_bg012.image  data/images/W01_A02_BG012.png
      image w01_a02_bg013.image  data/images/W01_A02_BG013.png
      image w01_a02_bg014.image  data/images/W01_A02_BG014.png
      image w01_a02_bg015.image  data/images/W01_A02_BG015.png
      image w01_a02_bg016.image  data/images/W01_A02_BG016.png
      image w01_a02_bg017.image  data/images/W01_A02_BG017.png
      image w01_a02_bg018.image  data/images/W01_A02_BG018.png

  64 32 spriteset SPR_EARWIG  data/images/earwig.png
\ 16 16 tileset   TILESET0      data/images/longhouse 16x16 bgtiles.png


\ constants
: extents  0 0 4096 4096 ;
1000 constant #boxes

\ variables
#boxes extents 2nip collisionGrid boxGrid
0 value world#
0 value area#
