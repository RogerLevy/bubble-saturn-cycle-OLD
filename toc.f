empty \ NTS: this line is interpreted, so it always refers to the latest definition.

\ ============================= dependencies ==================================
include engine\preamble.f
\ ============================ end dependencies ===============================

\ =========================== main load sequence ==============================

/RND

\ standard game services (core game lexicon)
include engine\saturn\gameorama
[defined] dev [if] include dev\ide.f [then]

\ libraries

\ load other game services
include modules\stride2d
include modules\collision-grid

include modules\swes\sprites
\ include modules\swes\tilesets
\ include modules\swes\tilemap
\ include modules\swes\tilemap-collision
\ include modules\swes\layers

include modules\gameutils
include modules\wallpaper
include modules\tiled-level

\ -----------------------------------------------------------------------------
\ game-specific definitions

\ global constants, variables, and assets
include data

include engine\saturn\scripting.f
include engine\saturn\objects.f
include engine\saturn\physics.f
include objects\box  \ needed to define onLoadBox
include engine\saturn\zones.f

\ Because tiled-level automatically loads object scripts,
\ it's not necessary to manually load object scripts.  (6/16/2016)
\ If some code depends on a script being loaded, use ?OBJECT

include engine\saturn\saturn.f
include map-tokens

\ ========================= end main load sequence ============================

include startup.f
