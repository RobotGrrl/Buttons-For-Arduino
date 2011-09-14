//
//  RotaryView.m
//  RotarySlider
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "RotaryView.h"
#import "RotaryCategories.h"

@implementation RotaryView

@synthesize delegate;
@synthesize speed, curvature, ticks, draggingIndicator;
@synthesize fillColour;

#pragma mark - Lifecycle

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
	if (self) {
        /* set to some startup values */
		self.speed = 50.0f;
		self.curvature = 110.0f;
		self.ticks = 11;
	}
	return self;
}

- (void) dealloc {
	self.boundingFrame = nil;
	[super dealloc];
}



#pragma mark - Accessors

- (void)setSpeed:(float)value {
    float nextLevel;
	
    /* bound setting to acceptable value range */
	if (value < 0.0)
		nextLevel = 0.0;
	else if (value > 100.0)
		nextLevel = 100.0;
	else nextLevel = value;
	
    /* set the new value, on change */
    if (speed != nextLevel) {
        speed = nextLevel;
		[self setNeedsDisplay:YES];
    }
}

- (void)setCurvature:(float)value {
    float nextCurvature;
	
    /* bound setting to acceptable value range */
	if (value < 0.0)
		nextCurvature = 0.0;
	else if (value > 100.0)
		nextCurvature = 100.0;
	else nextCurvature = value;
	
    /* set the new value, on change */
	if (curvature != nextCurvature) {
        curvature = nextCurvature;
		[self setNeedsDisplay:YES];
    }
}

- (void)setTicks:(int)value {
	int nextTicks;
	
    /* bound setting to acceptable value range */
	if (value < 3)
		nextTicks = 3;
	else if (value > 21)
		nextTicks = 21;
	else nextTicks = value;
    
    /* set the new value, on change */
    if (ticks != nextTicks) {
        ticks = nextTicks;
		[self setNeedsDisplay:YES];
    }
}

- (NSBezierPath *)boundingFrame {
    return [[boundingFrame retain] autorelease];
}

- (void)setBoundingFrame:(NSBezierPath *)value {
    if (boundingFrame != value) {
        [boundingFrame release];
        boundingFrame = [value copy];
    }
}



/* used for saving information about the position of the pointer
 that we use in our mouse tracking methods for adjusting the speed. */
- (void)saveSweepWithCenter:(NSPoint) centerPt startAngle:(float) stAngle endAngle:(float) enAngle {
	iStartAngle = stAngle; /* degrees counter clockwise from the x axis */
	iEndAngle = enAngle; /* degrees counter clockwise from the x axis */
	iCenterPt = centerPt; /* pivot point */
}


#pragma mark - Drawing

