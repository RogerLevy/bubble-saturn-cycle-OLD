doming +order

actor super class box

: *box  ( x y w h -- )  box one  w 2v! x 2v!  updateCbox  ahb boxGrid addCbox ;

:noname [ is onLoadBox ]  " width" @attr " height" @attr *box ;

doming -order
