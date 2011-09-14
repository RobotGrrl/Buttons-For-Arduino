//
//  RotaryView.h
//  RotarySlider
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

// Special thanks to:
// - http://cocoawithlove.com/2011/01/advanced-drawing-using-appkit.html
// - Speedometer Apple sample code (of which most of this is based from)

#import <Cocoa/Cocoa.h>

@protocol RotaryViewDelegate;

@interface RotaryView : NSView {
    
    id <RotaryViewDelegate> delegate;
    
	float speed; /* 0.0 to 100.0 percent */
	float curvature; /* 0.0 to 100.0 percent */
	int ticks; /* 3 to 14 ticks */
	
    /* bounding frame for the entire control */
	NSBezierPath* boundingFrame;
	
    /* information about the indicator pointer */
	float iStartAngle, iEndAngle;
	NSPoint iCenterPt;
	
    /* true while we're dragging the indicator around */
	BOOL draggingIndicator;
    
    NSColor *fillColour;
    
}

@property (nonatomic, retain) id <RotaryViewDelegate> delegate;

/* properties for our instance variables. */
@property (nonatomic) float speed;
@property (nonatomic) float curvature;
@property (nonatomic) int ticks;
@property (nonatomic) BOOL draggingIndicator;
@property (nonatomic, copy) NSBezierPath* boundingFrame;

@property (nonatomic, retain) NSColor *fillColour;

- (id)initWithFrame:(NSRect)frameRect;
- (void) dealloc;

/* used for saving information about the position of the pointer
 that we use in our mouse tracking methods for adjusting the speed. */
- (void)saveSweepWithCenter:(NSPoint) centerPt startAngle:(float) stAngle endAngle:(float) enAngle;

@end

@protocol RotaryViewDelegate
- (void) mouseDidHover;
- (void) mouseDidExit;
- (void) sliderChanged:(int)val;
- (void) mouseDidUp;
@end
