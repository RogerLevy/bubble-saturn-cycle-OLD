include lib\files
fixed

dom-create dom

0 value xt
: dom-drill  ( xt dom -- )  ( ... dom-type -- ... )
  dup dom-children 0= if  2drop exit  then
  xt >r  swap to xt
  dup dom-child
    begin  while
      ( dom type ) swap >r  xt execute  r>
\      cr dom dom-get-name type
      dup dom-next
    repeat
  dom-parent 2drop
  r> to xt
;

package doming

private

  : read  true dom dom-read-string 0= throw  dom dom-document drop ;
  : @name  dom dom-get-name ; 
  : nest  dom dom-child 2drop ;
  : ?next  dom dom-next ;
  : drill  dom dom-drill ;
  : @n    dom dom-get-value evaluate ;
  : @str  dom dom-get-value ;
  : unnest  dom dom-parent 2drop ;
  : done  dom dom-(free) ;
  : name?  @name compare 0= ;
  : sib?  ( addr c -- flag )  \ if true, current node is the found one.
    locals| c adr |
    dom dom-first  begin while  drop  adr c  name?  ?dup ?exit  ?next repeat
    false  ;
  : attr?  nest sib? unnest ;
  : @attrstr  ( addr c -- str count )  \ if not found, throw an error.
    nest  sib? not if  unnest  xis.error throw  then  @str  unnest ;
  : @attr  ( addr c -- n )  \ if not found, throw an error.
    @attrstr evaluate ;
  : .name  cr @name type ;
public

staticvar firstgid

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

cleanup
boxGrid resetCgrid
tiled test.level data\maps\test3.tmx

end-package
