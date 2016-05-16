variable kinematic


\ convenience words

: space  cpSpaceNew constant ;

: boxMoment  ( mass width height -- moment )  3af cpMomentForBox ;
: newBody    ( moment mass -- ) swap 2af cpBodyNew ;
: addBody    ( body space -- ) swap cpSpaceAddBody ;
: addShape   ( shape space -- ) swap cpSpaceAddBody ;

: boxShape   ( body w h radius -- shape ) 3af cpBoxShapeNew ;

: @dens    ( shape -- shape n )  dup cpShapeGetDensity ;

: !elas    ( shape n -- shape ) udup cpShapeSetElasticity ;
: !fric    ( shape n -- shape ) udup cpShapeSetFriction ;
: !avel    ( body n -- body ) udup cpBodySetAngularVelocity ;
: !pos     ( body x y -- body ) >r udup r> cpBodySetPosition ;
: a!fric   ( arbiter n -- arbiter ) udup cpArbiterSetFriction ;
: !dens    ( shape n -- shape ) udup cpShapeSetDensity ;
: !filter  ( shape n -- shape ) udup cpShapeSetFilter ;


\ demo words
: update  ( space dt -- ) cpSpaceStep ;
: addBox  ( vpos mass width height space -- )
  0 locals| body space h w mass pos |
  mass w h boxMoment  mass newBody to body   body space addBody
  body pos !pos  \ factor this out using the Pen
  body w h 0 boxShape  dup  space addBody  0 !elas  0.7 !fric  drop ;



-200 -200 staticVect a
-200  200 staticVect b
 200  200 staticVect c
 200 -200 staticVect d

: boxSeg  ( space vect1 vect2 -- )
  kinematic @ -rot 0 newSegment dup third addShape
    1 !elac  1 !fric  NOT_GRABBABLE_FILTER !filter  drop ;

: init  ( -- space )
  cpSpaceNew 0 1 30 60 | h w mass shape space |
\ static cpSpace *
\ init(void)
\ {
\ 	cpSpace *space = cpSpaceNew();
\ 	cpSpaceSetGravity(space, cpv(0, -600));
\
\ 	cpShape *shape;

  space cpBodyNewKinematic kinematic !
  kinematic @ 0.4 !angVel

	\ // We create an infinite mass rogue body to attach the line segments too
	\ // This way we can control the rotation however we want.
	\ KinematicBoxBody = cpSpaceAddBody(space, cpBodyNewKinematic());
	\ cpBodySetAngularVelocity(KinematicBoxBody, 0.4f);

\	// Set up the static box.
\	cpVect a = cpv(-200, -200);
\	cpVect b = cpv(-200,  200);
\	cpVect c = cpv( 200,  200);
\	cpVect d = cpv( 200, -200);

  space dup a b boxSeg  dup b c boxSeg  dup c d boxSeg  d a boxSeg

	\ shape = cpSpaceAddShape(space, cpSegmentShapeNew(KinematicBoxBody, a, b, 0.0f));
	\ cpShapeSetElasticity(shape, 1.0f);
	\ cpShapeSetFriction(shape, 1.0f);
	\ cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);
  \
	\ shape = cpSpaceAddShape(space, cpSegmentShapeNew(KinematicBoxBody, b, c, 0.0f));
	\ cpShapeSetElasticity(shape, 1.0f);
	\ cpShapeSetFriction(shape, 1.0f);
	\ cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);
  \
	\ shape = cpSpaceAddShape(space, cpSegmentShapeNew(KinematicBoxBody, c, d, 0.0f));
	\ cpShapeSetElasticity(shape, 1.0f);
	\ cpShapeSetFriction(shape, 1.0f);
	\ cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);
  \
	\ shape = cpSpaceAddShape(space, cpSegmentShapeNew(KinematicBoxBody, d, a, 0.0f));
	\ cpShapeSetElasticity(shape, 1.0f);
	\ cpShapeSetFriction(shape, 1.0f);
	\ cpShapeSetFilter(shape, NOT_GRABBABLE_FILTER);

	\ cpFloat mass = 1;
	\ cpFloat width = 30;
	\ cpFloat height = width*2;

  7 0 do
    3 0 do
      w j * 150 -  h i * 150 -  cpv  ( pos )
        mass w h space addBox
    loop
  loop

	\ // Add the bricks.
	\ for(int i=0; i<7; i++){
	\ 	for(int j=0; j<3; j++){
	\ 		cpVect pos = cpv(i*width - 150, j*height - 150);
  \
	\ 		int type = (rand()%3000)/1000;
	\ 		if(type ==0){
	\ 			AddBox(space, pos, mass, width, height);
	\ 		} else if(type == 1){
	\ 			AddSegment(space, pos, mass, width, height);
	\ 		} else {
	\ 			AddCircle(space, cpvadd(pos, cpv(0.0, (height - width)/2.0)), mass, width/2.0);
	\ 			AddCircle(space, cpvadd(pos, cpv(0.0, (width - height)/2.0)), mass, width/2.0);
	\ 		}
	\ 	}
	\ }
  space ;
\ 	return space;
\ }


\ static void
\ destroy(cpSpace *space)
\ {
\ 	ChipmunkDemoFreeSpaceChildren(space);
\ 	cpSpaceFree(space);
\ }
\
\ ChipmunkDemo Tumble = {
\ 	"Tumble",
\ 	1.0/180.0,
\ 	init,
\ 	update,
\ 	ChipmunkDemoDefaultDrawImpl,
\ 	destroy,
\ };





\ static void
\ AddBox(cpSpace *space, cpVect pos, cpFloat mass, cpFloat width, cpFloat height)
\ {
\ 	cpBody *body = cpSpaceAddBody(space, cpBodyNew(mass, cpMomentForBox(mass, width, height)));
\ 	cpBodySetPosition(body, pos);
\
\ 	cpShape *shape = cpSpaceAddShape(space, cpBoxShapeNew(body, width, height, 0.0));
\ 	cpShapeSetElasticity(shape, 0.0f);
\ 	cpShapeSetFriction(shape, 0.7f);
\ }


\\
\ static void
\ AddSegment(cpSpace *space, cpVect pos, cpFloat mass, cpFloat width, cpFloat height)
\ {
\ 	cpBody *body = cpSpaceAddBody(space, cpBodyNew(mass, cpMomentForBox(mass, width, height)));
\ 	cpBodySetPosition(body, pos);
\
\ 	cpShape *shape = cpSpaceAddShape(space, cpSegmentShapeNew(body, cpv(0.0, (height - width)/2.0), cpv(0.0, (width - height)/2.0), width/2.0));
\ 	cpShapeSetElasticity(shape, 0.0f);
\ 	cpShapeSetFriction(shape, 0.7f);
\ }
\
\ static void
\ AddCircle(cpSpace *space, cpVect pos, cpFloat mass, cpFloat radius)
\ {
\ 	cpBody *body = cpSpaceAddBody(space, cpBodyNew(mass, cpMomentForCircle(mass, 0.0, radius, cpvzero)));
\ 	cpBodySetPosition(body, pos);
\
\ 	cpShape *shape = cpSpaceAddShape(space, cpCircleShapeNew(body, radius, cpvzero));
\ 	cpShapeSetElasticity(shape, 0.0f);
\ 	cpShapeSetFriction(shape, 0.7f);
\ }

