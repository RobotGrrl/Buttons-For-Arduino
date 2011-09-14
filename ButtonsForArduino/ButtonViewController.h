//
//  ButtonViewController.h
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import <Cocoa/Cocoa.h>
#import "ButtonView.h"

@class UpdateHandler;

@interface ButtonViewController : NSViewController <ButtonViewDelegate> {
    
    // Display
    IBOutlet ButtonView *buttonView;
    IBOutlet NSTextField *pinLabel;
    NSSound *mouseUpSound;
    NSSound *mouseDownSound;
    
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
@property (assign) int currentVal;

@property (nonatomic, retain) NSColor *fillColour;

- (void) sendUpdate;
- (void) updateFillColor:(NSColor *)c;

@end
