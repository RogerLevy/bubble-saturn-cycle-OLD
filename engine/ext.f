
\ These components will be compiled into the EXE.
\ It looks like a lot but really we're just conditionally loading a few files,
\ since this file can be loaded multiple times in a programming session.

\ Forth Language-level Extensions
  [undefined] f+ [if]
    +opt
    requires fpmath
    cr .( loaded: fpmath)
  [then]
  [undefined] rnd [if]
    requires rnd
  [then]
  [undefined] zstring [if]
    include lib\string-operations
  [then]
  [undefined] fixedp [if]
    true constant fixedp
    include lib\fixedp_2
  [then]
  [undefined] ALLEGRO_VERSION_INT [if]
    pushpath cd lib\allegro5.1.13
      include allegro5.1.13.f
    poppath
  [then]

  [undefined] rld [if]
    : rld  ( -- )  s" dev.f" included ;
    \ Dev tool: reload from the top

    : game-starter  " include toc ok" evaluate ;
    \ Turnkey starter
    gild
  [then]
