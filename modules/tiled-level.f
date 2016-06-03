include lib\files
fixed

staticvar firstgid
defer onLoadBox  ' noop is onLoadBox


doming +order

[undefined] flip [if]  actor super  var flip  extend actor  [then]

[undefined] onMapLoad [if]
  staticvar 'onMapLoad
  : onMapLoad:  ( class -- <code;> )  :noname swap 'onMapLoad ! ;
  decimal
    create lookupTbl  0 , 2 , 1 , 3 ,
    : tmx>aflip  cells lookupTbl + @ ;
  fixed
  : onMapLoad  ( -- )
    decimal " gid" @attr 30 >> tmx>aflip flip ! fixed
    me class @ 'onMapLoad @ execute ;
[then]

: gid>class  ( n -- class )
  locals| n |
  lastClass @
  begin  dup firstgid @ 1 - n u<  over prevClass @ 0 =  or  not while
    prevClass @
  repeat  cr dup body> >name count type ;

: readTileset  " firstgid" @attr ( n )  " name" @attr ( class ) firstgid ! ;



:noname  ( addr c type -- addr c flag )  \ check the name attribute of each property element til we find a match
  \ only consists of elements called "property" so no need to check the names of the elements
  dom.element = -exit  2dup " name" @attr compare 0= ;
  : ?@prop  ( addr c -- false | val true )
    nest
    " properties" ?sib  not if  unnest ( addr c ) 2drop false exit  then
    [ literal ] search   nip nip if  " value" @attr  true  else  false then
    unnest  unnest ;

: (instance)  ( x y -- )
  cr ." ...CREATING INSTANCE"
  at  " gid" @attr gid>class one  ;

: gidObject  ( x y -- )
  cr ." GID OBJECT!!!"
  .node
  " existing" ?@prop if  me!  ( x y ) x 2v!  cr ." ...EXISTING REPOSITIONED"
                     else  (instance)  then
  onMapLoad   
;

: readObject
  " x" @attr " y" @attr
  " gid" attr? if  " height" @attr -  gidObject
               else  onLoadBox  then
;
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
    " tileset" name? if  readTileset  then
    " objectgroup" name? if  ['] objectGroupKids drill  then
  then
;

: clearGIDs  ( -- )
  firstClass @  begin  ?dup while  #-1 over firstGID ! nextClass @  repeat ;

: loadTMX  ( path count -- )
  clearGIDs
  file@  2dup read drop free throw
  nest  " map" ?sib not abort" File is not TMX format!"
  fixed  ['] mapKids drill  done ;


doming -order

