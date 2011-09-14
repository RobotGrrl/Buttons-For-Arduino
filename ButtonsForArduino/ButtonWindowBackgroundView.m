//
//  ButtonWindowBackgroundView.m
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "ButtonWindowBackgroundView.h"

@implementation ButtonWindowBackgroundView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

// Draw a nice gradient for the background
- (void)drawRect:(NSRect)dirtyRect {
    
    NSRect viewRect = NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height);
    NSBezierPath *rectPath = [NSBezierPath bezierPath];
    [rectPath appendBezierPathWithRect:viewRect];
    
    NSGradient *fillerGradient =
    [[[NSGradient alloc]
      initWithStartingColor:[NSColor colorWithCalibratedRed:0.2f green:0.2f blue:0.2f alpha:1.0f]
      endingColor:[NSColor colorWithCalibratedRed:0.08f green:0.08f blue:0.08f alpha:1.0f]]
     autorelease];
	[fillerGradient drawInBezierPath:rectPath angle:-90];
    
}

@end
