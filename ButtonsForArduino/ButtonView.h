//
//  ButtonView.h
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

// Special thanks to http://cocoawithlove.com/2011/01/advanced-drawing-using-appkit.html

#import <Cocoa/Cocoa.h>

@protocol ButtonViewDelegate;

@interface ButtonView : NSView {
    id <ButtonViewDelegate> delegate;
    NSColor *fillColour;
    BOOL on;
    BOOL didDown;
}

@property (nonatomic, retain) id <ButtonViewDelegate> delegate;
@property (nonatomic, retain) NSColor *fillColour;
@property (assign) BOOL on;

@end

@protocol ButtonViewDelegate
- (void) mouseDidHover;
- (void) mouseDidExit;
- (void) mouseDidDown;
- (void) mouseDidUp;
- (void) buttonState:(BOOL)on;
@end
