\ piston internals
0 value breaking?
variable fs

: poll  pollKB  pollJoys ;

: ?wpos  fs @ ?exit  display #0 #0 al_set_window_position ;
: ?fs  display ALLEGRO_FULLSCREEN_WINDOW fs @ al_toggle_display_flag drop  ?wpos ;
: break  ( -- )  true to breaking? ;
cr .( Press ALT-TILDE to toggle hitboxes etc. )
: tick  poll  sim  lag ++ ;

: switch-event
  etype ALLEGRO_EVENT_DISPLAY_SWITCH_OUT = if  -timer  then
  etype ALLEGRO_EVENT_DISPLAY_SWITCH_IN = if  clearkb  +timer  then ;
: close-event  etype ALLEGRO_EVENT_DISPLAY_CLOSE = -exit  0 ExitProcess ;

0 value alt? \ fix alt-enter bug when game doesn't have focus
: kb-events
  etype ALLEGRO_EVENT_KEY_DOWN = if
    e ALLEGRO_KEYBOARD_EVENT-keycode @ case
      <alt> of  true to alt?  endof
      <altgr>  of  true to alt?  endof
      <enter> of  alt? -exit  fs toggle  endof
      <f5> of  refresh  endof
      <escape> of  break  endof
      <tilde> of  alt? -exit  info toggle  endof
    endcase
  then
  etype ALLEGRO_EVENT_KEY_UP = if
    e ALLEGRO_KEYBOARD_EVENT-keycode @ case
      <alt> of  false to alt?  endof
      <altgr>  of  false to alt?  endof
    endcase
  then ;

: common-events  close-event switch-event kb-events ;
: tick-event  etype ALLEGRO_EVENT_TIMER = -exit  tick  ;
: game-events  common-events  tick-event ;

: need-update?  eventq al_is_event_queue_empty  lag @ 4 >=  or ;                ( -- flag )
: wait  eventq e al_wait_for_event ;
: epump  begin  dup >r  execute  r>  eventq e al_get_next_event not  until  drop ;     ( xt -- )  ( -- )
: (render)  me >r  ?fs  render  al_flip_display  r> as ;
: ?redraw  lag @ -exit  need-update? -exit  (render)  0 lag ! ;   ( -- )

: game-frame  wait  ['] game-events epump  ?redraw ;
' game-frame is frame
