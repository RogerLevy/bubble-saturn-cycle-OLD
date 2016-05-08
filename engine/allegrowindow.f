decimal

: create-display  ( w h -- display )
  ALLEGRO_VSYNC 1 ALLEGRO_SUGGEST  al_set_new_display_option
  0 40 al_set_new_window_position

  0
    ALLEGRO_WINDOWED or
    ALLEGRO_RESIZABLE or
    ALLEGRO_OPENGL_3_0 or
    al_set_new_display_flags

  2i  al_create_display  ( display )
  ;

