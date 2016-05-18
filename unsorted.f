\ generate random boxes
\ : /boxes  ( -- )
\   boxGrid resetCgrid
\   #boxes 0 do  box one  ahb boxGrid addCbox  loop ;
\
\ /boxes

: *box  ( x y w h -- )  box one  w 2v! x 2v!  updateCbox  ahb boxGrid addCbox ;
