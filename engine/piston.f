\ piston internals
: poll  pollKeyboard  pollJoysticks ;
: ?refresh  ( -- )  <f5> kpressed if  refresh  then ;
: ?break  ( -- )  <escape> kstate shift? and abort" User break" ;
cr .( Press ALT-TILDE to toggle hitboxes etc. )
: ?info  <tilde> kpressed alt? and if  info @ not info !  then ;
: tick  poll  ?info  ?break  ?refresh  sim  lag ++ ;
: switch-event
  etype ALLEGRO_EVENT_DISPLAY_SWITCH_OUT = if  -timer  then
  etype ALLEGRO_EVENT_DISPLAY_SWITCH_IN = if  clearkb  +timer  then ;
: close-event  etype ALLEGRO_EVENT_DISPLAY_CLOSE = if  0 ExitProcess  then ;
: common-events  ( kbstate-events )  close-event switch-event ;
: timer-event  etype ALLEGRO_EVENT_TIMER = if  tick  then ;
: game-events  common-events  timer-event ;
: need-update?  eventq al_is_event_queue_empty  lag @ 4 >=  or ;                ( -- flag )
: wait  eventq e al_wait_for_event ;
: consume  begin  dup execute  eventq e al_get_next_event not until  drop ;     ( xt -- )  ( -- )
: (render)  me >r  ['] render catch drop  al_flip_display  r> me! ;
: ?redraw  lag @ -exit  need-update? -exit  (render)  0 lag ! ;   ( -- )
: game-frame  wait  ['] game-events consume  ?redraw ;
' game-frame is frame
