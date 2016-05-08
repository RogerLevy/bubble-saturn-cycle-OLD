true constant fpext

\ {nodoc}
\ RM: I don't want to deal with this right now.
\ It's not likely that I will use any of these words for a while
\ We can document these later as necessary.
\ ==============================================================================
\ ForestLib
\ Floating point extensions mainly for dealing with external libraries
\ ========================= copyright 2014 Roger Levy ==========================

\ Words for passing floats and doubles to DLL's

\ intent: {INTENT}
\ usage: {USAGE}
iCODE 4sfparms  ( f: x y z t - ) ( s: - x y z t )  \ {BRIEF}
  4 >fs \ make sure data on hardware stack
  16 # EBP SUB \ room for 4 integers and tos
  12 [EBP] DWORD FSTP             \ convert t
   0 [EBP] DWORD FSTP             \ convert z
   4 [EBP] DWORD FSTP             \ convert y
   8 [EBP] DWORD FSTP             \ convert x
  12 [EBP] EBX XCHG               \ swap t and old tos
  RET END-CODE

\ intent: {INTENT}
\ usage: {USAGE}
iCODE 1dfparms  ( f: x - ) ( s: - xl xh )  \ {BRIEF}
  >f                      \ make sure data on hardware stack
  8 # EBP SUB \ make room for double
  0 [EBP] QWORD FSTP \ convert
  4 [EBP] EBX XCHG \ swap xh and old tos
  RET END-CODE

\ intent: {INTENT}
\ usage: {USAGE}
iCODE 3sfparms  ( f: x y z - ) ( s: - x y z )  \ {BRIEF}
  3 >fs                     \ make sure data on hardware stack
  12 # EBP SUB                \ room for 3 integers and tos
   8 [EBP] DWORD FSTP             \ convert z
   0 [EBP] DWORD FSTP             \ convert y
   4 [EBP] DWORD FSTP             \ convert x
   8 [EBP] EBX XCHG               \ swap z and old tos
  RET END-CODE

\ intent: {INTENT}
\ usage: {USAGE}
iCODE 2sfparms  ( f: x y z - ) ( s: - x y z )  \ {BRIEF}
  2 >fs                     \ make sure data on hardware stack
  8 # EBP SUB                \ room for 2 integers and tos
   4 [EBP] DWORD FSTP             \ convert y
   0 [EBP] DWORD FSTP             \ convert x
   4 [EBP] EBX XCHG               \ swap z and old tos
  RET END-CODE

\ intent: {INTENT}
\ usage: {USAGE}
iCODE 1sfparm  ( f: x - ) ( s: - x )  \ {BRIEF}
  1 >fs                     \ make sure data on hardware stack
   4 # EBP SUB                \ room for 1 integers and tos
   0 [EBP] DWORD FSTP             \ convert x
   0 [EBP] EBX XCHG               \ swap x and old tos
  RET END-CODE

\ intent: {INTENT}
\ usage: {USAGE}
iCODE FTHIRD  ( f: x y z - x y z x )  \ {BRIEF}
   3 >fs   ST(2) FLD   4 fs>   FNEXT

aka 1sfparm 1sf
aka 2sfparms 2sf
aka 3sfparms 3sf
aka 4sfparms 4sf
aka 1dfparms 1df

\ NOTE: these are not conversion routines, these are TRANSFER routines.  the numbers
\ returned on the data static are unusable except by DLL's.

\ intent: {INTENT}
\ usage: {USAGE}
macro: 2df  1df 2>r 1df 2r> ;  ( f: x y - ) ( s: float float )  \ {BRIEF}

\ intent: {INTENT}
\ usage: {USAGE}
: 3df  ( f: x y z - ) ( s: float float float )  \ {BRIEF}
  1df 2>r 1df 2>r 1df 2r> 2r> ;

\ intent: {INTENT}
\ usage: {USAGE}
: 4df  ( f: x y z a - ) ( s: float float float float )  \ {BRIEF}
  1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> ;

\ intent: {INTENT}
\ usage: {USAGE}
: 5df  ( f: x y z a b - ) ( s: float float float float float )  \ {BRIEF}
  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> 2r> ;

\ intent: {INTENT}
\ usage: {USAGE}
: 6df  ( f: x y z a b c - ) ( s: float float float float float float )  \ {BRIEF}
  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> 2r> 2r> ;

\ intent: {INTENT}
\ usage: {USAGE}
: 9df  ( f: x y z a b c d e f - ) ( s: float float float float float float float float float )  \ {BRIEF}
  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df
  2r> 2r> 2r> 2r> 2r> 2r> 2r> 2r> ;

\ intent: {INTENT}
\ usage: {USAGE}
: 0e  ( - f: n )  \ {BRIEF}
  STATE @ IF POSTPONE #0.0e ELSE #0.0e THEN ; immediate

\ intent: {INTENT}
\ usage: {USAGE}
: 1e  ( - f: n )  \ {BRIEF}
  STATE @ IF POSTPONE #1.0e ELSE #1.0e THEN ; immediate

\ intent: {INTENT}
\ usage: {USAGE}
macro: 2s>f  swap s>f s>f ;  ( x y - f: x y )  \ {BRIEF}

\ intent: {INTENT}
\ usage: {USAGE}
macro: 3s>f  rot s>f swap s>f s>f ;  ( x y z - f: x y z )  \ {BRIEF}

\ intent: {INTENT}
\ usage: {USAGE}
macro: c>f   s>f 255e f/ ;  ( c - f: n )  \ {BRIEF}

\ intent: {INTENT}
\ usage: {USAGE}
: fValue  ( "name" - )  \ {BRIEF}
  Create f,   immediate does> state @ if s" literal f@ " evaluate exit then
  f@  ;

\ intent: {INTENT}
\ usage: {USAGE}
: fto   ( f: v - )  \ {BRIEF}
  ' >body  state @
  if   postpone literal
     postpone f!
  else f!
  then ; immediate
