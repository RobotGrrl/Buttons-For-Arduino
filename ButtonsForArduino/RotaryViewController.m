//
//  RotaryViewController.m
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "RotaryViewController.h"
#import "UpdateHandler.h"

@implementation RotaryViewController

@synthesize pin, type, fillColour, currentVal;

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pin = 99;
        type = 1;
        currentVal = 0;
    }
    
    return self;
}

- (void) awakeFromNib {
    rotaryView.delegate = self;
    rotaryView.speed = (currentVal*100.0f)/255.0f;
    
    updateHandler = [UpdateHandler sharedUpdateHandler];
    
    rotarySound = [[NSSound soundNamed:@"rotary-mouseup"] retain];
    [pinLabel setStringValue:[NSString stringWithFormat:@"%d", pin]];
}

- (void) updateFillColor:(NSColor *)c {
    self.fillColour = c;
    rotaryView.fillColour = c;
    [rotaryView setNeedsDisplay:YES];
}

- (void) sendUpdate {
    [updateHandler sendValue:currentVal forPin:pin withType:type];
}

#pragma mark - RotaryViewDelegate Callbacks

- (void) mouseDidHover {
}

- (void) mouseDidExit {
}

- (void) sliderChanged:(int)val {
    currentVal = val;
    [updateHandler sendValue:val forPin:pin withType:type];
}

- (void) mouseDidUp {
    [[[rotarySound copy] autorelease] play];
}


@end
