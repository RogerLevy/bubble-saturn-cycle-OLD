empty
[undefined] dev [if] true constant dev gild [then]

include toc.f
\ include engine\dev\export.f
\ include engine\dev\gameprompt.f

include engine\dev\doubledip.f

\ some development helpers
: s   sim ;  \ single-step!
: :now  :noname ;  \ execute a nameless definition immediately
: ;;  postpone ; execute ; immediate


\ test dirwalker
\ " data"
\ " data\images" \ DOESN'T WORK!!
\ :noname  drop .filename zcount type cr false ;
\ 0 directorieswalker1


include engine\dev\ide.f


ide

\ ok
