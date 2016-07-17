doming +order

actor super
  var subtype  \ index into current bg object table (pointed to by tbl)
class bgobj

/image allotment constant bgimg  \ maybe not the best way to do this but ... it works (i mean the whole one-image-for-everything bit)
: img>  bgObjTable subtype @ th @ bgimg initImage bgimg ;
: /subtype  ( -- )  " gid" @attr $fffffff and  me class @ firstgid @  -  subtype ! ;
: ?autobox  " nobox" ?prop if drop exit then  x 2v@ at  w 2v@ *box ;

bgobj start:  show>  img>  ?dup -exit  fitImage ;
bgobj onMapLoad:  /dims  /subtype  /flip  ?autobox ;

doming -order
