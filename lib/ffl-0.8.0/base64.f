only forth definitions

[defined] decimal [if] decimal [then]

package ffling
private
  [UNDEFINED] ffl.version [IF]
    include ffl/config.fs
  [THEN]
public
  include ffl/b64.fs
end-package

: 64,  ( base64-src count -- )
  str-new >r  r@ b64-decode here over allot swap move  r> str-free ;
