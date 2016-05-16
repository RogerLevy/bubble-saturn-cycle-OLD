empty \ NTS: this line is interpreted, so it always refers to the latest definition.

\ ============================= dependencies ==================================

\ Extended Vocabulary
include engine\ext.f

\ ============================ end dependencies ===============================

\ =========================== main load sequence ==============================

/RND

include gameorama  \ load standard game services (core)

\ load other game services
include modules\safetables
include sprites
\ include tilesets
\ include tilemap
\ include tilemap-collision
include modules\collision-grid

\ game systems
\ include gpu

\ global constants, variables, and assets
include data

\ game definitions
include modules\gameutils
include scripting
include objects
include saturn

\ ========================= end main load sequence ============================

