\ piston internals
: poll  pollKeyboard  pollJoysticks ;
: ?break  ( -- )  <escape> kstate shift? and abort" User break" ;
\ : ?break  ( -- )  <pause> kstate dup cr . abort" User break" ;
: tick  poll  ?break  sim  lag ++ ;
: close-event  etype ALLEGRO_EVENT_DISPLAY_CLOSE = if  0 ExitProcess  then ;
: common-events  ( kbstate-events )  close-event ;
: timer-event  etype ALLEGRO_EVENT_TIMER = if  tick  then ;
: game-events  common-events  timer-event ;
: need-update?  eventq al_is_event_queue_empty  lag @ 4 >=  or ;                ( -- flag )
: wait  eventq e al_wait_for_event ;
: consume  begin  dup execute  eventq e al_get_next_event not until  drop ;     ( xt -- )  ( -- )
: (render)  me >r  ['] render catch drop  al_flip_display  r> me! ;
: ?redraw  lag @ -exit  need-update? -exit  (render)  0 lag ! ;   ( -- )
: frame  wait  ['] game-events consume  ?redraw ;
: (dev-ok)  begin  frame  pause  again ;
: dev-ok  clearkb >gfx +timer  ['] (dev-ok) catch  -timer >ide  throw ;
