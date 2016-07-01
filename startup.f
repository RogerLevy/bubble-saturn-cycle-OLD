: cleanup  ( -- )  cleanup  boxGrid resetGrid  dynGrid resetGrid ;

\ this is wrong.  i put the bg gfx selection in the tmx file where it should be. 6/29/2016
\ : map  ( tmxpath c area# -- <name> )  ( -- )  \ area# points to an entry in a table
\   create  , string,
\   does>  @+ to area#  count  cleanup  loadTMX ;
\
\
\ " data\maps\W01_A02_v01.tmx" 0 map sfw0

: findmap  " data/maps/" s[  bl parse +s  " .tmx" +s  ]s ;

: load  ( -- <name> ) \ load a map.  no .tmx required
    cleanup  findmap loadtmx ;


load solflood-west

