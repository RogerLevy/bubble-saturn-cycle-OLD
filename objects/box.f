doming +order

actor super class box

: either0  over 0= over 0= or ;

: /cbox  updateCbox  ahb boxGrid addCbox ;
: *box  ( w h -- )  box one  w 2v!  /cbox ;
: ?box  ( w h -- ) either0 not if  *box  else  2drop  then ;

\ box super class colorbox
\
\ 0 value (hex)
\
\ : *colorbox  ( w h hexcolor -- )  colorbox one  !hex  w 2v! ;
\
\ : ?colorbox  ( w h -- ) either0 not if  *colorbox  else  2drop  then ;
\
\ : ?boxmaker  ( -- xt )
\   " color" ?@prop if  to (hex)  ['] ?colorbox  else  ['] ?box  then ;


cgridding +order
:noname [ is onLoadBox ]  ( pen=xy -- )
  ['] ?box  " width" @attr " height" @attr at@ 2+  sectw secth  stride2d ;
cgridding -order
doming -order
