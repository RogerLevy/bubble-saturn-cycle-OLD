:noname
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
; execute
