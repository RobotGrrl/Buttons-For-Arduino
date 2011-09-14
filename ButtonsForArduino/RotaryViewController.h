//
//  RotaryViewController.h
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import <Cocoa/Cocoa.h>
#import "RotaryView.h"

@class UpdateHandler;

@interface RotaryViewController : NSViewController <RotaryViewDelegate> {

    // Display
    IBOutlet RotaryView *rotaryView;
    IBOutlet NSTextField *pinLabel;
    NSSound *rotarySound;
    
    // Used for debouncing
    int hover;
    int exit;
    
    // Communication related
    UpdateHandler *updateHandler;
    int pin;
    int type;
    NSColor *fillColour;
    int currentVal;
    
}

@property (assign) int pin;
@property (assign) int type;
@property (nonatomic, retain) NSColor *fillColour;
@property (assign) int currentVal; 

- (void) sendUpdate;
- (void) updateFillColor:(NSColor *)c;

@end
