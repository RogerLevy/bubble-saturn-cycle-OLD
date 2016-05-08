\ i just found out there's a checksum generator in WINAPI...

BASE @  HEX                                                                     \ CRCs are an exercise in bit-banging, so HEX is appropriate.
CREATE revtable  100 CHARS ALLOT                                                \ A lookup table for bit-reversed bytes.
MARKER dispose                                                                  \ Brute force bit reversal of a byte.
: rev8 ( ch--ch)  0 SWAP
                  8 0 DO  DUP 1 AND
                          ROT 2* OR
                          SWAP 2/
                      LOOP
                  DROP ;
: filltable (  )  100 0 DO  I rev8
                            I CHARS revtable + C!
                        LOOP ;
filltable  dispose

: rev8 ( ch--ch)  CHARS revtable + C@ ;
: >< ( n--n)  DUP   FF AND  8 lshift
             SWAP FF00 AND  8 rshift  OR ;
: rev16 ( n--n)  DUP   FF AND  rev8  8 lshift
                SWAP FF00 AND  8 rshift  rev8  OR ;

CREATE crctable  100 CELLS ALLOT
MARKER dispose 
1021 CONSTANT crc-polynomial ( CCITT or: 8005 for CRC-16)
: crc ( n c -- n )  >< XOR
                  8 0 DO  DUP 8000 AND
                          IF  2* FFFF AND  crc-polynomial XOR
                        ELSE  2*
                        THEN
                    LOOP ;
\ n is a CRC. crc computes a new value, to include the byte c one bit at a
\ time. This is a slow method, used only to initialise the lookup table.
\ fairly slow method, used to set up the lookup table.
: filltable  ( ) 100 0 DO  0 I crc  I XOR
                           I CELLS crctable + !
                     LOOP ;
filltable  dispose

: crc ( n c -- n )  >< XOR ><
                  DUP FF AND CELLS  crctable + @
                  XOR ;
\ n is a CRC. crc computes a new value, to include the byte c.


\ scan a folder and record info about all ".f"'s in a table
\ storing CRC's of each file's contents.
\ instead of using the filenames, we'll use their numerical ID's; this will
\ make it sufficiently hard to hack the game.




\ when the checker is enabled (i.e. this file is loaded),
\ and INCLUDE or INCLUDED is invoked,
\ create a CRC of the file. if the CRC doesn't match, abort w/ an error msg.
\ otherwise, INCLUDE the file as normal.

\ to speed this up, I might store the CRC at the end of each file, preceded
\ by "\ " (which must be there as well)

\ all this should be done at deployment time.
