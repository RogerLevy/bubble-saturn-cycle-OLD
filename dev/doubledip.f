\ object scripting testing aid

\  redefines several words to modify already-defined node class info in-place.
\  restarts all active actors with the class specified by `START:`
\  
\  the point of this feature is to allow us total freedom in choosing
\  simple word names so that each class's script can be properly factored,
\  but still regain access to any buried aforementioned words just by
\  reloading the script.

variable redef

package classing
: class
  >in @ >r  defined if  r> drop  execute dup redef ! isize !  drop
                    else  drop  r> >in ! class  then
;
end-package

: staticvar  >in @ >r  defined if  drop  r> drop  exit  then  r> >in !  staticvar ;


: (upd)  redef @ stage all>  me class @ over = -exit  0 0 vx 2v!  init ;

: start:  ( class -- <code> )
  dup redef @ = if  start:  (upd)  redef off  exit then
  start: ;

: update  ( -- <objectname> )
  " include obj/" s[ bl parse +s ]s evaluate  focus off  pause off ;
