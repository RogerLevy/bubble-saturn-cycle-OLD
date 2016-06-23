doming +order

create w01a02bgObj
  w01_a02_bg001.image ,
  w01_a02_bg002.image ,
  w01_a02_bg003.image ,
  w01_a02_bg004.image ,
  w01_a02_bg005.image ,
  w01_a02_bg006.image ,
  w01_a02_bg007.image ,
  w01_a02_bg008.image ,
  w01_a02_bg009.image ,
  w01_a02_bg010.image ,
  w01_a02_bg011.image ,
  w01_a02_bg012.image ,
  w01_a02_bg013.image ,
  w01_a02_bg014.image ,
  w01_a02_bg015.image ,
  w01_a02_bg016.image ,
  w01_a02_bg017.image ,
  w01_a02_bg018.image ,
  w01_a02_bg000.image ,


create bgObjTables
  w01a02bgObj , w01a02bgObj ,

actor super
  var subtype  \ index into current bg object table (pointed to by tbl)
  var tbl  \ index into bgObjTables
class bgobj

: img>  bgObjTables tbl @ th @  subtype @ th @ ;

bgobj start:  show>  img>  fitImage ;

: /subtype  ( -- )  " gid" @attr $fffffff and  me class @ firstgid @  -  subtype ! ;

bgobj onMapLoad:  /dims  /subtype  /flip ;

doming -order
