empty
[undefined] dev [if] true constant dev gild [then]

include toc
include dev\gameprompt
include dev\export

\ some development helpers
: s   sim ;  \ single-step!

: :now  :noname ;  \ execute a nameless definition immediately
: ;;  postpone ; execute ; immediate

gamedev
