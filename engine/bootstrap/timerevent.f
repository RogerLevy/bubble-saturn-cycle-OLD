\ init frame timer

fixed

1e
  display al_get_display_refresh_rate  s>p
  ?dup 0= [if] 60 [then]
  dup value fps
  f f/ 1df al_create_timer
    value displaytimer

variable (timer)

: +timer  ( -- )
  al_flip_display                                                               \ do this to sync up
  (timer) ++  displaytimer al_start_timer ;

: -timer  ( -- )
  (timer) --  (timer) @ 0 <= if  displaytimer al_stop_timer  then ;

\ init event objects
al_create_event_queue  value  eventq
eventq  displaytimer  al_get_timer_event_source    al_register_event_source
eventq  display       al_get_display_event_source  al_register_event_source
eventq                al_get_mouse_event_source    al_register_event_source
eventq                al_get_keyboard_event_source al_register_event_source

