\ {nodoc}
\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5 event-related bindings
\ ========================= copyright 2014 Roger Levy ==========================

decimal
#define   ALLEGRO_EVENT_JOYSTICK_AXIS                 1
#define   ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN          2
#define   ALLEGRO_EVENT_JOYSTICK_BUTTON_UP            3
#define   ALLEGRO_EVENT_JOYSTICK_CONFIGURATION        4
#define   ALLEGRO_EVENT_KEY_DOWN                     10
#define   ALLEGRO_EVENT_KEY_CHAR                     11
#define   ALLEGRO_EVENT_KEY_UP                       12
#define   ALLEGRO_EVENT_MOUSE_AXES                   20
#define   ALLEGRO_EVENT_MOUSE_BUTTON_DOWN            21
#define   ALLEGRO_EVENT_MOUSE_BUTTON_UP              22
#define   ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY          23
#define   ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY          24
#define   ALLEGRO_EVENT_MOUSE_WARPED                 25
#define   ALLEGRO_EVENT_TIMER                        30
#define   ALLEGRO_EVENT_DISPLAY_EXPOSE               40
#define   ALLEGRO_EVENT_DISPLAY_RESIZE               41
#define   ALLEGRO_EVENT_DISPLAY_CLOSE                42
#define   ALLEGRO_EVENT_DISPLAY_LOST                 43
#define   ALLEGRO_EVENT_DISPLAY_FOUND                44
#define   ALLEGRO_EVENT_DISPLAY_SWITCH_IN            45
#define   ALLEGRO_EVENT_DISPLAY_SWITCH_OUT           46
#define   ALLEGRO_EVENT_DISPLAY_ORIENTATION          47
#define   ALLEGRO_EVENT_DISPLAY_HALT_DRAWING         48
#define   ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING       49
#define   ALLEGRO_EVENT_TOUCH_BEGIN                  50
#define   ALLEGRO_EVENT_TOUCH_END                    51
#define   ALLEGRO_EVENT_TOUCH_MOVE                   52
#define   ALLEGRO_EVENT_TOUCH_CANCEL                 53
#define   ALLEGRO_EVENT_DISPLAY_CONNECTED            60
#define   ALLEGRO_EVENT_DISPLAY_DISCONNECTED         61
\ /*
\ * Event structures
\ *
\ * All event types have the following fields in common.
\ *
\ *  type      -- the type of event this is
\ *  timestamp -- when this event was generated
\ *  source    -- which event source generated this event
\ *
\ * For people writing event sources: The common fields must be at the
\ * very start of each event structure, i.e. put _AL_EVENT_HEADER at the
\ * front.
\ */

\ #define _AL_EVENT_HEADER( srctype)

0
   var ALLEGRO_EVENT_TYPE-type
   var ALLEGRO_EVENT_TYPE-source
   2 cells field ALLEGRO_EVENT_TYPE-timestamp
constant /ALLEGRO_ANY_EVENT

/ALLEGRO_ANY_EVENT
   var ALLEGRO_DISPLAY_EVENT-x
   var ALLEGRO_DISPLAY_EVENT-y
   var ALLEGRO_DISPLAY_EVENT-width
   var ALLEGRO_DISPLAY_EVENT-height
   var ALLEGRO_DISPLAY_EVENT-orientation
constant /ALLEGRO_DISPLAY_EVENT


/ALLEGRO_ANY_EVENT
   var ALLEGRO_JOYSTICK_EVENT-*id
   var ALLEGRO_JOYSTICK_EVENT-stick
   var ALLEGRO_JOYSTICK_EVENT-axis
   var ALLEGRO_JOYSTICK_EVENT-pos (  float )
   var ALLEGRO_JOYSTICK_EVENT-button
constant /ALLEGRO_JOYSTICK_EVENT

/ALLEGRO_ANY_EVENT
   var ALLEGRO_KEYBOARD_EVENT-display
   var ALLEGRO_KEYBOARD_EVENT-keycode                 /* the physical key pressed*/
   var ALLEGRO_KEYBOARD_EVENT-unichar                 /* unicode character or negative*/
   var ALLEGRO_KEYBOARD_EVENT-modifiers               /* bitfield*/
   var ALLEGRO_KEYBOARD_EVENT-repeat                  /* auto-repeated or not*/
