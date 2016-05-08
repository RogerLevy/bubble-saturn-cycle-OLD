



\ slow version ... not converted yet!

\ : do-x
\   vx @ -exit
\     vx 2v@  vx @ u+  hitbox xy 2+  xy-ahb
\     [[ .ahb >r ahb 4@ r@ 4@ overlap? if  r> ?lr  else  r> drop  then ]] boxes those
\ ;
\ : do-y
\   vy @ -exit
\     pos xy  vel y +   hitbox xy 2+  xy-ahb
\     [[ .ahb >r ahb 4@ r@ 4@ overlap? if  r> ?tb  else  r> drop  then ]] boxes those
\ ;
\ %actor ~> %active
\
\   0 0 16 16 hitbox box!
\
\   :: physics
\     [ top# drop bottom# drop left# drop right# drop or or or ]# flags unset
\     do-x
\     do-y
\     vel xy pos +xy
\     pos xy hitbox xy 2+  xy-ahb
\   ;
\
\ endp