- (void)drawRect:(NSRect)rect {
    
	const float inset = 8.0; /* inset from edges - padding around drawing */
	const float shadowAngle = -35.0;
	
    /* the bounds of this view */
    NSRect boundary = self.bounds;
	
	float sweepAngle = 270.0*(curvature/100.0) + 45.0;
	float sAngle = 90-sweepAngle/2;
	float eAngle = 90+sweepAngle/2;
	
    /* central axis will be aligned with the bottom axis. */
	
    /* calculate center, and radius. */
	NSPoint center;
	float spread, radius, dip;
    /* center horizontally in the view */
	center.x = boundary.origin.x + (boundary.size.width/2.0);
    /* if the sweep is less than 180 degrees, then we could use
     the distanct from the center to where we'll hit the right
     hand side as the radius.  */
	spread = ( sweepAngle <= 180 ) ?
    sqrtf(pow(center.x,2) + pow(tanf(sAngle*pi/180)*center.x,2))*2 : boundary.size.width;
    /* if the sweep is greater than 180 degrees, then the right and
     left sides will dip down below the center. */
	dip = (sweepAngle > 180) ? fabsf(sinf(sAngle*pi/180)) : 0.0;
    /* calculate the radius based on the height */
	radius = (boundary.size.height/(dip+1.0)) - inset;
    /* then calculate the center based on the radius */
	center.y = boundary.origin.y + radius*dip + (inset/2.0);
    
    /* those calculations could have put us over the right and
     left edges, so limit the radius by the maximum spread. */
	if (radius > spread/2.0 - inset) radius = spread/2.0 - inset;
    
    /* calculate some heights proportionate to the radius. */
	float centerSize = radius * 14.0/100.0; /* 15% center cover size */
    
    /* adjust the radius and center position incase we're drawing a pie
     shaped wedge so that the bottom of the speedometer is aligned with
     the bottom of the view's rectangle. */
	if ( sweepAngle < 180.0 ) {
		float wedgeOffset = sinf(sAngle*pi/180) * centerSize;
		center.y -= wedgeOffset;
		radius += wedgeOffset;
        /* make sure we aren't going past the right or left edge */
		if (radius > spread/2.0 - inset) radius = spread/2.0 - inset;
	}
    
    /* make a bezier path for the background */
	NSBezierPath* frame = [[[NSBezierPath alloc] init] autorelease];
	[frame appendBezierPathWithArcWithCenter:center radius:centerSize startAngle:eAngle endAngle:sAngle clockwise:YES];
	[frame appendBezierPathWithArcWithCenter:center radius:radius startAngle:sAngle endAngle:eAngle];
	[frame closePath];
	[frame setLineWidth: 0.5];
	[frame setLineJoinStyle:NSRoundLineJoinStyle];
    
    NSGradient *borderGradient =
    [[[NSGradient alloc]
      initWithStartingColor:[NSColor colorWithCalibratedWhite:0.5 alpha:0.5]
      endingColor:[NSColor colorWithCalibratedWhite:0.1 alpha:0.5]]
     autorelease];
	[borderGradient drawInBezierPath:frame angle:-90];
    
    /* Add the gradients */
    float givenRed = [self.fillColour redComponent];
    float givenGreen = [self.fillColour greenComponent];
    float givenBlue = [self.fillColour blueComponent];
    
    NSGradient *bottomGlowGradient =
    [[[NSGradient alloc]
      initWithColorsAndLocations:
      [NSColor colorWithCalibratedRed:givenRed green:givenGreen blue:givenBlue alpha:1.0], 0.0,
      [NSColor colorWithCalibratedRed:givenRed-0.1 green:givenGreen-0.1 blue:givenBlue-0.1 alpha:1.0], 0.35,
      [NSColor colorWithCalibratedRed:givenRed/2 green:givenGreen/2 blue:givenBlue/2 alpha:1.0], 0.6,
      [NSColor colorWithCalibratedRed:givenRed/3 green:givenGreen/3 blue:givenBlue/3 alpha:1.0], 0.7,
      nil]
     autorelease];
	[bottomGlowGradient drawInBezierPath:frame relativeCenterPosition:NSMakePoint(0, -0.2)];
    
    NSGradient *topGlowGradient =
    [[[NSGradient alloc]
      initWithColorsAndLocations:
      [NSColor colorWithCalibratedRed:givenRed+0.2 green:givenGreen+0.2 blue:givenBlue+0.2 alpha:0.75], 0.0,
      [NSColor colorWithCalibratedRed:givenRed+0.1 green:givenGreen+0.1 blue:givenBlue+0.1 alpha:0.55], 0.25,
      [NSColor colorWithCalibratedRed:givenRed+0.1 green:givenGreen+0.1 blue:givenBlue+0.1 alpha:0.0], 0.40,
      nil]
     autorelease];
	[topGlowGradient drawInBezierPath:frame relativeCenterPosition:NSMakePoint(0, 0.4)];
    
    NSGradient *centerGlowGradient =
    [[[NSGradient alloc]
      initWithColorsAndLocations:
      [NSColor colorWithCalibratedRed:givenRed+0.3 green:givenGreen+0.3 blue:givenBlue+0.3 alpha:0.9], 0.0,
      [NSColor colorWithCalibratedRed:givenRed+0.1 green:givenGreen+0.1 blue:givenBlue+0.1 alpha:0.0], 0.85,
      nil]
     autorelease];
	[centerGlowGradient drawInBezierPath:frame relativeCenterPosition:NSMakePoint(0, 0)];
    
    /* save a copy of the bounding frame */
	[self setBoundingFrame: frame];
    
    /* calculate the pointer arm's total sweep */
    /* border on each end of sweep to accomodate width of pointer */
	float tickoutside = 0.5;//((pointerWidth) / (radius/2.0)) * 180/pi;//((pointerWidth*.67) / (radius/2.0)) * 180/pi;
    /* total arm sweep will be background sweep minus border on each side */
	float armSweep = sweepAngle - tickoutside*2;
	    
    float rotatedByDegrees = (armSweep+tickoutside-(armSweep/100.0)*speed + sAngle) - eAngle;
    float myStartAngle = eAngle+rotatedByDegrees; // -67.5
    float myEndAngle = eAngle;
        
    /* make a bezier path for the background */
	NSBezierPath* level = [[[NSBezierPath alloc] init] autorelease];
	[level appendBezierPathWithArcWithCenter:center radius:centerSize startAngle:myEndAngle endAngle:myStartAngle clockwise:YES];
    
    [level appendBezierPathWithArcWithCenter:center radius:radius startAngle:myStartAngle endAngle:myEndAngle];
    
	[level closePath];
	[level setLineWidth: 0.5];
	[level setLineJoinStyle:NSRoundLineJoinStyle];
	
    /* fill with light blue, stroke with black. */
    [self.fillColour set];
    [[NSColor colorWithCalibratedWhite:0.0 alpha:0.3] set];
    [level fillWithShadowAtDegrees:shadowAngle withDistance: inset/2];
	[level stroke];
    
    /* record arm information for the drag routine */
	[self saveSweepWithCenter:center startAngle:sAngle+tickoutside endAngle:sAngle+tickoutside+armSweep];
    
}

