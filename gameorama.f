\ game engine 0.5 (versioned 4/22/2016)

fixed
64 cells struct /actorslot
include modules/nodes
include modules/rects
include modules/2d-arrays
include modules/id-radixsort
include modules/allegro-floats

\ -----------------------------------------------------------------------------
fixed
variable factor  2 factor !
320 value gfxw                                                                  \ doesn't necessarily reflect the window size.
240 value gfxh

\ -----------------------------------------------------------------------------
include engine/createDisplay
include engine/bootstrap/init-allegro

fixed
gfxw gfxh factor @ dup 2* createDisplay value display                          \ actually create the display
al_create_builtin_font value default-font
create native  /ALLEGRO_DISPLAY_MODE /allot
  al_get_num_display_modes 1 - native al_get_display_mode

include engine/bootstrap/timerevent

\ ------------------------ words for switching windows ------------------------
: focus  ( winapi-window - )                                                    \ force window via handle to be the active window
  dup 1 ShowWindow drop  dup BringWindowToTop drop  SetForegroundWindow drop ;
: >gfx  ( - )  display al_get_win_window_handle focus ;                         \ force allegro display window to take focus
: >ide  ( - )  HWND focus ;                                                     \ force the Forth prompt to take focus
>ide

\ --------------------------------- utilities ---------------------------------
: nativew   native x@ ;
: nativeh   native y@ ;

\ some meta-compilation systems management stuff
: teardown  display al_destroy_display  al_uninstall_system ;
: empty   teardown only forth empty ;

\ --------------------------------- keyboard ----------------------------------
decimal
include engine/input
: klast  kblast swap al_key_down  ;
: kstate kbstate swap al_key_down ;
: kdelta >r  r@ kstate 1 and  r> klast 1 and  - ;
: kpressed  kdelta 1 = ;
: kreleased  kdelta -1 = ;
: alt?   <alt> kstate     <altgr> kstate   or ;
: ctrl?  <lctrl> kstate   <rctrl> kstate   or ;
: shift? <lshift> kstate  <rshift> kstate  or ;

