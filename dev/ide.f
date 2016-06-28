marker game

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


create testbuffer #256 /allot

: typechar  testbuffer count + c!  #1 testbuffer c+! ;
: interp    testbuffer count 2dup type  evaluate  ;
: rub       testbuffer c@  #-1 +  0 max  testbuffer c! ;

: obey  ['] interp catch drop  testbuffer off ;

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

: tick  focus @ not if  poll  then  sim  lag ++ ;
: tick-event  etype ALLEGRO_EVENT_TIMER = -exit  tick  ;


: ide-events  common-events  kb-events  resize-event  pause @ not if  tick-event then ;

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

: ide-ui
  /baseline
  defaultFont  1 1 1 1 4af  320 0 2af  0  testbuffer count zstring  al_draw_text ;

: ide
  ['] ide-ui is ui
  ['] ide-events is events
  ['] ide-frame is frame
  fs on ;

ide

\ unload the IDE.
: game
  ['] noop is ui
  ['] game-frame is frame
  game ;


end-package
