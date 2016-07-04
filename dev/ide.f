
package ideing
public

\ design:
\  - when the IDE is loaded, we enter fullscreen and override the piston's main
\  loop with our own which adds the UI display and event processing words.
\  - keyboard, mouse, and joystick events can be directed either to the game,
\  or to the UI.  when it's directed to the game, it's hidden.
\  - the game viewport is visible at all times, scaled to a 640x480 portion
\  of the screen.
\  - the game can be paused.  if the audio engine is enabled, it will be suspended.
\  - you can toggle pausing of the game's logic with CTRL+P.
\  - ALT-ENTER has different behavior in Game mode and IDE mode.
\      Game: toggle fullscreen and send the resize event to game (game might change the border)
\      IDE:  toggle fullscreen and send the resize event to IDE (border stays the same)
\  - the IDE has separate "windowed" dimensions.  GFXW and GFXH remain the game's
\    internal resolution.  IDEW and IDEH represent what the current size of the
\    IDE's display is.
\  - the Listener is on the right side of the screen and uses a fixed-width
\      font that has been derived from Consolas.  It has the following features:
\      - Paste from clipboard (multiline)
\      - History and Log file
\      - Thrown errors are printed instead of shown in a window.
\      - When an error is thrown, SIM and RENDER are turned off.
\      - Stack and base display
\      - Full text editing (FUTURE, precursor to apprentice/compiler/editor package)
\            - toggle Listener/Editor mode
\            - shift-enter inserts a line
\            - cut, copy, paste
\            - move by word
\            - interpret (step) word (supporting conditionals)
\            - browser-style navigation
\            - jump to definition
\            - search/replace
\            - hide comments
\            - "shadow" lines (80 / 80 split)
\            - limited auto-formatting; single->double->multi, phrasing, conditional alignment
\            - syntax coloring.  (includes defining word smartness)



create oldblender  6 cells allot
: blender>  ( op src dest aop asrc adest -- )
  oldblender dup cell+ dup cell+ dup cell+ dup cell+ dup cell+ al_get_separate_blender  al_set_separate_blender  r> call
  oldblender @+ swap @+ swap @+ swap @+ swap @+ swap @ al_set_separate_blender ;


: write-rgba  ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ZERO ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ZERO ;
: add-rgba    ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ONE  ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ONE  ;
: blend-rgba  ALLEGRO_ADD ALLEGRO_ALPHA ALLEGRO_INVERSE_ALPHA  ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ONE  ;

blend-rgba al_set_separate_blender


create testbuffer #256 /allot
create history  #256 /allot

: recall  history count testbuffer place ;
: store   testbuffer count history place ;


: typechar  testbuffer count + c!  #1 testbuffer c+! ;
: interp    testbuffer count 2dup type space  evaluate ;
: rub       testbuffer c@  #-1 +  0 max  testbuffer c! ;

