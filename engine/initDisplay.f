
0 value defaultFont
0 value displaytimer
0 value fps
0 value allegro?
0 value eventq
0 value display

: assertAllegro
  allegro? ?exit
  true to allegro?
  al_init
  not if  " INIT-ALLEGRO: Couldn't initialize Allegro." alert     -1 abort then
  al_init_image_addon
  not if  " Allegro: Couldn't initialize image addon." alert      -1 abort then
  al_init_primitives_addon
  not if  " Allegro: Couldn't initialize primitives addon." alert -1 abort then
  al_init_font_addon
  not if  " Allegro: Couldn't initialize font addon." alert       -1 abort then
  al_install_mouse
  not if  " Allegro: Couldn't initialize mouse." alert            -1 abort then
  al_install_keyboard
  not if  " Allegro: Couldn't initialize keyboard." alert         -1 abort then
  al_install_joystick
  not if  " Allegro: Couldn't initialize joystick." alert         -1 abort then

  al_create_event_queue  to eventq

  r> call

  displaytimer not if
    1e
      display al_get_display_refresh_rate s>p
      ?dup 0= if 60 then
      dup to fps
      f f/ 1df al_create_timer
        to displaytimer
      eventq  displaytimer  al_get_timer_event_source    al_register_event_source
      eventq                al_get_mouse_event_source    al_register_event_source
      eventq                al_get_keyboard_event_source al_register_event_source
  then
;

: +timer  displaytimer al_start_timer ;
: -timer  displaytimer al_stop_timer ;

: initDisplay  ( w h -- )
  assertAllegro
  ALLEGRO_VSYNC #1 ALLEGRO_SUGGEST  al_set_new_display_option
  #0 #40 al_set_new_window_position

  0
    ALLEGRO_WINDOWED or
    ALLEGRO_RESIZABLE or
    ALLEGRO_OPENGL_3_0 or
    al_set_new_display_flags

  2i  al_create_display  to display
  al_create_builtin_font to defaultFont
  eventq  display       al_get_display_event_source  al_register_event_source
  ;

