\ NOTE: these are not conversion routines, these are TRANSFER routines.  the numbers
\ returned on the data static are unusable except by DLL's.

: 2df  1df 2>r 1df 2r> ;  ( f: x y - ) ( s: float float )

: 3df  ( f: x y z - ) ( s: float float float )
  1df 2>r 1df 2>r 1df 2r> 2r> ;

: 4df  ( f: x y z a - ) ( s: float float float float )
  1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> ;

: 5df  ( f: x y z a b - ) ( s: float float float float float )  
  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> 2r> ;

: 6df  ( f: x y z a b c - ) ( s: float float float float float float )
  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> 2r> 2r> ;

: 9df  ( f: x y z a b c d e f - ) ( s: float float float float float float float float float )
  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df
  2r> 2r> 2r> 2r> 2r> 2r> 2r> 2r> ;
