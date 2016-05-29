decimal

\ intent: create file and write string to the file
\ usage: <string> <filename>
: file!  ( addr count filename c -- )  \ file store
  w/o create-file throw >r
  r@ write-file throw
  r> close-file throw ;

\ intent: fetch file contents into destination buffer
\ usage: <filename> <destination> @file
: @file  ( filename c dest -- size )  \ fetch file
  -rot r/o open-file throw >r
  r@ file-size drop throw r@ read-file throw
  r> close-file throw ;


\ system heap version

\ intent: fetch file contents into memory
\ usage: <filename> file@
: file@  ( filename c -- allocated-mem size )  \ file fetch
  r/o open-file throw >r
  r@ file-size throw d>s dup dup allocate throw dup rot
  r@ read-file throw drop
  r> close-file throw
  swap ;

: file/  ( mem size -- )  drop free throw ;

\ dictionary version

\ intent: fetch file contents into dictionary
\ usage: <filename> file>
: file>  ( filename c -- addr size )  \ file from
  file@  2dup here dup >r  swap  dup /allot  move  swap free throw  r> swap ;

\ intent: comma a file into the dictionary (same as file> except drops off returned values)
\ usage: <filename> file,
: file,  ( filename c -- )  \ file comma
  file> 2drop ;
