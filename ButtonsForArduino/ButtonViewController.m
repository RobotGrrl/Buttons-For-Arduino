//
//  ButtonViewController.m
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "ButtonViewController.h"
#import "UpdateHandler.h"

@implementation ButtonViewController

@synthesize pin, type, fillColour, currentVal;

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pin = 99; // dummy value
        type = 0;
        currentVal = 0;
    }
    
    return self;
}

- (void) awakeFromNib {
    buttonView.delegate = self;
    if(currentVal == 0) {
        buttonView.on = NO;
    } else {
        buttonView.on = YES;
    }
    hover = 0;
    exit = 0;
    updateHandler = [UpdateHandler sharedUpdateHandler];
    mouseUpSound = [[NSSound soundNamed:@"button-mouseup"] retain];
    mouseDownSound = [[NSSound soundNamed:@"button-mousedown"] retain];
    [pinLabel setStringValue:[NSString stringWithFormat:@"%d", pin]];
}

- (void) sendUpdate {
    [updateHandler sendValue:currentVal forPin:pin withType:type];
}

#pragma mark - View

- (void) updateFillColor:(NSColor *)c {
    self.fillColour = c;
    buttonView.fillColour = c;
    [buttonView setNeedsDisplay:YES];
}

#pragma mark - ButtonViewDelegate Callbacks

- (void) mouseDidHover {
}
- (void) mouseDidExit {
}
- (void) mouseDidDown {
}
- (void) mouseDidUp {
}

- (void) buttonState:(BOOL)on {
    
    if(on) {
        currentVal = 1;
        [[[mouseDownSound copy] autorelease] play];
    } else {
        currentVal = 0;
        [[[mouseUpSound copy] autorelease] play];
    }
    
    [updateHandler sendValue:currentVal forPin:pin withType:type];
    
}

@end
