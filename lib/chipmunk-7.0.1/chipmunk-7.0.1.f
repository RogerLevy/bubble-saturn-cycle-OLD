[defined] decimal [if] decimal [then]

library chipmunk-singles-7.0.1.dll

\ this uses the "singles" version for speed.
: floats  4 * ;
aka xvar xfloat


\ cpVect.h  a bunch of floating-point vector helper macros
2 floats constant /cpVect
\ cpBB.h  a bunch of floating-point bounding box macros.  cpBB struct is left, bottom, right, top.
4 floats constant /cpBB
\ cpTransform.h  a bunch of cpTransform  ( 6-cell matrix) macros.  a,b,c,d,tx,ty
6 floats constant /cpTransform
\   \ //   ( a, b) is the x basis vector.
\   \ //   ( c, d) is the y basis vector.
\   \ //   ( tx, ty) is the translation.
\ cpSpatialIndex.h Spatial Index  ( spatial hash, bounding box tree, 1D sort and sweep) NEEDED?


\ Misc utility functions from chipmunk.h

\ // Calculate the moment of inertia for a circle.
\ // @c r1 and @c r2 are the inner and outer diameters. A solid circle has an inner diameter of 0.
function: cpMomentForCircle ( cpFloat-m, cpFloat-r1, cpFloat-r2, cpVect-offset -- cpFloat )

\ // Calculate area of a hollow circle.
\ // @c r1 and @c r2 are the inner and outer diameters. A solid circle has an inner diameter of 0.
function: cpAreaForCircle ( cpFloat-r1, cpFloat-r2 -- cpFloat )

\ // Calculate the moment of inertia for a line segment.
\ // Beveling radius is not supported.
function: cpMomentForSegment ( cpFloat-m, cpVect-a, cpVect-b, cpFloat-radius -- cpFloat )

\ // Calculate the area of a fattened  ( capsule shaped) line segment.
function: cpAreaForSegment ( cpVect-a, cpVect-b, cpFloat-radius -- cpFloat )

\ // Calculate the moment of inertia for a solid polygon shape assuming it's center of gravity is at it's centroid. The offset is added to each vertex.
function: cpMomentForPoly ( cpFloat-m, int-count, const cpVect-*verts, cpVect-offset, cpFloat-radius -- cpFloat )

\ // Calculate the signed area of a polygon. A Clockwise winding gives positive area.
\ // This is probably backwards from what you expect, but matches Chipmunk's the winding for poly shapes.
function: cpAreaForPoly ( const-int-count, const cpVect-*verts, cpFloat-radius -- cpFloat )

\ // Calculate the natural centroid of a polygon.
function: cpCentroidForPoly ( const-int-count, const-cpVect-*verts -- cpVect )

\ // Calculate the moment of inertia for a solid box.
function: cpMomentForBox ( cpFloat-m, cpFloat-width, cpFloat-height -- cpFloat )

\ // Calculate the moment of inertia for a solid box.
function: cpMomentForBox2 ( cpFloat-m, cpBB-box -- cpFloat )

\ // Calculate the convex hull of a given set of points. Returns the count of points in the hull.
\ // @c result must be a pointer to a @c cpVect array with at least @c count elements. If @c verts == @c result, then @c verts will be reduced inplace.
\ // @c first is an optional pointer to an integer to store where the first vertex in the hull came from  ( i.e. verts[first] == result[0])
\ // @c tol is the allowed amount to shrink the hull when simplifying it. A tolerance of 0.0 creates an exact hull.
function: cpConvexHull ( int-count, const-cpVect-*verts, cpVect-*result, int-*first, cpFloat-tol -- int )


\ // Convenience macro to work with cpConvexHull.
\ // @c count and @c verts is the input array passed to cpConvexHull ( ).
\ // @c count_var and @c verts_var are the names of the variables the macro creates to store the result.
\ // The output vertex array is allocated on the stack using alloca ( ) so it will be freed automatically, but cannot be returned from the current scope.
\ #define CP_CONVEX_HULL ( __count__, __verts__, __count_var__, __verts_var__) \
\ cpVect *__verts_var__ =  ( cpVect *)alloca ( __count__*sizeof ( cpVect) -- ) \
\ int __count_var__ = cpConvexHull ( __count__, __verts__, __verts_var__, NULL, 0.0 -- ) \

\ // Returns the closest point on the line segment ab, to the point p.
\ static inline cpVect
\ cpClosestPointOnSegment ( const cpVect p, const cpVect a, const cpVect b)
\ {
\ 	cpVect delta = cpvsub ( a, b -- )
\ 	cpFloat t = cpfclamp01 ( cpvdot ( delta, cpvsub ( p, b))/cpvlengthsq ( delta) -- )
\ 	return cpvadd ( b, cpvmult ( delta, t) -- )
\ }


\ cpArbiter.h
\  Arbiters tracks pairs of colliding shapes.
\  Used extensively in callbacks to get info on collisions.

\ //  Get the restitution  ( elasticity) that will be applied to the pair of colliding objects.
function: cpArbiterGetRestitution ( const-cpArbiter-*arb -- cpFloat )
\ //  Override the restitution  ( elasticity) that will be applied to the pair of colliding objects.
function: cpArbiterSetRestitution ( cpArbiter-*arb, cpFloat-restitution -- )
\ //  Get the friction coefficient that will be applied to the pair of colliding objects.
function: cpArbiterGetFriction ( const-cpArbiter-*arb -- cpFloat )
\ //  Override the friction coefficient that will be applied to the pair of colliding objects.
function: cpArbiterSetFriction ( cpArbiter-*arb, cpFloat-friction -- )

\ // Get the relative surface velocity of the two shapes in contact.
function: cpArbiterGetSurfaceVelocity ( cpArbiter-*arb -- cpVect )

\ // Override the relative surface velocity of the two shapes in contact.
\ // By default this is calculated to be the difference of the two surface velocities clamped to the tangent plane.
function: cpArbiterSetSurfaceVelocity ( cpArbiter-*arb, cpVect-vr -- )

\ //  Get the user data pointer associated with this pair of colliding objects.
function: cpArbiterGetUserData ( const-cpArbiter-*arb -- cpDataPointer )
\ //  Set a user data point associated with this pair of colliding objects.
\ //  If you need to perform any cleanup for this pointer, you must do it yourself, in the separate callback for instance.
function: cpArbiterSetUserData ( cpArbiter-*arb, cpDataPointer-userData -- )

\ //  Calculate the total impulse including the friction that was applied by this arbiter.
\ //  This function should only be called from a post-solve, post-step or cpBodyEachArbiter callback.
function: cpArbiterTotalImpulse ( const-cpArbiter-*arb -- cpVect )
\ //  Calculate the amount of energy lost in a collision including static, but not dynamic friction.
\ //  This function should only be called from a post-solve, post-step or cpBodyEachArbiter callback.
function: cpArbiterTotalKE ( const-cpArbiter-*arb -- cpFloat )

\ //  Mark a collision pair to be ignored until the two objects separate.
\ //  Pre-solve and post-solve callbacks will not be called, but the separate callback will be called.
function: cpArbiterIgnore ( cpArbiter-*arb -- cpBool )