: ?.catch  ?dup -exit .catch ;
: obey  store  ['] interp catch ?.catch cr testbuffer off  ;

include dev\win-clipboard.f

: paste     clpb testbuffer append ;


defer events    \ event handler
defer ui        \ render UI

variable pause
variable focus


\ doesn't seem to function in fullscreen.  (Allegro bug?)
: ?pause  pause @ if  -timer  else  +timer  then ;

: keycode  e ALLEGRO_KEYBOARD_EVENT-keycode @ ;
: unichar  e ALLEGRO_KEYBOARD_EVENT-unichar @ ;

: special
  case
    [char] v of  paste  endof
    [char] p of  pause toggle  endof
  endcase ;

private
  : ctrl?  e ALLEGRO_KEYBOARD_EVENT-modifiers @ ALLEGRO_KEYMOD_CTRL and ;
public

: kb-events
  etype case
    ALLEGRO_EVENT_KEY_DOWN of
      keycode dup #37 < if  drop exit  then
      case
      \  <F11> of  pause toggle  endof
        <tab> of  focus toggle  endof
      endcase
    endof
    ALLEGRO_EVENT_KEY_CHAR of

      ctrl? if
          unichar $60 + special
      else
        focus @ -exit
        unichar #32 >= unichar #126 <= and if
            unichar typechar  exit
        then
        keycode case
          <up> of  recall  endof
          <down> of  testbuffer off  endof
          <enter> of  alt? ?exit  obey  endof
          <backspace> of  rub  endof
        endcase
      then
    endof
  endcase
  ;


: resize-event
  etype ALLEGRO_EVENT_DISPLAY_RESIZE = -exit
  display al_acknowledge_resize ;

: tick  focus @ not if  poll  then  sim  (sweep)  lag ++ ;
: tick-event  etype ALLEGRO_EVENT_TIMER = -exit  tick  ;


: ide-events  common-events  kb-events  resize-event  pause @ not if  tick-event then ;


\ ----------------------------- console output --------------------------------
nativew nativeh 2i al_create_bitmap value output

: ?half  focus @ if 1 else 0.5 then ;

: console  output  1 1 1 ?half  4af  at@ 2af  0  al_draw_tinted_bitmap ;

private
0
  xvar x
  xvar y
  4 cells xfield color
struct /cursor
public


create ch  0 c, 0 c,
variable lmargin  320 lmargin !
variable rmargin  nativew 2 / rmargin !
variable bmargin  nativeh 2 / 8 - 8 - bmargin !


create cursor  /cursor /allot  lmargin @ cursor x !
1 1 1 1 cursor color ~!+ ~!+ ~!+ ~!+ drop

: console-get-xy  cursor x 2v@ 8 8 2/ 2i ;
: console-at-xy   2s>p 8 8 2* cursor x 2v! ;

: (scroll)
  write-rgba blender>
  al_get_target_bitmap
    output al_set_target_bitmap
    output 0 -8 2af 0 al_draw_bitmap
  al_set_target_bitmap
  -8 cursor y +!
;

: console-cr
    lmargin @ cursor x !
    8 cursor y +!
    cursor y @ bmargin @ >= if  (scroll)  then
;

: (emit)
  ch c!
    defaultFont
    cursor color @+ swap @+ swap @+ swap @+ nip 4af
    cursor x 2v@ 2af
    0
    ch
      al_draw_text

    8 cursor x +!
    cursor x @ rmargin @ >= if  console-cr  then
;

: console-emit
  al_get_target_bitmap swap
    output al_set_target_bitmap
    (emit)
  al_set_target_bitmap
;

decimal
: console-type  0 ?do  dup c@ console-emit 1 +  loop  drop ;
fixed


create console-personality
  4 cells , #19 , 0 , 0 ,
  ' noop , \ INVOKE    ( -- )
  ' noop , \ REVOKE    ( -- )
  ' noop , \ /INPUT    ( -- )
  ' console-emit , \ EMIT      ( char -- )
  ' console-type , \ TYPE      ( addr len -- )
  ' console-type , \ ?TYPE     ( addr len -- )
  ' console-cr , \ CR        ( -- )
  ' noop , \ PAGE      ( -- )
  ' drop , \ ATTRIBUTE ( n -- )
  ' dup , \ KEY       ( -- char )
  ' dup , \ KEY?      ( -- flag )
  ' dup , \ EKEY      ( -- echar )
  ' dup , \ EKEY?     ( -- flag )
  ' dup , \ AKEY      ( -- char )
  ' 2drop , \ PUSHTEXT  ( addr len -- )
  ' console-at-xy ,  \ AT-XY     ( x y -- )
  ' console-get-xy , \ GET-XY    ( -- x y )
  ' 2dup , \ GET-SIZE  ( -- x y )
  ' drop , \ ACCEPT    ( addr u1 -- u2)

\ -------------------------------- IDE display --------------------------------

private  variable cx variable cy variable cw variable ch
public
: framed
  cx cy cw ch al_get_clipping_rectangle
  0 0 #640 #480 al_set_clipping_rectangle   execute
  cx @ cy @ cw @ ch @ al_set_clipping_rectangle ;


: cls  ( -- )  focus @ if  0.4 0.4 0.4 1  else  0 0.3 0 1  then clear-to-color ;

: (render)  me >r  ?fs  cls  ['] render framed  ui  al_flip_display  r> as ;

: ?redraw
  pause @ not if
    lag @ -exit  need-update? -exit  (render)  0 lag !
  else
    (render)
  then ;

: ide-frame  wait  ?pause  ['] events epump  ?redraw ;

\ baseline matrix
transform baseline

: /baseline  ( -- )
  baseline  al_identity_transform
  baseline  factor @ dup 2af  al_scale_transform
  baseline  al_use_transform  ;

: ?_  focus @ -exit  #frames 16 and -exit  s[ [char] _ c+s ]s ;

: commandline
  defaultFont  ?half dup dup 1 4af  at@ 2af  0  testbuffer count ?_ zstring  al_draw_text ;

: ide-ui
  /baseline
  0  0 at  console
  320  nativeh 2 / 8 -  at  commandline
  ;

: ide/
  fs off
  ['] noop is ui
  ['] game-events is events
  ['] game-frame is frame
  previous-personality @ if close-personality then
;

: ide
  console-personality open-personality
  ['] ide-ui is ui
  ['] ide-events is events
  ['] ide-frame is frame
  fs on
  focus on
  ok
  ide/
  ;

: rld  ide/  rld ;
: empty  ide/  empty ;

end-package
