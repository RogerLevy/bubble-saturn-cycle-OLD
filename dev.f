empty
[undefined] dev [if] true constant dev gild [then]

include toc
include dev\gameprompt
include dev\export

\ some development helpers
: s   sim ;  \ single-step!
: :now  :noname ;  \ execute a nameless definition immediately
: ;;  postpone ; execute ; immediate

: l locate ; 
gamedev
\ newGame



\ include ogmo-level.f

cleanup
boxGrid resetCgrid
\ " data\maps\test3.tmx" loadTMX
" data\maps\W01_A02_v01.tmx" loadTMX




ok
