actor super class trilobite

: patrol  40 80 rnd + 3 * perform>
  begin 0.5 vx ! FLIP_H flip ! dup frames
        -0.5 vx !     0 flip ! dup frames again ;

trilobite start:
  10 6 boxx 2v!  24 14 w 2v!  22 11 orgx 2v!
  cnpc# cflags !  csolid# cmask !
  patrol
  show> trilobite.image showImage ;
