
\ These components will be compiled into the EXE.
\ It looks like a lot but really we're just conditionally loading a few files,
\ since this file can be loaded multiple times in a programming session.

\ Forth Language-level Extensions
  [undefined] f+ [if]
    +opt
    warning on
    requires fpmath
    cr .( loaded: fpmath)
  [then]

  [undefined] ffl.version [if]
    pushpath cd lib\ffl-0.8.0
      decimal
      include xml
      include xml-utils
      include base64
    poppath
  [then]
  
  [undefined] 1sf [if]
    include lib\fpext
    cr .( loaded: fpext)
  [then]
  [undefined] rnd [if]
    requires rnd
  [then]
  [undefined] zstring [if]
    include lib\string-operations
  [then]
  [undefined] file@ [if]
    include lib\files
  [then]
  [undefined] fixedp [if]
    true constant fixedp
    include lib\fixedp_2
  [then]
  [undefined] ALLEGRO_VERSION_INT [if]
    pushpath cd lib\allegro-5.2
      include allegro-5.2.f
    poppath
  [then]

  [undefined] rld [if]
    : rld  ( -- )  warning off  s" dev.f" included ;
    \ Dev tool: reload from the top

    create null-personality
      4 cells , 19 , 0 , 0 ,
      ' noop , \ INVOKE    ( -- )
      ' noop , \ REVOKE    ( -- )
      ' noop , \ /INPUT    ( -- )
      ' drop ,  \ EMIT      ( char -- )
      ' 2drop , \ TYPE      ( addr len -- )
      ' 2drop , \ ?TYPE     ( addr len -- )
      ' noop , \ CR        ( -- )
      ' noop , \ PAGE      ( -- )
      ' drop , \ ATTRIBUTE ( n -- )
      ' dup , \ KEY       ( -- char )
      ' dup , \ KEY?      ( -- flag )
      ' dup , \ EKEY      ( -- echar )
      ' dup , \ EKEY?     ( -- flag )
      ' dup , \ AKEY      ( -- char )
      ' 2drop , \ PUSHTEXT  ( addr len -- )
      ' 2drop ,  \ AT-XY     ( x y -- )
      ' 2dup , \ GET-XY    ( -- x y )
      ' 2dup , \ GET-SIZE  ( -- x y )
      ' drop , \ ACCEPT    ( addr u1 -- u2)

    : game-starter  null-personality open-personality " include toc ok bye" evaluate ;
    \ Turnkey starter

    : refresh  " eventq al_flush_event_queue  rld  ok" evaluate ;

    gild
  [then]

\ some more entitlements
include engine\2016

