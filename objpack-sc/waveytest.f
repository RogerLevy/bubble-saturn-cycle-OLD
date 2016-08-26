
actor super class waveytest

[undefined] draw-bitmap-wavey [if] include engine\modules\fx\wavey [then]

: ?more  x 2v@ player 's x 2v@ proximity  10 /  10 min   10 swap - ;
\ : ?more  1 ;

waveytest start:    show>  testcard.image bmp @   0 0 32 32  x 2v@  #frames 10 * 50  ?more  draw-bitmap-wavey  ;
