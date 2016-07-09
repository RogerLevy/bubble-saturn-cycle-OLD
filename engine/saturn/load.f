: cleanup  ( -- )  cleanup  boxGrid resetGrid  dynGrid resetGrid ;

: findmap  " data/maps/" s[  bl parse +s  " .tmx" +s  ]s ;

: load  ( -- <name> ) \ load a map.  no .tmx required
    cleanup  findmap loadtmx ;