constant /ALLEGRO_KEYBOARD_EVENT


/ALLEGRO_ANY_EVENT
   var ALLEGRO_MOUSE_EVENT-display
   \ /* ( display) Window the event originate from
   \ * ( x, y) Primary mouse position
   \ * ( z) Mouse wheel position ( 1D 'wheel'), or,
   \ * ( w, z) Mouse wheel position ( 2D 'ball')
   \ * ( pressure) The pressure applied, for stylus ( 0 or 1 for normal mouse)
   \ */
   var ALLEGRO_MOUSE_EVENT-x
   var ALLEGRO_MOUSE_EVENT-y
   var ALLEGRO_MOUSE_EVENT-z
   var ALLEGRO_MOUSE_EVENT-w
   var ALLEGRO_MOUSE_EVENT-dx
   var ALLEGRO_MOUSE_EVENT-dy
   var ALLEGRO_MOUSE_EVENT-dz
   var ALLEGRO_MOUSE_EVENT-dw
   var ALLEGRO_MOUSE_EVENT-button
   var ALLEGRO_MOUSE_EVENT-pressure (  float )
constant /ALLEGRO_MOUSE_EVENT



/ALLEGRO_ANY_EVENT
   2 cells field ALLEGRO_TIMER_EVENT-count
   2 cells field ALLEGRO_TIMER_EVENT-error  \ double-float
constant /ALLEGRO_TIMER_EVENT



\ /* Type: ALLEGRO_USER_EVENT
\ */
\ typedef struct ALLEGRO_USER_EVENT ALLEGRO_USER_EVENT
\
\ struct ALLEGRO_USER_EVENT
\ {
\    _AL_EVENT_HEADER( struct ALLEGRO_EVENT_SOURCE)
\    struct ALLEGRO_USER_EVENT_DESCRIPTOR*__internal__descr
\    intptr_t data1
\    intptr_t data2
\    intptr_t data3
\    intptr_t data4
\ }



/* Event sources */

\ for user events:
\ function: al_init_user_event_source ( ALLEGRO_EVENT_SOURCE* -- )
\ function: al_destroy_user_event_source ( ALLEGRO_EVENT_SOURCE* -- )
\ /* The second argument is ALLEGRO_EVENT instead of ALLEGRO_USER_EVENT
\ * to prevent users passing a pointer to a too-short structure.
\ */
\ AL_FUNC( bool al_emit_user_event ( ALLEGRO_EVENT_SOURCE* ALLEGRO_EVENT* void (*dtor)( ALLEGRO_USER_EVENT* -- ))
\ function: al_unref_user_event ( ALLEGRO_USER_EVENT* -- )
\ function: al_set_event_source_data ( ALLEGRO_EVENT_SOURCE* intptr_t data -- )
\ AL_FUNC( intptr_t al_get_event_source_data ( const ALLEGRO_EVENT_SOURCE* -- )



/* Event queues */

function: al_create_event_queue ( -- ALLEGRO_EVENT_QUEUE* )
function: al_destroy_event_queue ( ALLEGRO_EVENT_QUEUE* -- )
function: al_register_event_source ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT_SOURCE* -- )
function: al_unregister_event_source ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT_SOURCE* -- )
function: al_is_event_queue_empty ( ALLEGRO_EVENT_QUEUE* -- bool )
function: al_get_next_event ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT*ret_event -- bool )
function: al_peek_next_event ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT*ret_event -- bool )
function: al_drop_next_event ( ALLEGRO_EVENT_QUEUE* -- bool )
function: al_flush_event_queue ( ALLEGRO_EVENT_QUEUE* -- )
function: al_wait_for_event ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT*ret_event -- )
\ function: al_wait_for_event_timed ( ALLEGRO_EVENT_QUEUE* ALLEGRO_EVENT*ret_event float-secs -- bool )
\ function: al_wait_for_event_until ( ALLEGRO_EVENT_QUEUE*queue ALLEGRO_EVENT*ret_event ALLEGRO_TIMEOUT*timeout -- )


function: al_acknowledge_resize ( display -- )
function: al_reset_new_display_options ( -- )
