actor super
    var fact  var img
class parabg

parabg onMapLoad:
    /flip  /depth
    " speed" ?prop if  fact !  then
    " image" ?prop if  img !  then ;

parabg start:
    0.4 fact !  parared.image img !  \ -500 zdepth +!
    show>  img @  cam 's x 2v@  fact @ negate dup 2*  drawWallpaper ;
