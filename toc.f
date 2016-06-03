empty \ NTS: this line is interpreted, so it always refers to the latest definition.

\ ============================= dependencies ==================================
include engine\preamble.f
\ ============================ end dependencies ===============================

\ =========================== main load sequence ==============================

/RND

include gameorama  \ load standard game services (core)

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

\ game definitions

include scripting
include objects
include saturn


\ ========================= end main load sequence ============================

