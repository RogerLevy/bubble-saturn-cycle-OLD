actor super class taskly

: doop   vx 2v!   dup frames ;

: diddle   20 perform>  begin 1 0 doop 0 1 doop -1 0 doop 0 -1 doop again ;

taskly start:    diddle  show>  testcard.image showimage ;
