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
  : ?sib  ( addr c -- flag )  \ if true, current node is the found one.
    locals| c adr |
    dom dom-first  begin while  drop  adr c  name?  ?dup ?exit  ?next repeat
    false  ;
  : attr?  nest ?sib unnest ;
  : @attr$  ( addr c -- str count )  \ if not found, throw an error.
    nest  ?sib not if  -1 abort" Attribute not found."  then  @str  unnest ;
  : @attr  ( addr c -- n )  \ if not found, throw an error.
    @attr$ evaluate ;
  : type. ( n -- )
    case
      dom.attribute of ." (attribute)" endof
      dom.element   of ." (element)" endof
      dom.text      of ." (text)" endof
      dom.cdata     of ." [CDATA]" endof
      dom.comment   of ." (comment)" endof
    endcase  space ;
  : .name  cr @name type space  dom dom-get-type type. ;
  : (.child)  @name type dom.attribute = if  ." : " @str type then space ;
  : .node  .name  ."  Length: " dom dom-children . ."  Children: " ['] (.child) drill ;

  : search  ( addr c xt -- flag )  ( ... dom-type -- found? ... )  \ if found, don't unnest
    dom dom-children 0= if  2drop false exit  then
    xt >r  to xt
    dom dom-child
      begin
        .node
        ( type ) xt execute
        if  r> to xt  true exit
        else  dom dom-next 0= if  unnest  r> to xt  false  exit then
        then
      again ;

  :noname  ( addr c type -- addr c flag )
    dom.element = dup -exit  drop  2dup name? ;
    : ?elem  ( addr c -- false | true+nest )
      [ literal ] search nip nip ;



\  : @text  ( -- addr c )  \ will cause errors if element has no text.
\    [ literal ] search drop unnest ;

end-package
