actor super  var zonetype  var 'trigger  var 'zonestart  class zone

: zone>  ( w h zonetype -- <code> )
  zone one  zonetype !  w 2v!  r> code> dup 'zonestart !  execute ;

: resetZone  ( zone -- )  me >r  as  'zonestart @ execute  r> as ;
: trigger    ( zone -- )  me >r  as  'trigger @ execute  r> as ;
: trigger>  r> code> 'trigger ! ;

zone start:  CZONE# cflags ! ;



\ dialog zone:

\  player is in a zone -> action button -> current zone -> trigger -> dialog & reassign trigger
\  there's different kinds of dialogs.
\    we need to be able to create a dialog that closes itself if the player moves out of the zone.
\

