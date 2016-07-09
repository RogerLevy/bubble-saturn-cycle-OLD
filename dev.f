empty
[undefined] dev [if] true constant dev gild [then]

include toc.f
\ include dev\export.f
include dev\doubledip.f

\ some development helpers
: s   sim ;  \ single-step!
: :now  :noname ;  \ execute a nameless definition immediately
: ;;  postpone ; execute ; immediate

\ include dev\ide.f
\ ide
ok
