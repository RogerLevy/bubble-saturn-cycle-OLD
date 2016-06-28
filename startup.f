: cleanup  ( -- )  cleanup  boxGrid resetGrid  dynGrid resetGrid ;

: map  ( tmxpath c area# -- <name> )  ( -- )  \ area# points to an entry in a table
  create  , string,
  does>  @+ to area#  count  cleanup  loadTMX ;


" data\maps\W01_A02_v01.tmx" 0 map sfw0

sfw0

