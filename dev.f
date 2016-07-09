empty
[undefined] dev [if] true constant dev gild [then]

include toc
include dev\export
include dev\ide.f
include dev\doubledip

\ some development helpers
: s   sim ;  \ single-step!
: :now  :noname ;  \ execute a nameless definition immediately
: ;;  postpone ; execute ; immediate

ide

