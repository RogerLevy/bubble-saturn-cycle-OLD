" zone" script drop

\ tokens all have stack diagram ( -- )
: player-drop  at@ player put ;
: eagle-dialog   @dims talky zone>  trigger>  dialog> cr ." IT WORKS" ;
