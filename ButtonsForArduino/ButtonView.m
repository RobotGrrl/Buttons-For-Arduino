//
//  ButtonView.m
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "ButtonView.h"
#import "RotaryCategories.h"

@implementation ButtonView

@synthesize delegate, fillColour, on;

#pragma mark - View

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        on = NO;
        didDown = NO;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    
    // ----- Outer Circle -----
    
    const float inset = 8.0; // inset from edges - padding around drawing
    
	NSPoint center;
	center.x = (inset/2.0);
    center.y = (inset/2.0);
    
    float w = self.bounds.size.width;
    float h = self.bounds.size.height;
    
    float s = w;
    float x = (w/2)-(s/2);
    float y = 0;
    
    if(w > h) {
        s = h;
        x = (w/2)-(s/2);
        y = 0;
    } else {
        s = w;
        x = 0;
        y = (h/2)-(s/2);
    }
    
    [[NSColor colorWithCalibratedRed:0.2 green:0.2 blue:0.2 alpha:0.5] setFill];
    NSRect rect = NSMakeRect(x, y, s, s);

    NSBezierPath *circlePath = [NSBezierPath bezierPath];
    [circlePath appendBezierPathWithOvalInRect:rect];
    //[circlePath setLineWidth: 0.5];
    // it looks nicer with the shadow, but the x & y positioning without
    // accounting for the inset makes the shadow clipped. something to
    // do for a rainy day...
    //[circlePath fillWithShadowAtDegrees:-90 withDistance:inset/2];
    
    NSGradient *borderGradient =
    [[[NSGradient alloc]
      initWithStartingColor:[NSColor colorWithCalibratedWhite:0.5 alpha:0.5]
      endingColor:[NSColor colorWithCalibratedWhite:0.1 alpha:0.5]]
     autorelease];
	[borderGradient drawInBezierPath:circlePath angle:-90];
    
    
    // ----- Inner Circle -----
    
    float s2 = w-(w/4);
    float x2 = w/8;
    float y2 = (h/2)-(s/2)+(w/8);
    
    if(w > h) {
        s2 = h-(h/4);
        x2 = (w/2)-(s/2)+(h/8);
        y2 = h/8;
    } else {
        s2 = w-(w/4);
        x2 = w/8;
        y2 = (h/2)-(s/2)+(w/8);
    }
    
    [[NSColor colorWithCalibratedRed:1.0 green:0.9 blue:0.9 alpha:0.5] setFill];
    NSRect middleRect = NSMakeRect(x2, y2, s2, s2);
    NSBezierPath *middlePath = [NSBezierPath bezierPath];
    [middlePath appendBezierPathWithOvalInRect:middleRect];
    [middlePath fill];
    
    
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
	[bottomGlowGradient drawInBezierPath:middlePath relativeCenterPosition:NSMakePoint(0, -0.2)];
    
    NSGradient *topGlowGradient =
    [[[NSGradient alloc]
      initWithColorsAndLocations:
      [NSColor colorWithCalibratedRed:givenRed+0.2 green:givenGreen+0.2 blue:givenBlue+0.2 alpha:0.75], 0.0,
      [NSColor colorWithCalibratedRed:givenRed+0.1 green:givenGreen+0.1 blue:givenBlue+0.1 alpha:0.55], 0.25,
      [NSColor colorWithCalibratedRed:givenRed+0.1 green:givenGreen+0.1 blue:givenBlue+0.1 alpha:0.0], 0.40,
      nil]
     autorelease];
	[topGlowGradient drawInBezierPath:middlePath relativeCenterPosition:NSMakePoint(0, 0.4)];
    
    NSGradient *centerGlowGradient =
    [[[NSGradient alloc]
      initWithColorsAndLocations:
      [NSColor colorWithCalibratedRed:givenRed+0.3 green:givenGreen+0.3 blue:givenBlue+0.3 alpha:0.9], 0.0,
      [NSColor colorWithCalibratedRed:givenRed+0.1 green:givenGreen+0.1 blue:givenBlue+0.1 alpha:0.0], 0.85,
      nil]
     autorelease];
	[centerGlowGradient drawInBezierPath:middlePath relativeCenterPosition:NSMakePoint(0, 0)];
    
    
    // ----- Off -----
    
    if(!on) {
        [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.5] setFill];
        NSRect middleRectOnOff = NSMakeRect(x2, y2, s2, s2);
        NSBezierPath *middlePathOnOff = [NSBezierPath bezierPath];
        [middlePathOnOff appendBezierPathWithOvalInRect:middleRectOnOff];
        [middlePathOnOff fill]; 
    }
    
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

- (void)mouseDown:(NSEvent *)theEvent {   
    [self.delegate mouseDidDown];
    didDown = YES;
}

- (void)mouseUp:(NSEvent *)theEvent {   
    [self.delegate mouseDidUp];
    if(didDown) {
        on = !on;
        didDown = NO;
        [self.delegate buttonState:on];
        [self setNeedsDisplay:YES];
    }
    
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

@end
