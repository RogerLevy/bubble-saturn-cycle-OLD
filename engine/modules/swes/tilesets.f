[undefined] safetable [if] include engine/modules/safetables [then]

fixed

\ NTS: later add attributes like collision

/image safetable tilesets

: tileset  ( tilew tileh -- <name> <filespec> )  ( -- id )
  tilesets entry >r <zfilespec> al_load_bitmap r@ initImage r> subdivide ;
  
: >tileset  tilesets id> ;
