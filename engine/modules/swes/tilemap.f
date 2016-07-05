fixed

package tilemaping
public
0 value tileSrc  \ image
: >tileSrc  ( id -- ) >tileset to tileSrc ;
: tilew  tilesrc subw @ ;
: tileh  tilesrc subh @ ;
private
  : tile  tilesrc afsubimg  at@ 2af  0  al_draw_bitmap_region  tilew 0 +at ;
  : @?tile  @ dup if  1 - tile  exit  then  drop  tilew 0 +at ;
  : row  ( addr #cells -- )  at@  2swap ['] @?tile batch  tileh + at  ;
  : limit  64 64 2min ;
public
: drawTiles  ( col row #cols #rows array2d -- )  >r limit r> ['] row some2d ;
: px>tile ( x y -- col row )  tilew tileh 2/ 2pfloor ;
\ get relative col/row within tilemap using tilesrc
: scrolled  ( scrollx scrolly -- )  2dup tilew tileh 2mod 2negate at  px>tile ;
end-package
