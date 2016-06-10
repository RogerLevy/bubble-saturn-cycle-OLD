doming +order

actor super class box

: *box  ( w h -- )  box one  w 2v!  updateCbox  ahb boxGrid addCbox ;

: ?box  over 0= over 0= or not if  .s  *box  else  2drop  then ;

cgridding +order
:noname [ is onLoadBox ]  ( pen=xy -- )
  ['] ?box  " width" @attr " height" @attr at@ 2+  sectw secth  .s stride2d ;
cgridding -order
doming -order
