fixed

\ Fast collision manager object.  Does efficient collision checks of massive
\ numbers of AABB (axis-aligned bounding boxes).
\ Very useful for broad-phase collision checks.

\ Notes:
\  - Doesn't support hitboxes bigger than sectw x secth


package cgridding public

0 value cgrid  \ current cgrid

: cgrid-var  create dup , cell+ does> @ cgrid + ;

private
  0
    xvar x1
    xvar y1
    xvar x2
    xvar y2
    xvar s1  \ sector 1
    xvar s2  \  ...
    xvar s3  \  ...
    xvar s4  \  ...
  struct /cbox
public : /cbox /cbox ;

: cbox!  ( x y w h cbox -- )  with  2over 2+  #1 #1 2-  o x2 2v!  o x1 2v! ;
: cbox@  ( cbox -- x y w h ) dup >r x1 2v@ r> x2 2v@  2over 2-  #1 #1 2+ ;
: 4@  ( cbox -- x1 y1 x2 y2 ) dup 2v@ rot cell+ cell+ 2v@ ;

private

  decimal
  8 12 + constant bitshift
  fixed
  256 constant sectw
  256 constant secth
  \ the size of each sector is a constant.
  \  use a smaller size if you're going to have lots of small objects.
  \  use a larger size if you're going to have lots of large objects.

  \ variable topleft
  \ variable topright
  \ variable btmleft
  variable lastsector
  variable lastsector2

  defer collide  ( ... true cbox1 cbox2 -- ... keepgoing? )

public
0
  cgrid-var cols
  cgrid-var rows
  cgrid-var sectors         \ link to array of sectors
  cgrid-var links           \
  cgrid-var i.link          \ points to structure in links:  link to next ( i.link , box , )
struct /cgrid


private

  decimal
  : sector  ( x y -- addr )
    ( y ) bitshift >> cols @ p* swap ( x ) bitshift >> + cells sectors @ + ;
  fixed

  : link  ( box sector -- )
    >r
    i.link @ cell+ !  \ 1. link box
    r@ @ i.link @ !  \ 2. link the i.link to address in sector
    i.link @ r> !   \ 3. store current link in sector
    2 cells i.link +! ;  \ 4. and increment current link

  : box>box?  ( box1 box2 -- box1 box2 flag )
    2dup = if  false  exit  then                                                \ boxes can't collide with themselves!
    2dup >r  4@  r> 4@   overlap? ;

  0 value cnt
  : checkSector  ( cbox1 sector -- flag )
    0 to cnt
    true locals| flag |
    swap >r
    begin @ dup  flag and while
      dup cell+ @  r@  swap  box>box? if
        flag -rot  collide  to flag
      else
        2drop
      then
      1 +to cnt
    repeat
    r> 2drop
    flag
\    info @ if cr cnt . then
    ;

  : ?checkSector  ( cbox1 sector|0 -- flag )  \ check a cbox against a sector
    dup if  checkSector  else  nip  then ;

  : ?corner  ( x y -- 0 | sector )  \ see what sector the given coords are in & cull already checked corners
    sector
    ;
    \ dup lastsector @ = if  drop 0  exit  then
    \ dup lastsector2 @ = if  drop 0  exit  then
    \ lastsector @ lastsector2 !
    \ dup  lastsector ! ;

public
: resetCgrid ( cgrid -- )
  to cgrid
  sectors @ cols 2v@ * ierase
  links @ i.link ! ;

: addCbox  ( cbox cgrid -- )
  to cgrid
  ( box ) with  lastsector off  lastsector2 off 
  o x1 2v@       ?corner ?dup if  dup o s1 !  o swap link  else  o s1 off  then
  o x2 @ o y1 @  ?corner ?dup if  dup o s2 !  o swap link  else  o s2 off  then
  o x1 @ o y2 @  ?corner ?dup if  dup o s4 !  o swap link  else  o s4 off  then
  o x2 2v@       ?corner ?dup if  dup o s3 !  o swap link  else  o s3 off  then
  ( topleft off topright off btmleft off ) ;

\ perform collision checks.  assumes box has already been added to the cgrid.
\   this avoids unnecessary work for the CPU.
: checkCgrid  ( cbox1 xt cgrid -- )  \ xt is the response
  to cgrid  is collide
  with
  o dup s1 @ ?checkSector -exit
  o dup s2 @ ?checkSector -exit
  o dup s3 @ ?checkSector -exit
  o dup s4 @ ?checkSector drop ;

\ this doesn't require the box to be added to the cgrid
: checkCbox  ( cbox1 xt cgrid -- )  \ xt is the response
  to cgrid  is collide
  with  lastsector off lastsector2 off
    o dup x1 2v@       ?corner  ?checkSector -exit
    o dup x2 @ o y1 @  ?corner  ?checkSector -exit
    o dup x1 @ o y2 @  ?corner  ?checkSector -exit
    o dup x2 2v@       ?corner  ?checkSector drop ;

: >#sectdims  sectw 1 - secth 1 - 2+  sectw secth 2/  2pfloor ;

: collisionGrid  ( maxboxes width height -- <name> )
  create  /cgrid allotment  to cgrid
  >#sectdims
  2dup cols 2v!  here sectors !  ( cols rows ) * cells /allot
                 here links !    ( maxboxes )  4 * 2 cells * /allot ;

: cgridSize  ( cgrid -- w h )
  to cgrid  cols 2v@  sectw secth 2* ;

end-package

