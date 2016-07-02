actor super var frm class bubble

: expire  perform> secs me unload end ;

bubble start:
    3 rnd frm !
    1 2 rnd + expire
    act>  -0.5 -0.5 1.0 1.0 somewhere x 2v+!
    show> frm @ SPR_BUBBLE showSprite ;