\ //  Return the colliding shapes involved for this arbiter.
\ //  The order of their cpSpace.collision_type values will match
\ //  the order set when the collision handler was registered.
function: cpArbiterGetShapes ( const-cpArbiter-*arb, cpShape-**a, cpShape-**b -- )

\ //  A macro shortcut for defining and retrieving the shapes from an arbiter.
\ #define CP_ARBITER_GET_SHAPES ( __arb__, __a__, __b__) cpShape *__a__, *__b__; cpArbiterGetShapes ( __arb__, &__a__, &__b__ -- )

\ //  Return the colliding bodies involved for this arbiter.
\ //  The order of the cpSpace.collision_type the bodies are associated with values will match
\ //  the order set when the collision handler was registered.
function: cpArbiterGetBodies ( const-cpArbiter-*arb, cpBody-**a, cpBody-**b -- )

\ //  A macro shortcut for defining and retrieving the bodies from an arbiter.
\ #define CP_ARBITER_GET_BODIES ( __arb__, __a__, __b__) cpBody *__a__, *__b__; cpArbiterGetBodies ( __arb__, &__a__, &__b__ -- )

\ //  A struct that wraps up the important collision data for an arbiter.
0 \ struct cpContactPointSet {
	\ //  The number of contact points in the set.
	xvar cpContactPointSet-count \ int count;

	\ //  The normal of the collision.
	/cpVect xfield cpContactPointSet-normal \ cpVect normal;

	0 xfield cpContactPointSet-contacts
struct /cpContactPointSet \ };

0
  /cpVect xfield pointA
  /cpVect xfield pointB
  xfloat contactDistance
struct /cpContact

: cpContact  ( cpContactPointSet n -- cpContact )  /cpContact * + ;


\ //  Return a contact set from an arbiter.
function: cpArbiterGetContactPointSet ( const-cpArbiter-*arb -- cpContactPointSet )

\ //  Replace the contact point set for an arbiter.
\ //  This can be a very powerful feature, but use it with caution!
function: cpArbiterSetContactPointSet ( cpArbiter-*arb, cpContactPointSet-*set -- )

\ //  Returns true if this is the first step a pair of objects started colliding.
function: cpArbiterIsFirstContact ( const-cpArbiter-*arb -- cpBool )
\ //  Returns true if the separate callback is due to a shape being removed from the space.
function: cpArbiterIsRemoval ( const-cpArbiter-*arb -- cpBool )

\ //  Get the number of contact points for this arbiter.
function: cpArbiterGetCount ( const-cpArbiter-*arb -- int )
\ //  Get the normal of the collision.
function: cpArbiterGetNormal ( const-cpArbiter-*arb -- cpVect )
\ //  Get the position of the @c ith contact point on the surface of the first shape.
function: cpArbiterGetPointA ( const-cpArbiter-*arb, int-i -- cpVect )
\ //  Get the position of the @c ith contact point on the surface of the second shape.
function: cpArbiterGetPointB ( const-cpArbiter-*arb, int-i -- cpVect )
\ //  Get the depth of the @c ith contact point.
function: cpArbiterGetDepth ( const-cpArbiter-*arb, int-i -- cpFloat )

\ //  If you want a custom callback to invoke the wildcard callback for the first collision type, you must call this function explicitly.
\ //  You must decide how to handle the wildcard's return value since it may disagree with the other wildcard handler's return value or your own.
function: cpArbiterCallWildcardBeginA ( cpArbiter-*arb, cpSpace-*space -- cpBool )
\ //  If you want a custom callback to invoke the wildcard callback for the second collision type, you must call this function explicitly.
\ //  You must decide how to handle the wildcard's return value since it may disagree with the other wildcard handler's return value or your own.
function: cpArbiterCallWildcardBeginB ( cpArbiter-*arb, cpSpace-*space -- cpBool )

\ //  If you want a custom callback to invoke the wildcard callback for the first collision type, you must call this function explicitly.
\ //  You must decide how to handle the wildcard's return value since it may disagree with the other wildcard handler's return value or your own.
function: cpArbiterCallWildcardPreSolveA ( cpArbiter-*arb, cpSpace-*space -- cpBool )
\ //  If you want a custom callback to invoke the wildcard callback for the second collision type, you must call this function explicitly.
\ //  You must decide how to handle the wildcard's return value since it may disagree with the other wildcard handler's return value or your own.
function: cpArbiterCallWildcardPreSolveB ( cpArbiter-*arb, cpSpace-*space -- cpBool )

\ //  If you want a custom callback to invoke the wildcard callback for the first collision type, you must call this function explicitly.
function: cpArbiterCallWildcardPostSolveA ( cpArbiter-*arb, cpSpace-*space -- )
\ //  If you want a custom callback to invoke the wildcard callback for the second collision type, you must call this function explicitly.
function: cpArbiterCallWildcardPostSolveB ( cpArbiter-*arb, cpSpace-*space -- )

\ //  If you want a custom callback to invoke the wildcard callback for the first collision type, you must call this function explicitly.
function: cpArbiterCallWildcardSeparateA ( cpArbiter-*arb, cpSpace-*space -- )
\ //  If you want a custom callback to invoke the wildcard callback for the second collision type, you must call this function explicitly.
function: cpArbiterCallWildcardSeparateB ( cpArbiter-*arb, cpSpace-*space -- )



\ cpBody.h
\  holds info like mass and shapes can be attached to them

\ typedef enum cpBodyType {
	\ //  A dynamic body is one that is affected by gravity, forces, and collisions.
	\ //  This is the default body type.
0
enum	CP_BODY_TYPE_DYNAMIC
	\ //  A kinematic body is an infinite mass, user controlled body that is not affected by gravity, forces or collisions.
	\ //  Instead the body only moves based on it's velocity.
	\ //  Dynamic bodies collide normally with kinematic bodies, though the kinematic body will be unaffected.
	\ //  Collisions between two kinematic bodies, or a kinematic body and a static body produce collision callbacks, but no collision response.
enum		CP_BODY_TYPE_KINEMATIC
	\ //  A static body is a body that never  ( or rarely) moves. If you move a static body, you must call one of the cpSpaceReindex* ( ) functions.
	\ //  Chipmunk uses this information to optimize the collision detection.
	\ //  Static bodies do not produce collision callbacks when colliding with other static bodies.
enum		CP_BODY_TYPE_STATIC
drop \ } cpBodyType;



\ //  Rigid body velocity update function type.
\ \ typedef void  ( *cpBodyVelocityFunc) ( cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt -- )
\ //  Rigid body position update function type.
\ \ typedef void  ( *cpBodyPositionFunc) ( cpBody *body, cpFloat dt -- )

\ //  Allocate a cpBody.
function: cpBodyAlloc ( -- cpBody* )
\ //  Initialize a cpBody.
function: cpBodyInit ( cpBody-*body, cpFloat-mass, cpFloat-moment -- cpBody* )
\ //  Allocate and initialize a cpBody.
function: cpBodyNew ( cpFloat-mass, cpFloat-moment -- cpBody* )