#pragma mark - Mouse

- (void) viewWillMoveToWindow:(NSWindow *)newWindow {
    // Setup a new tracking area when the view is added to the window.
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] 
                                                                options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways) 
                                                                  owner:self 
                                                               userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self.delegate mouseDidHover];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self.delegate mouseDidExit];
}

/* convert a mouse click inside of the speedometer view into an angle, and then convert
 that angle into the new value that should be displayed. */ 
- (void)setLevelForMouse:(NSPoint) local_point {
    
    /* calculate the new position */
	float clicked_angle = atanf( (local_point.y - iCenterPt.y) / (local_point.x - iCenterPt.x) ) * (180/pi);
	
    /* convert arc tangent result */
	if ( local_point.x < iCenterPt.x ) clicked_angle += 180;
	
    /* clamp angle between the start and end angles */
	if (clicked_angle > iEndAngle)
		clicked_angle = iEndAngle;
	else if (clicked_angle < iStartAngle)
		clicked_angle = iStartAngle;
    
    /* set the new speed, but only if it has changed */
	float newLevel = (iEndAngle-clicked_angle)/(iEndAngle-iStartAngle) * 100.0;
	if (self.speed != newLevel) {
		self.speed = newLevel;
	}
    
    int analogLevel = (255*self.speed)/100;
    
    [self.delegate sliderChanged:analogLevel];
    
}

/* return false so we can track the mouse in our view. */
- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

/* test for mouse clicks inside of the speedometer area of the view */
- (NSView *)hitTest:(NSPoint)aPoint {
	NSPoint local_point = [self convertPoint:aPoint fromView:[self superview]];
	if ( [self.boundingFrame containsPoint:local_point] ) {
		return self;
	}
	return nil;
}

/* re-calculate the speed value based on the mouse position for clicks
 in the speedometer area of the view. */
- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint local_point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	if ( [self.boundingFrame containsPoint:local_point] ) {
        
		[self setLevelForMouse:local_point];
		
        /* set the dragging flag */
		[self setDraggingIndicator: YES];
		
	}
}

/* re-calculate the speed value based on the mouse position while the mouse
 is being dragged inside of the speedometer area of the view. */
- (void)mouseDragged:(NSEvent *)theEvent {
	NSPoint local_point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	if ( [self.boundingFrame containsPoint:local_point] ) {
        
		[self setLevelForMouse:local_point];
        
	}
}

/* clear the dragging flag once the mouse is released. */
- (void)mouseUp:(NSEvent *)theEvent {
    
	[self setDraggingIndicator: NO];
    [self.delegate mouseDidUp];
	
}

@end
