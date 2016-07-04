actor super class trilobite

: forth  -0.5 vx !    FLIP_H  flip ! dup frames ;
: back  0.5 vx !      0       flip ! dup frames ;

: patrol  40 80 rnd + 3 * perform>  begin back forth again ;

trilobite start:
  10 6 boxx 2v!  24 14 w 2v!  22 11 orgx 2v!
  cnpc# cflags !  csolid# cmask !
  patrol
  show> trilobite.image showImage ;
