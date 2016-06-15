decimal

\ intent: define chunk of code as a string which will be executed when given <name> is executed.
\ usage: #define <name> <code>
: #define  ( - <name> <code> )  \ fake preprocessor code definition
  create 0 parse bl skip string, immediate
  does>
    ( addr ) >r
    base @ ints @ get-order
    r> ( addr )
    fdepth >r
    ( addr ) decimal count evaluate
    state @ 0 = r> fdepth = and if  \ if interpreting and fstack has not changed
      >r set-order ints ! base ! r>
    else
      set-order ints ! base !  \ otherwise, assume the data stack has not changed
    then ;

: field  create over , + does> @ + ;
: var  cell field ;
: fload   include ;
: ?constant  constant ;
: lshift  lshift ;
: rshift  rshift ;

\ intent: speeding up some often-used short routines
\ usage: macro:  <some code> ;  \ entire declaration must be a one-liner!
: macro:  ( - <code> ; )  \ define a macro; the given string will be evaluated when called
  create immediate
  [char] ; parse string,
  does> count evaluate ;


#define ALLEGRO_VERSION          5
#define ALLEGRO_SUB_VERSION      1
#define ALLEGRO_WIP_VERSION      13

[defined] allegro5-debug [if]
  library allegro_monolith-debug-5.1.13.dll
[else]
  library allegro_monolith-5.1.13.dll
[then]

warning off

ALLEGRO_VERSION 24 lshift
ALLEGRO_SUB_VERSION 16 lshift or
ALLEGRO_WIP_VERSION 8 lshift or
\ ALLEGRO_RELEASE_NUMBER or
constant ALLEGRO_VERSION_INT

: void ;

: /* postpone \ ; immediate

\ ----------------------------- load files --------------------------------

include 01_allegro5_general
include 02_allegro5_events
include 03_allegro5_keys
include 04_allegro5_audio
include 05_allegro5_graphics

include tools

\ =============================== END ==================================

cr .( loaded: allegro 5.1.13)
warning on

