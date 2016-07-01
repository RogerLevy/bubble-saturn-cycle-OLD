\ Actor tasking system.  SwiftForth implementation.

actor super
  var sp
  var rp
  8 cells field ds
  8 cells field rs
extend actor


: perform> ( n -- <code> )
    ds 7 cells + !
    ds 6 cells + sp !
    r> rs 7 cells + !
    rs 7 cells + rp !
;

: perform  ( xt n actor -- )
    me >r as
    ds 7 cells + !
    ds 6 cells + sp !
    >code rs 7 cells + !
    rs 7 cells + rp !
    r> as 
;


actor obj constant main


: yield
    \ save state
    dup \ ensure TOS is on stack
    sp@ sp !
    rp@ rp !
    \ look for next task/actor.  rp=0 means no task.  end of list = jump to main task and resume that
    begin  me next @ as  me if  rp @  else  main as  true  then  until
    \ restore state
    rp @ rp!
    sp @ sp!
    drop \ ensure TOS is in TOS register
;


: end  0 rp! yield ;

: frames  0 do yield loop ;

: secs  60 * frames ;

: multi
    me >r
    dup
    stage first @ main next !
    sp@ main 's sp !
    rp@ main 's rp !
    main as
    ['] yield catch throw
    drop
    r> as
;
