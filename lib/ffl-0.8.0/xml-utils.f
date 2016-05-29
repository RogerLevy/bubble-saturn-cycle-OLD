dom-create dom

0 value xt
: dom-drill  ( xt dom -- )  ( ... dom-type -- ... )
  dup dom-children 0= if  2drop exit  then
  xt >r  swap to xt
  dup dom-child
    begin  while
      ( dom type ) swap >r  xt execute  r>
\      cr dom dom-get-name type
      dup dom-next
    repeat
  dom-parent 2drop
  r> to xt
;

package doming
  : read  true dom dom-read-string 0= throw  dom dom-document drop ;
  : @name  dom dom-get-name ;
  : nest  dom dom-child 2drop ;
  : ?next  dom dom-next ;
  : drill  dom dom-drill ;
  : @n    dom dom-get-value evaluate ;
  : @str  dom dom-get-value ;
  : unnest  dom dom-parent 2drop ;
  : done  dom dom-(free) ;
  : name?  @name compare 0= ;
  : sib?  ( addr c -- flag )  \ if true, current node is the found one.
    locals| c adr |
    dom dom-first  begin while  drop  adr c  name?  ?dup ?exit  ?next repeat
    false  ;
  : attr?  nest sib? unnest ;
  : @attrstr  ( addr c -- str count )  \ if not found, throw an error.
    nest  sib? not if  unnest  xis.error throw  then  @str  unnest ;
  : @attr  ( addr c -- n )  \ if not found, throw an error.
    @attrstr evaluate ;
  : .name  cr @name type ;
end-package