\ //  Allocate and initialize a cpBody, and set it as a kinematic body.
function: cpBodyNewKinematic ( -- cpBody* )
\ //  Allocate and initialize a cpBody, and set it as a static body.
function: cpBodyNewStatic ( -- cpBody* )

\ //  Destroy a cpBody.
function: cpBodyDestroy ( cpBody-*body -- )
\ //  Destroy and free a cpBody.
function: cpBodyFree ( cpBody-*body -- )

\ // Defined in cpSpace.c
\ //  Wake up a sleeping or idle body.
function: cpBodyActivate ( cpBody-*body -- )
\ //  Wake up any sleeping or idle bodies touching a static body.
function: cpBodyActivateStatic ( cpBody-*body, cpShape-*filter -- )

\ //  Force a body to fall asleep immediately.
function: cpBodySleep ( cpBody-*body -- )
\ //  Force a body to fall asleep immediately along with other bodies in a group.
function: cpBodySleepWithGroup ( cpBody-*body, cpBody-*group -- )

\ //  Returns true if the body is sleeping.
function: cpBodyIsSleeping ( const-cpBody-*body -- cpBool )

\ //  Get the type of the body.
function: cpBodyGetType ( cpBody-*body -- cpBodyType )
\ //  Set the type of the body.
function: cpBodySetType ( cpBody-*body, cpBodyType-type -- )

\ //  Get the space this body is added to.
function: cpBodyGetSpace ( const-cpBody-*body -- cpSpace* )

\ //  Get the mass of the body.
function: cpBodyGetMass ( const-cpBody-*body -- cpFloat )
\ //  Set the mass of the body.
function: cpBodySetMass ( cpBody-*body, cpFloat-m -- )

\ //  Get the moment of inertia of the body.
function: cpBodyGetMoment ( const-cpBody-*body -- cpFloat )
\ //  Set the moment of inertia of the body.
function: cpBodySetMoment ( cpBody-*body, cpFloat-i -- )

\ //  Set the position of a body.
function: cpBodyGetPosition ( const-cpBody-*body -- cpVect )
\ //  Set the position of the body.
function: cpBodySetPosition ( cpBody-*body, cpVect-pos -- )

\ //  Get the offset of the center of gravity in body local coordinates.
function: cpBodyGetCenterOfGravity ( const-cpBody-*body -- cpVect )
\ //  Set the offset of the center of gravity in body local coordinates.
function: cpBodySetCenterOfGravity ( cpBody-*body, cpVect-cog -- )

\ //  Get the velocity of the body.
function: cpBodyGetVelocity ( const-cpBody-*body -- cpVect )
\ //  Set the velocity of the body.
function: cpBodySetVelocity ( cpBody-*body, cpVect-velocity -- )

\ //  Get the force applied to the body for the next time step.
function: cpBodyGetForce ( const-cpBody-*body -- cpVect )
\ //  Set the force applied to the body for the next time step.
function: cpBodySetForce ( cpBody-*body, cpVect-force -- )

\ //  Get the angle of the body.
function: cpBodyGetAngle ( const-cpBody-*body -- cpFloat )
\ //  Set the angle of a body.
function: cpBodySetAngle ( cpBody-*body, cpFloat-a -- )

\ //  Get the angular velocity of the body.
function: cpBodyGetAngularVelocity ( const-cpBody-*body -- cpFloat )
\ //  Set the angular velocity of the body.
function: cpBodySetAngularVelocity ( cpBody-*body, cpFloat-angularVelocity -- )

\ //  Get the torque applied to the body for the next time step.
function: cpBodyGetTorque ( const-cpBody-*body -- cpFloat )
\ //  Set the torque applied to the body for the next time step.
function: cpBodySetTorque ( cpBody-*body, cpFloat-torque -- )

\ //  Get the rotation vector of the body.  ( The x basis vector of it's transform.)
function: cpBodyGetRotation ( const-cpBody-*body -- cpVect )

\ //  Get the user data pointer assigned to the body.
function: cpBodyGetUserData ( const-cpBody-*body -- cpDataPointer )
\ //  Set the user data pointer assigned to the body.
function: cpBodySetUserData ( cpBody-*body, cpDataPointer-userData -- )

\ //  Set the callback used to update a body's velocity.
function: cpBodySetVelocityUpdateFunc ( cpBody-*body, cpBodyVelocityFunc-velocityFunc -- )
\ //  Set the callback used to update a body's position.
\ //  NOTE: It's not generally recommended to override this unless you call the default position update function.
function: cpBodySetPositionUpdateFunc ( cpBody-*body, cpBodyPositionFunc-positionFunc -- )

\ //  Default velocity integration function..
function: cpBodyUpdateVelocity ( cpBody-*body, cpVect-gravity, cpFloat-damping, cpFloat-dt -- )
\ //  Default position integration function.
function: cpBodyUpdatePosition ( cpBody-*body, cpFloat-dt -- )

\ //  Convert body relative/local coordinates to absolute/world coordinates.
function: cpBodyLocalToWorld ( const-cpBody-*body, const-cpVect-point -- cpVect )
\ //  Convert body absolute/world coordinates to  relative/local coordinates.
function: cpBodyWorldToLocal ( const-cpBody-*body, const-cpVect-point -- cpVect )

\ //  Apply a force to a body. Both the force and point are expressed in world coordinates.
function: cpBodyApplyForceAtWorldPoint ( cpBody-*body, cpVect-force, cpVect-point -- )
\ //  Apply a force to a body. Both the force and point are expressed in body local coordinates.
function: cpBodyApplyForceAtLocalPoint ( cpBody-*body, cpVect-force, cpVect-point -- )

\ //  Apply an impulse to a body. Both the impulse and point are expressed in world coordinates.
function: cpBodyApplyImpulseAtWorldPoint ( cpBody-*body, cpVect-impulse, cpVect-point -- )
\ //  Apply an impulse to a body. Both the impulse and point are expressed in body local coordinates.
function: cpBodyApplyImpulseAtLocalPoint ( cpBody-*body, cpVect-impulse, cpVect-point -- )

\ //  Get the velocity on a body  ( in world units) at a point on the body in world coordinates.
function: cpBodyGetVelocityAtWorldPoint ( const-cpBody-*body, cpVect-point -- cpVect )
\ //  Get the velocity on a body  ( in world units) at a point on the body in local coordinates.
function: cpBodyGetVelocityAtLocalPoint ( const-cpBody-*body, cpVect-point -- cpVect )

\ //  Get the amount of kinetic energy contained by the body.
function: cpBodyKineticEnergy ( const-cpBody-*body -- cpFloat )

\ //  Body/shape iterator callback function type.
\ \ typedef void  ( *cpBodyShapeIteratorFunc) ( cpBody *body, cpShape *shape, void *data -- )
\ //  Call @c func once for each shape attached to @c body and added to the space.
function: cpBodyEachShape ( cpBody-*body, cpBodyShapeIteratorFunc-func, void-*data -- )

\ //  Body/constraint iterator callback function type.
\ \ typedef void  ( *cpBodyConstraintIteratorFunc) ( cpBody *body, cpConstraint *constraint, void *data -- )
\ //  Call @c func once for each constraint attached to @c body and added to the space.
function: cpBodyEachConstraint ( cpBody-*body, cpBodyConstraintIteratorFunc-func, void-*data -- )

