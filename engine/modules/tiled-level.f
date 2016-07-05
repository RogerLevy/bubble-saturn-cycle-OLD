
fixed

staticvar firstgid
defer onLoadBox  ( pen=xy -- )
:noname [ is onLoadBox ] cr ." WARNING: onLoadBox is not defined!" ;

doming +order

staticvar 'onMapLoad
: onMapLoad:  ( class -- <code;> )  :noname swap 'onMapLoad ! ;
: onMapLoad  ( -- )  me class @ 'onMapLoad @ execute ;

: gid>class  ( n -- class )
  locals| n |
  lastClass @
  begin  dup firstgid @ 1 - n u<  over prevClass @ 0 =  or  not while
    prevClass @
  repeat  ; \ cr dup body> >name count type ;

: readTileset  ( -- )
  " firstgid" @attr ( n )  " name" @attr$ script ( class ) firstgid ! ;

\ utility word @PROP: read custom object property
:noname  ( addr c type -- addr c flag )  \ check the name attribute of each property element til we find a match
  dom.element = -exit  2dup " name" @attr compare 0=
;
  \ only consists of elements called "property" so no need to check the names of the elements
  : ?@prop  ( addr c -- false | val true )
    nest
    " properties" ?sib  not if  unnest ( addr c ) 2drop false exit  then
    [ literal ] search   nip nip if  " value" @attr  true  else  false then
    unnest  unnest ;

: *instance  ( -- )
  cr ." ...CREATING INSTANCE "
  " gid" @attr gid>class one
  ." $" me h.
  onMapLoad ;
  
: gidObject  ( -- )
  cr ." GID OBJECT!!!"  .node  *instance ;

: fixY  " height" @attr negate peny +! ;

: readObject
  " x" @attr " y" @attr  at
  " name" attr? if
    " gid" attr? if  fixY  then
    " name" @attr$ cr ." EXECUTING: " 2dup type  evaluate
  else
    " gid" attr? if  " height" @attr negate peny +! gidObject
                 else  cr ." BOX!!!!" .node onLoadBox  then
  then
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
  me >r
  clearGIDs
  file@  2dup read drop free throw
  nest  " map" ?sib not abort" File is not TMX format!"
  fixed  ['] mapKids drill  done
  r> as ;


doming -order