\ ------------------------------- joysticks -----------------------------------
decimal
: jstate ( joy# button# - 0-1.0 )
  cells swap joystick[] ALLEGRO_JOYSTICK_STATE-buttons + @  PGRAN 32767 */ ;

\ --------------------------- graphics services -------------------------------
create penx  0 ,  here 0 ,  constant peny
: at   ( x y -- )  penx 2v! ;
: +at  ( x y -- )  penx 2v+! ;
: at@  ( -- x y )  penx 2v@ ;
: -at  ( x y -- )  2negate +at ;
\ NTS: the pen should always function as a final translation stage
\ NTS: add matrix words (as of 2/21 i'm going to keep things very basic.)
: clear-to-color  ( r g b a -- ) 4af al_clear_to_color ;
: bitmapW   al_get_bitmap_width  s>p ;
: bitmapH   al_get_bitmap_height  s>p ;
: soft-bitmaps  ( -- )
  al_get_new_bitmap_flags
  [ ALLEGRO_MIN_LINEAR ALLEGRO_MAG_LINEAR or ] literal or
  al_set_new_bitmap_flags ;
: crisp-bitmaps  ( -- )
  al_get_new_bitmap_flags
  [ ALLEGRO_MIN_LINEAR ALLEGRO_MAG_LINEAR or invert ] literal and
  al_set_new_bitmap_flags ;
16 cells struct /transform
: transform  create  here  /transform allot  al_identity_transform ;
decimal
: hold[ 1 al_hold_bitmap_drawing ;
: ]hold 0 al_hold_bitmap_drawing ;
decimal
0 constant FLIP_NONE
1 constant FLIP_H
2 constant FLIP_V
3 constant FLIP_HV

\ ---------------------------------- images -----------------------------------
fixed
0
  xvar bmp  xvar subw  xvar subh  xvar fsubw  xvar fsubh
  xvar subcols  xvar subrows  xvar numSubimages
struct /image

: initImage  ( ALLEGRO_BITMAP image -- ) bmp ! ;

: image  ( -- <name> <path> )
  create /image allotment <zfilespec> al_load_bitmap swap initImage ;

\ dimensions
: imageW  bmp @ bitmapW ;
: imageH  bmp @ bitmapH ;
: imageDims  dup imageW swap imageH ;

\ ------------------------------ subimage stuff -------------------------------
fixed
: subdivide  ( tilew tileh image -- )
  >r  2dup r@ subw 2v!  2af r@ fsubw 2v!
  r@ imageDims r@ subw 2v@ 2/ 2pfloor  2dup r@ subcols 2v!
  *  r> numSubimages ! ;

: >subxy  ( n image -- x y )                                                    \ locate a subimage by index
  >r  pfloor  r@ subcols @  /mod  2pfloor  r> subw 2v@ 2* ;

: afsubimg  ( n image -- ALLEGRO_BITMAP fx fy fw fh )                           \ helps with calling Allegro blit functions
  >r  r@ bmp @  swap r@ >subxy 2af  r> fsubw 2v@ ;

\ ----------------------------- actors / stage --------------------------------
list stage
list backstage
0 value me
: me!  to me ;
\ : var  create dup , cell +  does> @ me + ;                                      ( total -- <name> total+cell )
: field  create over , + immediate does> @ " me ?lit + " evaluate ;             ( total -- <name> total+cell )
         \ faster but less debuggable version
: var  cell field ;

node super
  var vis  var x  var y    var vx  var vy
  var zdepth   \ not to be confused with z position - it's for drawing order.
  var 'act  var 'show  \ <-- internal
  var flags
  staticvar 'onStart  \ kick off script
  staticvar 'onInit   \ initialize any default vars that onStart expects.
                      \ We need this because loading from a map file
                      \ can override some default values.
class actor

#1
  bit persistent#
  bit restart#
value actorBit

variable info  \ enables debugging mode display
defer commonInit  ' noop is commonInit


: start  restart# flags not!  me class @ 'onStart @ execute ;
: show>  r> code> 'show !  vis on ;                                             ( -- <code> )
: act>   r> code> 'act ! ;                                                      ( -- <code> )
: act   flags @ restart# and if  start  then  'act @ execute ;
: show  'show @ execute ;
: init  commonInit  me class @ 'onInit @ execute ;
: itterateActors  ( xt list -- )  ( ... -- ... )
  me >r
  first @  begin  dup while  dup next @ >r  over >r  me! execute  r> r> repeat
  2drop
  r> me! ;
: all>  ( n -- )  ( n -- n )  r> code>  stage itterateActors  drop ;
: (recycle)  dup >r backstage popnode dup r> isize @ erase ;
: one                                                                           ( class -- me=obj )
  backstage length @ if  (recycle)  else  here /actorslot /allot  then
  dup stage add
  me!
  me class !  at@ x 2v!  restart# flags or!
  init ;

: unload  backstage add ;                                                       ( -- )
:noname  flags @ persistent# and -exit  me stage add ;
: (preserve)  literal backstage itterateActors ;  \ put persistent actors back
: cleanup  backstage stage append  (preserve) ;
:noname  flags @ persistent# and -exit  me backstage remove ;
: (orphan)  literal backstage itterateActors ;  \ orphan persistent actors
: clear  backstage stage append  (orphan) ;

: #actors  stage length @ ;


\ -------------------------------- piston -------------------------------------
fixed
defer render        ' noop is render
defer sim           ' noop is sim
defer frame         ' noop is frame   \ the body of the loop.  can bypass RENDER and SIM if desired.
variable lag                                                                    \ completed ticks
include engine\piston
: time?  ucounter 2>r  execute  ucounter 2r> d-  d>s  i. ;                      ( xt - )  \ print time given XT takes in microseconds
: dev-ok  clearkb >gfx +timer  begin  ['] frame catch ?dup until  -timer >ide  throw ;
: ok  dev-ok ;

\ -------------------------------- border -------------------------------------
fixed

transform outputm

: /output
  outputm  factor @ dup 2af  al_scale_transform
  outputm  al_use_transform  ;

/output

\ -------------------------------- defaults -----------------------------------
0 value #frames
: step1  0 all>  act ;
: step2  0 all>  vx 2v@ x 2v+! ;
:noname  [ is sim ]  step1  step2  1 +to #frames ;
: cls  0.5 0.5 0.5 1.0 clear-to-color ;
:noname  [ is render ] cls  0 all> show ;

' game-frame is frame
