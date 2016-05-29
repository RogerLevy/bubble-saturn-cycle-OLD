include lib\files
fixed

staticvar firstgid

doming +order

: gid>class  ( n -- class )
  lastClass @ begin ?dup while over over firstgid @ = if nip exit then
  prevClass @ repeat  -1 abort" Tile object references invalid GID." ;

: readTileset  " firstgid" @attr ( n )  " name" @attr ( class ) firstgid ! ;

: ?actor  ( x y -- )
  " type" attr? if  " type" @attr put  else  at  " gid" @attr gid>class dup . one  then ;

: readObject
  " x" @attr " y" @attr
  " gid" attr? if   ?actor
               else  " width" @attr " height" @attr *box  ( TODO: slippery etc ) then ;
  \ read object.
  \  collision rectangles have no gid.  some have a type, to make it slippery or dangerous.
  \  actors have a gid.

: objectGroupKids  ( type -- )
  case
    dom.attribute of
      \ read group attributes.  just the name.  identifies the layer.  can skip, for now.
    endof
    dom.element of
      " object" name? if  readObject  then
    endof
  endcase
;

: mapKids ( type -- )
  dom.element = if
    \ could instead look up name (plus salt) in dictionary,
    \ and pass that XT to dom-drill.
    " tileset" name? if  readTileset  then
    " objectgroup" name? if  ['] objectGroupKids drill  then
  then
;

: tiled  ( -- <name> <path> )
  create  fixed  <filespec> file@  2dup read drop free throw
  nest " map" sib? drop  ['] mapKids drill  done ;

doming -order

cleanup
boxGrid resetCgrid
tiled test.level data\maps\test3.tmx

