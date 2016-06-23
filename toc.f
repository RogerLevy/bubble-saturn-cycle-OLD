empty \ NTS: this line is interpreted, so it always refers to the latest definition.

\ ============================= dependencies ==================================
include engine\preamble.f
\ ============================ end dependencies ===============================

\ =========================== main load sequence ==============================

/RND

include gameorama  \ load standard game services (core)

\ libraries
include modules\stride2d

\ load other game services
include modules\collision-grid

include swes\sprites
\ include swes\tilesets
\ include swes\tilemap
\ include swes\tilemap-collision
\ include swes\layers

include modules\gameutils
include modules\wallpaper
include modules\tiled-level

\ global constants, variables, and assets
include data

\ -----------------------------------------------------------------------------
\ game definitions

include scripting
include objects
include physics
include objects\box  \ needed to define onLoadBox

\ Because tiled-level automatically loads object scripts,
\ it's not necessary to manually load object scripts.  (6/16/2016)
\ If some code depends on a script being loaded, use ?OBJECT

include saturn
include map-tokens

\ ========================= end main load sequence ============================


: cleanup  ( -- )  cleanup  boxGrid resetGrid  dynGrid resetGrid ;

: map  ( tmxpath c area# -- <name> )  ( -- )  \ area# points to an entry in a table
  create  , string, 
  does>  @+ to area#  count  cleanup  loadTMX ;


" data\maps\W01_A02_v01.tmx" 0 map sfw0

sfw0

