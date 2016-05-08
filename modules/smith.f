\ SMW-style level data building lexicon

\ - levels stored as human-readable source
\ - map data uses memory efficiently
\ - independent of game-specific subsystems and other modules (so it requires some glue)

\ these are data structures involved:
\  map header
\    layer table
\    layer header
\      map object

\  map table
\  bg object table
\  actor object table

\ Features of this component:
\  - Semantics for declaring and reading back map objects (shared by BG and Actors.)
\  - High level directory semantics (maps, layers, pointers, tables)
\  - Semantics for defining BG and Actor object types


[undefined] safetable [if]  include modules\safetable  [then]

package smithdata
\ NTS: this is an opportunity to save memory if ever needed.  i've already
\  created generic rect words.  we could redefine the internal representation
\  of map objects to take up just a few bytes instead of 24.  (useful for an
\  8-bit conversion.)
\  For now, I'm just trying to save effort so I've used the standard /rect struct.
/rect  xvar objnum  xvar attr  struct /mapobj

variable curMap  \ index
cell safetable mapTable
cell safetable bgObjTable         \ table of XT's     ( layer mapobj -- )
cell safetable actorObjTable      \ table of classes  ( attr  class -- )  <- single DEFER


: parseParams  [char] ] parse evaluate ;

: [object  ( -- < x , y , w , h , objnum , attr , ] > )
  parseParams ;

: [layer]  ( n -- ) ;

\ static and dynamic object lists.  the static one must come first.
: [static] ;
: [dynamic] ;

: [endlayer]  $DEADBEEF , ;

: [map] ;

: loadMap  ( n -- )

;
  
end-package


