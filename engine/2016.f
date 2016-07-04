decimal
: "  postpone s" ; immediate
\ -----------------------------------------------------------------------------
: alert  ( addr c -- )  \ show windows OS message box
  zstring 0 swap z" Alert" MB_OK MessageBox drop ;
: --  -1 swap +! ;
\ -----------------------------------------------------------------------------
fixed
: 2v@  ( addr -- x y )  dup @ swap cell+ @ ;
: 2v!  ( x y addr -- )  dup >r cell+ ! r> ! ;
: 2v+! ( x y addr -- )  dup >r cell+ +! r> +! ;
: 2v?  2v@ 2. ;
: x@   @ ;
: y@   cell+ @ ;
: x!   ! ;
: y!   cell+ ! ;
: x+!   +! ;
: y+!   cell+ +! ;
\ -----------------------------------------------------------------------------
decimal
: or!  ( n adr -- )  dup @ rot or swap ! ;
: and!  ( n adr -- ) dup @ rot and swap ! ;
: xor!  ( n adr -- ) dup @ rot xor swap ! ;
: not!  ( n adr -- ) dup @ rot invert and swap ! ;
: toggle  dup @ not swap ! ;
[undefined] third [if] : third  >r over r> swap ; [then]
[undefined] @+ [if] : @+  dup @ swap cell+ swap ; [then]
: u+  rot + swap ;  \ "under plus"
: ?lit  state @ if postpone literal then ; immediate
\ faster but less debuggable version
: xfield  create over , + immediate does> @ ?dup if " ?lit + " evaluate then ;  ( total size -- <name> total+size )
\ : xfield  create over , + does> @ + ;                                         ( total size -- <name> total+size )
: xvar    cell xfield ;                                                         ( total -- <name> total+cell )
: struct  constant ;  \ NTS: later i'm gonna change the semantics.  see Developer Guide
: 2min  rot min >r min r> ;
: 2max  rot max >r max r> ;
: 2+  rot + >r + r> ;
: 2-  rot swap - >r - r> ;
: 2*  rot * >r * r> ;
: 2/  rot swap / >r / r> ;
: 2mod  rot swap mod >r mod r> ;
: 2negate  negate swap negate swap ;
: 2rnd  rnd swap rnd swap ; 
: do postpone ?do ; immediate
: allotment  here swap /allot ;
: copy,      here over allot swap move ;
\ : ?next  @+ dup 0 >= ;
: h?  @ h. ;
: validate  ( id -- id true | false )  dup 0< not dup ?exit nip ;
: reclaim  h ! ;
: include   fixed include ;
: included  fixed included ;
: ]#  ] postpone literal ;
: << lshift ;
: >> rshift ;
fixed
: th  cells + ;
: bit  dup constant  1 << ;
-1 constant none
0 value o
: with  r>  o >r  swap to o  call  r> to o ;

: overlap? ( xyxy xyxy -- flag )
  2swap 2rot rot > -rot <= and >r rot >= -rot < and r> and ;
  \ find if 2 rectangles (x1,y1,x2,y2) and (x3,y3,x4,y4) overlap.
: clamp  ( n low high -- n ) -rot max min ;
: 2clamp  ( x y lowx lowy highx highy -- x y ) 2>r 2max 2r> 2min ;

: jumptable  create does> swap th @ execute ;


\ Swiftforth-specific?
: l locate ;

\ Pen
create penx  0 ,  here 0 ,  constant peny
: at   ( x y -- )  penx 2v! ;
: +at  ( x y -- )  penx 2v+! ;
: at@  ( -- x y )  penx 2v@ ;
: -at  ( x y -- )  2negate +at ;


[undefined] src [if]
0 value src
0 value dest
: src!  to src ;
: dest!  to dest ;
[then]

[undefined] @+ [if] [then]
[undefined] !+ [if] [then]
[undefined] ~!+ [if] [then]

: ifill  ( c-addr count val - )  -rot  0 do  over !+  loop  2drop ;
: ierase   0 ifill ;
: imove  ( from to count - )  cells move ;

\ fixed point extensions
include engine/fixext
