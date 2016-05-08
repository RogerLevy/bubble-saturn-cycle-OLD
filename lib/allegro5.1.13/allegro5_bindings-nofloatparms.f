\ {nodoc}
\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5 bindings - "easy" graphics version
\   besides being easier to pass parameters to,
\   this version does not require a software float stack
\ ========================= copyright 2014 Roger Levy ==========================


ALLEGRO_VERSION 24 lshift
ALLEGRO_SUB_VERSION 16 lshift or
ALLEGRO_WIP_VERSION 8 lshift or
\ ALLEGRO_RELEASE_NUMBER or
constant ALLEGRO_VERSION_INT

: void ;
aka \ /*

fload allegro5_general
fload allegro5_events
fload allegro5_keys
fload allegro5_audio
fload allegro5_graphics