\ //  Body/arbiter iterator callback function type.
\ \ typedef void  ( *cpBodyArbiterIteratorFunc) ( cpBody *body, cpArbiter *arbiter, void *data -- )
\ //  Call @c func once for each arbiter that is currently active on the body.
function: cpBodyEachArbiter ( cpBody-*body, cpBodyArbiterIteratorFunc-func, void-*data -- )



\ cpShape.h
\ //  Point query info struct.
\ typedef struct cpPointQueryInfo {
	\ //  The nearest shape, NULL if no shape was within range.
0
	xvar cpShape-shape \ const cpShape *shape;
	\ //  The closest point on the shape's surface.  ( in world space coordinates)
	/cpVect xfield cpPointQueryInfo-point \  cpVect point;
	\ //  The distance to the point. The distance is negative if the point is inside the shape.
	xfloat cpPointQueryInfo-distance \ cpFloat distance;
	\ //  The gradient of the signed distance function.
	\ //  The value should be similar to info.p/info.d, but accurate even for very small values of info.d.
	/cpVect xfield cpPointQueryInfo-gradient \ cpVect gradient;
struct /cpPointQueryInfo
\ } cpPointQueryInfo;

\ //  Segment query info struct.
\ typedef struct cpSegmentQueryInfo {
0
	\ //  The shape that was hit, or NULL if no collision occured.
	xvar cpSegmentQueryInfo-shape \ const cpShape *shape;
	\ //  The point of impact.
	/cpVect xfield cpSegmentQueryInfo-point \ cpVect point;
	\ //  The normal of the surface hit.
	/cpVect xfield cpSegmentQueryInfo-normal \ cpVect normal;
	\ //  The normalized distance along the query segment in the range [0, 1].
	xfloat cpSegmentQueryInfo-alpha \ cpFloat alpha;
struct /cpSegmentQueryInfo

\ //  Fast collision filtering type that is used to determine if two objects collide before calling collision or query callbacks.
\ typedef struct cpShapeFilter {
0
	\ //  Two objects with the same non-zero group value do not collide.
	\ //  This is generally used to group objects in a composite object together to disable self collisions.
	xvar cpShapeFilter-group \ cpGroup group;
	\ //  A bitmask of user definable categories that this object belongs to.
	\ //  The category/mask combinations of both objects in a collision must agree for a collision to occur.
	xvar cpShapeFilter-categories \ cpBitmask categories;
	\ //  A bitmask of user definable category types that this object object collides with.
	\ //  The category/mask combinations of both objects in a collision must agree for a collision to occur.
	xvar cpShapeFilter-mask \ cpBitmask mask;
struct /cpShapeFilter


\ //  Collision filter value for a shape that will collide with anything except CP_SHAPE_FILTER_NONE.
\ static const cpShapeFilter CP_SHAPE_FILTER_ALL = {CP_NO_GROUP, CP_ALL_CATEGORIES, CP_ALL_CATEGORIES};
create CP_SHAPE_FILTER_ALL  0 , 0 , 0 ,

\ //  Collision filter value for a shape that does not collide with anything.
\ static const cpShapeFilter CP_SHAPE_FILTER_NONE = {CP_NO_GROUP, ~CP_ALL_CATEGORIES, ~CP_ALL_CATEGORIES};
create CP_SHAPE_FILTER_NONE 0 , -1 , -1 ,

\ //  Destroy a shape.
function: cpShapeDestroy ( cpShape-*shape -- )
\ //  Destroy and Free a shape.
function: cpShapeFree ( cpShape-*shape -- )

\ //  Update, cache and return the bounding box of a shape based on the body it's attached to.
function: cpShapeCacheBB ( cpShape-*shape -- cpBB )
\ //  Update, cache and return the bounding box of a shape with an explicit transformation.
function: cpShapeUpdate ( cpShape-*shape, cpTransform-transform -- cpBB )

\ //  Perform a nearest point query. It finds the closest point on the surface of shape to a specific point.
\ //  The value returned is the distance between the points. A negative distance means the point is inside the shape.
function: cpShapePointQuery ( const-cpShape-*shape, cpVect-p, cpPointQueryInfo-*out -- cpFloat )

\ //  Perform a segment query against a shape. @c info must be a pointer to a valid cpSegmentQueryInfo structure.
function: cpShapeSegmentQuery ( const-cpShape-*shape, cpVect-a, cpVect-b, cpFloat-radius, cpSegmentQueryInfo-*info -- cpBool )

\ //  Return contact information about two shapes.
function: cpShapesCollide ( const-cpShape-*a, const-cpShape-*b -- cpContactPointSet )

\ //  The cpSpace this body is added to.
function: cpShapeGetSpace ( const-cpShape-*shape -- cpSpace* )

\ //  The cpBody this shape is connected to.
function: cpShapeGetBody ( const-cpShape-*shape -- cpBody* )
\ //  Set the cpBody this shape is connected to.
\ //  Can only be used if the shape is not currently added to a space.
function: cpShapeSetBody ( cpShape-*shape, cpBody-*body -- )

\ //  Get the mass of the shape if you are having Chipmunk calculate mass properties for you.
function: cpShapeGetMass ( cpShape-*shape -- cpFloat )
\ //  Set the mass of this shape to have Chipmunk calculate mass properties for you.
function: cpShapeSetMass ( cpShape-*shape, cpFloat-mass -- )

\ //  Get the density of the shape if you are having Chipmunk calculate mass properties for you.
function: cpShapeGetDensity ( cpShape-*shape -- cpFloat )
\ //  Set the density  of this shape to have Chipmunk calculate mass properties for you.
function: cpShapeSetDensity ( cpShape-*shape, cpFloat-density -- )

\ //  Get the calculated moment of inertia for this shape.
function: cpShapeGetMoment ( cpShape-*shape -- cpFloat )
\ //  Get the calculated area of this shape.
function: cpShapeGetArea ( cpShape-*shape -- cpFloat )
\ //  Get the centroid of this shape.
function: cpShapeGetCenterOfGravity ( cpShape-*shape -- cpVect )

\ //  Get the bounding box that contains the shape given it's current position and angle.
function: cpShapeGetBB ( const-cpShape-*shape -- cpBB )

\ //  Get if the shape is set to be a sensor or not.
function: cpShapeGetSensor ( const-cpShape-*shape -- cpBool )
\ //  Set if the shape is a sensor or not.
function: cpShapeSetSensor ( cpShape-*shape, cpBool-sensor -- )

\ //  Get the elasticity of this shape.
function: cpShapeGetElasticity ( const-cpShape-*shape -- cpFloat )
\ //  Set the elasticity of this shape.
function: cpShapeSetElasticity ( cpShape-*shape, cpFloat-elasticity -- )

\ //  Get the friction of this shape.
function: cpShapeGetFriction ( const-cpShape-*shape -- cpFloat )
\ //  Set the friction of this shape.
function: cpShapeSetFriction ( cpShape-*shape, cpFloat-friction -- )

\ //  Get the surface velocity of this shape.
function: cpShapeGetSurfaceVelocity ( const-cpShape-*shape -- cpVect )
\ //  Set the surface velocity of this shape.
function: cpShapeSetSurfaceVelocity ( cpShape-*shape, cpVect-surfaceVelocity -- )

\ //  Get the user definable data pointer of this shape.
function: cpShapeGetUserData ( const-cpShape-*shape -- cpDataPointer )
\ //  Set the user definable data pointer of this shape.
function: cpShapeSetUserData ( cpShape-*shape, cpDataPointer-userData -- )

\ //  Set the collision type of this shape.
function: cpShapeGetCollisionType ( const-cpShape-*shape -- cpCollisionType )
\ //  Get the collision type of this shape.
function: cpShapeSetCollisionType ( cpShape-*shape, cpCollisionType-collisionType -- )

\ //  Get the collision filtering parameters of this shape.
function: cpShapeGetFilter ( const-cpShape-*shape -- cpShapeFilter )
\ //  Set the collision filtering parameters of this shape.
function: cpShapeSetFilter ( cpShape-*shape, cpShapeFilter-filter -- )


\ //  @}
\ //  @defgroup cpCircleShape cpCircleShape

\ //  Allocate a circle shape.
function: cpCircleShapeAlloc ( -- cpCircleShape* )
\ //  Initialize a circle shape.
function: cpCircleShapeInit ( cpCircleShape-*circle, cpBody-*body, cpFloat-radius, cpVect-offset -- cpCircleShape* )
\ //  Allocate and initialize a circle shape.
function: cpCircleShapeNew ( cpBody-*body, cpFloat-radius, cpVect-offset -- cpShape* )

\ //  Get the offset of a circle shape.
function: cpCircleShapeGetOffset ( const-cpShape-*shape -- cpVect )
\ //  Get the radius of a circle shape.
function: cpCircleShapeGetRadius ( const-cpShape-*shape -- cpFloat )

\ //  @}
\ //  @defgroup cpSegmentShape cpSegmentShape

\ //  Allocate a segment shape.
function: cpSegmentShapeAlloc ( -- cpSegmentShape* )
\ //  Initialize a segment shape.
function: cpSegmentShapeInit ( cpSegmentShape-*seg, cpBody-*body, cpVect-a, cpVect-b, cpFloat-radius -- cpSegmentShape* )
\ //  Allocate and initialize a segment shape.
function: cpSegmentShapeNew ( cpBody-*body, cpVect-a, cpVect-b, cpFloat-radius -- cpShape* )

\ //  Let Chipmunk know about the geometry of adjacent segments to avoid colliding with endcaps.
function: cpSegmentShapeSetNeighbors ( cpShape-*shape, cpVect-prev, cpVect-next -- )

\ //  Get the first endpoint of a segment shape.
function: cpSegmentShapeGetA ( const-cpShape-*shape -- cpVect )
\ //  Get the second endpoint of a segment shape.
function: cpSegmentShapeGetB ( const-cpShape-*shape -- cpVect )
\ //  Get the normal of a segment shape.
function: cpSegmentShapeGetNormal ( const-cpShape-*shape -- cpVect )
\ //  Get the first endpoint of a segment shape.
function: cpSegmentShapeGetRadius ( const-cpShape-*shape -- cpFloat )


\ cpPolyShape.h
\  Polygon shapes.

\ //  Allocate a polygon shape.
function: cpPolyShapeAlloc ( -- cpPolyShape* )
\ //  Initialize a polygon shape with rounded corners.
\ //  A convex hull will be created from the vertexes.
function: cpPolyShapeInit ( cpPolyShape-*poly, cpBody-*body, int-count, const-cpVect-*verts, cpTransform-transform, cpFloat-radius -- cpPolyShape* )
\ //  Initialize a polygon shape with rounded corners.
\ //  The vertexes must be convex with a counter-clockwise winding.
function: cpPolyShapeInitRaw ( cpPolyShape-*poly, cpBody-*body, int-count, const cpVect-*verts, cpFloat-radius -- cpPolyShape* )
\ //  Allocate and initialize a polygon shape with rounded corners.
\ //  A convex hull will be created from the vertexes.
function: cpPolyShapeNew ( cpBody-*body, int-count, const-cpVect-*verts, cpTransform-transform, cpFloat-radius -- cpShape* )
\ //  Allocate and initialize a polygon shape with rounded corners.
\ //  The vertexes must be convex with a counter-clockwise winding.
function: cpPolyShapeNewRaw ( cpBody-*body, int-count, const-cpVect-*verts, cpFloat-radius -- cpShape* )

\ //  Initialize a box shaped polygon shape with rounded corners.
function: cpBoxShapeInit ( cpPolyShape-*poly, cpBody-*body, cpFloat-width, cpFloat-height, cpFloat-radius -- cpPolyShape* )
\ //  Initialize an offset box shaped polygon shape with rounded corners.
function: cpBoxShapeInit2 ( cpPolyShape-*poly, cpBody-*body, cpBB-box, cpFloat-radius -- cpPolyShape* )
\ //  Allocate and initialize a box shaped polygon shape.
function: cpBoxShapeNew ( cpBody-*body, cpFloat-width, cpFloat-height, cpFloat-radius -- cpShape* )
\ //  Allocate and initialize an offset box shaped polygon shape.
function: cpBoxShapeNew2 ( cpBody-*body, cpBB-box, cpFloat-radius -- cpShape* )

\ //  Get the number of verts in a polygon shape.
function: cpPolyShapeGetCount ( const-cpShape-*shape -- int )
\ //  Get the @c ith vertex of a polygon shape.
function: cpPolyShapeGetVert ( const-cpShape-*shape, int-index -- cpVect )
\ //  Get the radius of a polygon shape.
function: cpPolyShapeGetRadius ( const-cpShape-*shape -- cpFloat )


\ cpConstraint.h
\ //  Callback function type that gets called before solving a joint.
\ typedef void  ( *cpConstraintPreSolveFunc) ( cpConstraint *constraint, cpSpace *space -- )
\ //  Callback function type that gets called after solving a joint.
\ typedef void  ( *cpConstraintPostSolveFunc) ( cpConstraint *constraint, cpSpace *space -- )

\ //  Destroy a constraint.
function: cpConstraintDestroy ( cpConstraint-*constraint -- )
\ //  Destroy and free a constraint.
function: cpConstraintFree ( cpConstraint-*constraint -- )

\ //  Get the cpSpace this constraint is added to.
function: cpConstraintGetSpace ( const-cpConstraint-*constraint -- cpSpace* )

\ //  Get the first body the constraint is attached to.
function: cpConstraintGetBodyA ( const-cpConstraint-*constraint -- cpBody* )

\ //  Get the second body the constraint is attached to.
function: cpConstraintGetBodyB ( const-cpConstraint-*constraint -- cpBody* )

\ //  Get the maximum force that this constraint is allowed to use.
function: cpConstraintGetMaxForce ( const-cpConstraint-*constraint -- cpFloat )
\ //  Set the maximum force that this constraint is allowed to use.  ( defaults to INFINITY)
function: cpConstraintSetMaxForce ( cpConstraint-*constraint, cpFloat-maxForce -- )

\ //  Get rate at which joint error is corrected.
function: cpConstraintGetErrorBias ( const-cpConstraint-*constraint -- cpFloat )
\ //  Set rate at which joint error is corrected.
\ //  Defaults to pow ( 1.0 - 0.1, 60.0) meaning that it will
\ //  correct 10% of the error every 1/60th of a second.
function: cpConstraintSetErrorBias ( cpConstraint-*constraint, cpFloat-errorBias -- )

\ //  Get the maximum rate at which joint error is corrected.
function: cpConstraintGetMaxBias ( const-cpConstraint-*constraint -- cpFloat )
\ //  Set the maximum rate at which joint error is corrected.  ( defaults to INFINITY)
function: cpConstraintSetMaxBias ( cpConstraint-*constraint, cpFloat-maxBias -- )

\ //  Get if the two bodies connected by the constraint are allowed to collide or not.
function: cpConstraintGetCollideBodies ( const-cpConstraint-*constraint -- cpBool )
\ //  Set if the two bodies connected by the constraint are allowed to collide or not.  ( defaults to cpFalse)
function: cpConstraintSetCollideBodies ( cpConstraint-*constraint, cpBool-collideBodies -- )

\ //  Get the pre-solve function that is called before the solver runs.
function: cpConstraintGetPreSolveFunc ( const-cpConstraint-*constraint -- cpConstraintPreSolveFunc )
\ //  Set the pre-solve function that is called before the solver runs.
function: cpConstraintSetPreSolveFunc ( cpConstraint-*constraint, cpConstraintPreSolveFunc-preSolveFunc -- )

\ //  Get the post-solve function that is called before the solver runs.
function: cpConstraintGetPostSolveFunc ( const-cpConstraint-*constraint -- cpConstraintPostSolveFunc )
\ //  Set the post-solve function that is called before the solver runs.
function: cpConstraintSetPostSolveFunc ( cpConstraint-*constraint, cpConstraintPostSolveFunc-postSolveFunc -- )

\ //  Get the user definable data pointer for this constraint
function: cpConstraintGetUserData ( const-cpConstraint-*constraint -- cpDataPointer )
\ //  Set the user definable data pointer for this constraint
function: cpConstraintSetUserData ( cpConstraint-*constraint, cpDataPointer-userData -- )

\ //  Get the last impulse applied by this constraint.
function: cpConstraintGetImpulse ( cpConstraint-*constraint -- cpFloat )


\ TODO: convert these constraint bindings:
\ #include "cpPinJoint.h"
\ #include "cpSlideJoint.h"
\ #include "cpPivotJoint.h"
\ #include "cpGrooveJoint.h"
\ #include "cpDampedSpring.h"
\ #include "cpDampedRotarySpring.h"
\ #include "cpRotaryLimitJoint.h"
\ #include "cpRatchetJoint.h"
\ #include "cpGearJoint.h"
\ #include "cpSimpleMotor.h"


\ cpSpace.h
\  The struct to which you add bodies.

\ //  Collision begin event function callback type.
\ //  Returning false from a begin callback causes the collision to be ignored until
\ //  the the separate callback is called when the objects stop colliding.
\ typedef cpBool  ( *cpCollisionBeginFunc) ( cpArbiter *arb, cpSpace *space, cpDataPointer userData -- )

\ //  Collision pre-solve event function callback type.
\ //  Returning false from a pre-step callback causes the collision to be ignored until the next step.
\ typedef cpBool  ( *cpCollisionPreSolveFunc) ( cpArbiter *arb, cpSpace *space, cpDataPointer userData -- )

\ //  Collision post-solve event function callback type.
\ typedef void  ( *cpCollisionPostSolveFunc) ( cpArbiter *arb, cpSpace *space, cpDataPointer userData -- )

\ //  Collision separate event function callback type.
\ typedef void  ( *cpCollisionSeparateFunc) ( cpArbiter *arb, cpSpace *space, cpDataPointer userData -- )

\ //  Struct that holds function callback pointers to configure custom collision handling.
\ //  Collision handlers have a pair of types; when a collision occurs between two shapes that have these types, the collision handler functions are triggered.
\ struct cpCollisionHandler {
	\ //  Collision type identifier of the first shape that this handler recognizes.
	\ //  In the collision handler callback, the shape with this type will be the first argument. Read only.
0
	xvar typeA \ const cpCollisionType typeA;
	\ //  Collision type identifier of the second shape that this handler recognizes.
	\ //  In the collision handler callback, the shape with this type will be the second argument. Read only.
	xvar typeB \ const cpCollisionType typeB;
	\ //  This function is called when two shapes with types that match this collision handler begin colliding.
	xvar beginFunc \ cpCollisionBeginFunc beginFunc;
	\ //  This function is called each step when two shapes with types that match this collision handler are colliding.
	\ //  It's called before the collision solver runs so that you can affect a collision's outcome.
	xvar preSolveFunc \ cpCollisionPreSolveFunc preSolveFunc;
	\ //  This function is called each step when two shapes with types that match this collision handler are colliding.
	\ //  It's called after the collision solver runs so that you can read back information about the collision to trigger events in your game.
	xvar postSolveFunc \ cpCollisionPostSolveFunc postSolveFunc;
	\ //  This function is called when two shapes with types that match this collision handler stop colliding.
	xvar separateFunc \ cpCollisionSeparateFunc separateFunc;
	\ //  This is a user definable context pointer that is passed to all of the collision handler functions.
	xvar userData \ cpDataPointer userData;
\ };
struct /cpCollisionHandler

\ // TODO: Make timestep a parameter?


\ Memory and Initialization

\ //  Allocate a cpSpace.
function: cpSpaceAlloc ( -- cpSpace* )
\ //  Initialize a cpSpace.
function: cpSpaceInit ( *space -- cpSpace* )
\ //  Allocate and initialize a cpSpace.
function: cpSpaceNew ( -- cpSpace* )

\ //  Destroy a cpSpace.
function: cpSpaceDestroy ( cpSpace-*space -- )
\ //  Destroy and free a cpSpace.
function: cpSpaceFree ( cpSpace-*space -- )


\ Properties

\ //  Number of iterations to use in the impulse solver to solve contacts and other constraints.
function: cpSpaceGetIterations ( const-cpSpace-*space -- int )
function: cpSpaceSetIterations ( cpSpace-*space, int-iterations -- )

\ //  Gravity to pass to rigid bodies when integrating velocity.
function: cpSpaceGetGravity ( const-cpSpace-*space -- cpVect )
function: cpSpaceSetGravity ( cpSpace-*space, cpVect-gravity -- )

\ //  Damping rate expressed as the fraction of velocity bodies retain each second.
\ //  A value of 0.9 would mean that each body's velocity will drop 10% per second.
\ //  The default value is 1.0, meaning no damping is applied.
\ //  @note This damping value is different than those of cpDampedSpring and cpDampedRotarySpring.
function: cpSpaceGetDamping ( const-cpSpace-*space -- cpFloat )
function: cpSpaceSetDamping ( cpSpace-*space, cpFloat-damping -- )

\ //  Speed threshold for a body to be considered idle.
\ //  The default value of 0 means to let the space guess a good threshold based on gravity.
function: cpSpaceGetIdleSpeedThreshold ( const-cpSpace-*space -- cpFloat )
function: cpSpaceSetIdleSpeedThreshold ( cpSpace-*space, cpFloat-idleSpeedThreshold -- )

\ //  Time a group of bodies must remain idle in order to fall asleep.
\ //  Enabling sleeping also implicitly enables the the contact graph.
\ //  The default value of INFINITY disables the sleeping algorithm.
function: cpSpaceGetSleepTimeThreshold ( const-cpSpace-*space -- cpFloat )
function: cpSpaceSetSleepTimeThreshold ( cpSpace-*space, cpFloat-sleepTimeThreshold -- )

\ //  Amount of encouraged penetration between colliding shapes.
\ //  Used to reduce oscillating contacts and keep the collision cache warm.
\ //  Defaults to 0.1. If you have poor simulation quality,
\ //  increase this number as much as possible without allowing visible amounts of overlap.
function: cpSpaceGetCollisionSlop ( const-cpSpace-*space -- cpFloat )
function: cpSpaceSetCollisionSlop ( cpSpace-*space, cpFloat-collisionSlop -- )

\ //  Determines how fast overlapping shapes are pushed apart.
\ //  Expressed as a fraction of the error remaining after each second.
\ //  Defaults to pow ( 1.0 - 0.1, 60.0) meaning that Chipmunk fixes 10% of overlap each frame at 60Hz.
function: cpSpaceGetCollisionBias ( const-cpSpace-*space -- cpFloat )
function: cpSpaceSetCollisionBias ( cpSpace-*space, cpFloat-collisionBias -- )

\ //  Number of frames that contact information should persist.
\ //  Defaults to 3. There is probably never a reason to change this value.
function: cpSpaceGetCollisionPersistence ( const-cpSpace-*space -- cpTimestamp )
function: cpSpaceSetCollisionPersistence ( cpSpace-*space, cpTimestamp-collisionPersistence -- )

\ //  User definable data pointer.
\ //  Generally this points to your game's controller or game state
\ //  class so you can access it when given a cpSpace reference in a callback.
function: cpSpaceGetUserData ( const-cpSpace-*space -- cpDataPointer )
function: cpSpaceSetUserData ( cpSpace-*space, cpDataPointer-userData -- )

\ //  The Space provided static body for a given cpSpace.
\ //  This is merely provided for convenience and you are not required to use it.
function: cpSpaceGetStaticBody ( const-cpSpace-*space -- cpBody* )

\ //  Returns the current  ( or most recent) time step used with the given space.
\ //  Useful from callbacks if your time step is not a compile-time global.
function: cpSpaceGetCurrentTimeStep ( const-cpSpace-*space -- cpFloat )

\ //  returns true from inside a callback when objects cannot be added/removed.
function: cpSpaceIsLocked ( cpSpace-*space -- cpBool )


\ Collision Handlers

\ //  Create or return the existing collision handler that is called for all collisions that are not handled by a more specific collision handler.
function: cpSpaceAddDefaultCollisionHandler ( cpSpace-*space -- cpCollisionHandler-* )
\ //  Create or return the existing collision handler for the specified pair of collision types.
\ //  If wildcard handlers are used with either of the collision types, it's the responibility of the custom handler to invoke the wildcard handlers.
function: cpSpaceAddCollisionHandler ( cpSpace-*space, cpCollisionType-a, cpCollisionType-b -- cpCollisionHandler-* )
\ //  Create or return the existing wildcard collision handler for the specified type.
function: cpSpaceAddWildcardHandler ( cpSpace-*space, cpCollisionType-type -- cpCollisionHandler-* )


\ Add/Remove objects

\ //  Add a collision shape to the simulation.
\ //  If the shape is attached to a static body, it will be added as a static shape.
function: cpSpaceAddShape ( cpSpace-*space, cpShape-*shape -- cpShape* )
\ //  Add a rigid body to the simulation.
function: cpSpaceAddBody ( cpSpace-*space, cpBody-*body -- cpBody* )
\ //  Add a constraint to the simulation.
function: cpSpaceAddConstraint ( cpSpace-*space, cpConstraint-*constraint -- cpConstraint* )

\ //  Remove a collision shape from the simulation.
function: cpSpaceRemoveShape ( cpSpace-*space, cpShape-*shape -- )
\ //  Remove a rigid body from the simulation.
function: cpSpaceRemoveBody ( cpSpace-*space, cpBody-*body -- )
\ //  Remove a constraint from the simulation.
function: cpSpaceRemoveConstraint ( cpSpace-*space, cpConstraint-*constraint -- )

\ //  Test if a collision shape has been added to the space.
function: cpSpaceContainsShape ( cpSpace-*space, cpShape-*shape -- cpBool )
\ //  Test if a rigid body has been added to the space.
function: cpSpaceContainsBody ( cpSpace-*space, cpBody-*body -- cpBool )
\ //  Test if a constraint has been added to the space.
function: cpSpaceContainsConstraint ( cpSpace-*space, cpConstraint-*constraint -- cpBool )

\ Post-Step Callbacks

\ //  Post Step callback function type.
\ typedef void  ( *cpPostStepFunc) ( cpSpace *space, void *key, void *data -- )
\ //  Schedule a post-step callback to be called when cpSpaceStep ( ) finishes.
\ //  You can only register one callback per unique value for @c key.
\ //  Returns true only if @c key has never been scheduled before.
\ //  It's possible to pass @c NULL for @c func if you only want to mark @c key as being used.
function: cpSpaceAddPostStepCallback ( cpSpace-*space, cpPostStepFunc-func, void-*key, void-*data -- cpBool )


\ Queries

\ // TODO: Queries and iterators should take a cpSpace parametery.
\ // TODO: They should also be abortable.

\ //  Nearest point query callback function type.
\ typedef void  ( *cpSpacePointQueryFunc) ( cpShape *shape, cpVect point, cpFloat distance, cpVect gradient, void *data -- )
\ //  Query the space at a point and call @c func for each shape found.
function: cpSpacePointQuery ( cpSpace-*space, cpVect-point, cpFloat-maxDistance, cpShapeFilter-filter, cpSpacePointQueryFunc-func, void-*data -- )
\ //  Query the space at a point and return the nearest shape found. Returns NULL if no shapes were found.
function: cpSpacePointQueryNearest ( cpSpace-*space, cpVect-point, cpFloat-maxDistance, cpShapeFilter-filter, cpPointQueryInfo-*out -- cpShape-* )

\ //  Segment query callback function type.
\ typedef void  ( *cpSpaceSegmentQueryFunc) ( cpShape *shape, cpVect point, cpVect normal, cpFloat alpha, void *data -- )
\ //  Perform a directed line segment query  ( like a raycast) against the space calling @c func for each shape intersected.
function: cpSpaceSegmentQuery ( cpSpace-*space, cpVect-start, cpVect-end, cpFloat-radius, cpShapeFilter-filter, cpSpaceSegmentQueryFunc-func, void-*data -- )
\ //  Perform a directed line segment query  ( like a raycast) against the space and return the first shape hit. Returns NULL if no shapes were hit.
function: cpSpaceSegmentQueryFirst ( cpSpace-*space, cpVect-start, cpVect-end, cpFloat-radius, cpShapeFilter-filter, cpSegmentQueryInfo-*out -- cpShape-* )

\ //  Rectangle Query callback function type.
\ typedef void  ( *cpSpaceBBQueryFunc) ( cpShape *shape, void *data -- )
\ //  Perform a fast rectangle query on the space calling @c func for each shape found.
\ //  Only the shape's bounding boxes are checked for overlap, not their full shape.
function: cpSpaceBBQuery ( cpSpace-*space, cpBB-bb, cpShapeFilter-filter, cpSpaceBBQueryFunc-func, void-*data -- )

\ //  Shape query callback function type.
\ typedef void  ( *cpSpaceShapeQueryFunc) ( cpShape *shape, cpContactPointSet *points, void *data -- )
\ //  Query a space for any shapes overlapping the given shape and call @c func for each shape found.
function: cpSpaceShapeQuery ( cpSpace-*space, cpShape-*shape, cpSpaceShapeQueryFunc-func, void-*data -- cpBool )


\ Iteration

\ //  Space/body iterator callback function type.
\ typedef void  ( *cpSpaceBodyIteratorFunc) ( cpBody *body, void *data -- )
\ //  Call @c func for each body in the space.
function: cpSpaceEachBody ( cpSpace-*space, cpSpaceBodyIteratorFunc-func, void-*data -- )

\ //  Space/body iterator callback function type.
\ typedef void  ( *cpSpaceShapeIteratorFunc) ( cpShape *shape, void *data -- )
\ //  Call @c func for each shape in the space.
function: cpSpaceEachShape ( cpSpace-*space, cpSpaceShapeIteratorFunc-func, void-*data -- )

\ //  Space/constraint iterator callback function type.
\ typedef void  ( *cpSpaceConstraintIteratorFunc) ( cpConstraint *constraint, void *data -- )
\ //  Call @c func for each shape in the space.
function: cpSpaceEachConstraint ( cpSpace-*space, cpSpaceConstraintIteratorFunc-func, void-*data -- )


\ Indexing

\ //  Update the collision detection info for the static shapes in the space.
function: cpSpaceReindexStatic ( cpSpace-*space -- )
\ //  Update the collision detection data for a specific shape in the space.
function: cpSpaceReindexShape ( cpSpace-*space, cpShape-*shape -- )
\ //  Update the collision detection data for all shapes attached to a body.
function: cpSpaceReindexShapesForBody ( cpSpace-*space, cpBody-*body -- )

\ //  Switch the space to use a spatial has as it's spatial index.
function: cpSpaceUseSpatialHash ( cpSpace-*space, cpFloat-dim, int-count -- )


\ Time Stepping

\ //  Step the space forward in time by @c dt.
function: cpSpaceStep ( cpSpace-*space, cpFloat-dt -- )


\ Debug API

\ #ifndef CP_SPACE_DISABLE_DEBUG_API

\ //  Color type to use with the space debug drawing API.
\ typedef struct cpSpaceDebugColor {
\ 	float r, g, b, a;
\ } cpSpaceDebugColor;
4 floats constant /cpSpaceDebugColor


\ //  Callback type for a function that draws a filled, stroked circle.
\ typedef void  ( *cpSpaceDebugDrawCircleImpl) ( cpVect pos, cpFloat angle, cpFloat radius, cpSpaceDebugColor outlineColor, cpSpaceDebugColor fillColor, cpDataPointer data -- )
\ //  Callback type for a function that draws a line segment.
\ typedef void  ( *cpSpaceDebugDrawSegmentImpl) ( cpVect a, cpVect b, cpSpaceDebugColor color, cpDataPointer data -- )
\ //  Callback type for a function that draws a thick line segment.
\ typedef void  ( *cpSpaceDebugDrawFatSegmentImpl) ( cpVect a, cpVect b, cpFloat radius, cpSpaceDebugColor outlineColor, cpSpaceDebugColor fillColor, cpDataPointer data -- )
\ //  Callback type for a function that draws a convex polygon.
\ typedef void  ( *cpSpaceDebugDrawPolygonImpl) ( int count, const cpVect *verts, cpFloat radius, cpSpaceDebugColor outlineColor, cpSpaceDebugColor fillColor, cpDataPointer data -- )
\ //  Callback type for a function that draws a dot.
\ typedef void  ( *cpSpaceDebugDrawDotImpl) ( cpFloat size, cpVect pos, cpSpaceDebugColor color, cpDataPointer data -- )
\ //  Callback type for a function that returns a color for a given shape. This gives you an opportunity to color shapes based on how they are used in your engine.
\ typedef cpSpaceDebugColor  ( *cpSpaceDebugDrawColorForShapeImpl) ( cpShape *shape, cpDataPointer data -- )

\ typedef enum cpSpaceDebugDrawFlags {
\ 0
\ 	bit CP_SPACE_DEBUG_DRAW_SHAPES \ = 1<<0,
\ 	bit CP_SPACE_DEBUG_DRAW_CONSTRAINTS \ = 1<<1,
\ 	bit CP_SPACE_DEBUG_DRAW_COLLISION_POINTS \ = 1<<2,
\ drop \ } cpSpaceDebugDrawFlags;

\ //  Struct used with cpSpaceDebugDraw ( ) containing drawing callbacks and other drawing settings.
\ typedef struct cpSpaceDebugDrawOptions {
\ 	\ //  Function that will be invoked to draw circles.
\ 	cpSpaceDebugDrawCircleImpl drawCircle;
\ 	\ //  Function that will be invoked to draw line segments.
\ 	cpSpaceDebugDrawSegmentImpl drawSegment;
\ 	\ //  Function that will be invoked to draw thick line segments.
\ 	cpSpaceDebugDrawFatSegmentImpl drawFatSegment;
\ 	\ //  Function that will be invoked to draw convex polygons.
\ 	cpSpaceDebugDrawPolygonImpl drawPolygon;
\ 	\ //  Function that will be invoked to draw dots.
\ 	cpSpaceDebugDrawDotImpl drawDot;
\
\ 	\ //  Flags that request which things to draw  ( collision shapes, constraints, contact points).
\ 	cpSpaceDebugDrawFlags flags;
\ 	\ //  Outline color passed to the drawing function.
\ 	cpSpaceDebugColor shapeOutlineColor;
\ 	\ //  Function that decides what fill color to draw shapes using.
\ 	cpSpaceDebugDrawColorForShapeImpl colorForShape;
\ 	\ //  Color passed to drawing functions for constraints.
\ 	cpSpaceDebugColor constraintColor;
\ 	\ //  Color passed to drawing functions for collision points.
\ 	cpSpaceDebugColor collisionPointColor;
\
\ 	\ //  User defined context pointer passed to all of the callback functions as the 'data' argument.
\ 	cpDataPointer data;
\ } cpSpaceDebugDrawOptions;

\ //  Debug draw the current state of the space using the supplied drawing options.
\ function: cpSpaceDebugDraw ( cpSpace *space, cpSpaceDebugDrawOptions *options -- )
