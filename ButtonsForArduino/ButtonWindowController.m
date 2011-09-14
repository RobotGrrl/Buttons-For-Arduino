//
//  ButtonWindowController.m
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "ButtonWindowController.h"
#import "ButtonViewController.h"
#import "RotaryViewController.h"
#import "DataHandler.h"

@implementation ButtonWindowController

#pragma mark - Lifecycle

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void) awakeFromNib {
    
    [self.window setMovableByWindowBackground:YES];
    
    dataHandler = [DataHandler sharedDataHandler];
    
    pinViews = [[NSArray alloc] initWithObjects:pin2View, pin3View, pin4View, pin5View, pin6View, pin7View, pin8View, pin9View, pin10View, pin11View, pin12View, pin13View, nil];
    buttonViewControllers = [[NSMutableArray alloc] initWithCapacity:12];
    
    for(int i=0; i<12; i++) {
        
        int buttonType = [dataHandler getTypeForPin:i+2];
        NSColor *savedColour = [dataHandler getColourForPin:i+2];
        NSView *replaceView = [pinViews objectAtIndex:i];
        
        switch (buttonType) {
            case 0: {
                
                ButtonViewController *buttonVC;
                buttonVC = [[ButtonViewController alloc] initWithNibName:@"ButtonViewController" bundle:nil];
                buttonVC.pin = i+2;
                buttonVC.type = buttonType;
                buttonVC.currentVal = 0;//[dataHandler getValueForPin:i+2];
                [[buttonVC view] setFrame:[replaceView frame]];
                [self.window.contentView replaceSubview:replaceView with:[buttonVC view]];
                [buttonVC updateFillColor:savedColour];
                [buttonViewControllers addObject:buttonVC];
                [buttonVC release];
                
                break;
            }
            case 1: {
                
                RotaryViewController *rotVC;
                rotVC = [[RotaryViewController alloc] initWithNibName:@"RotaryViewController" bundle:nil];
                rotVC.pin = i+2;
                rotVC.type = buttonType;
                rotVC.currentVal = 0;//[dataHandler getValueForPin:i+2];
                [[rotVC view] setFrame:[replaceView frame]];
                [self.window.contentView replaceSubview:replaceView with:[rotVC view]];
                [rotVC updateFillColor:savedColour];
                [buttonViewControllers addObject:rotVC];
                [rotVC release];
                
                break;
            }
            default:
                break;
        }   
    }    
}

#pragma mark - Window

- (void) saveAllValues {
    
    for(int i=0; i<12; i++) {
        
        int buttonType = [dataHandler getTypeForPin:i+2];

        switch (buttonType) {
            case 0: {
                ButtonViewController *buttonVC = [buttonViewControllers objectAtIndex:i];
                [dataHandler setValue:[buttonVC currentVal] forPin:i+2];
                break;
            }
            case 1: {
                RotaryViewController *rotVC = [buttonViewControllers objectAtIndex:i];
                [dataHandler setValue:[rotVC currentVal] forPin:i+2];
                break;
            }
            default:
                break;
        }
        
    }
    
}

- (void) updatedButton:(int)b forPin:(int)p {
        
    int index = p-2;
    NSColor *previousColor = [[buttonViewControllers objectAtIndex:index] fillColour];
    int previousVal = [[buttonViewControllers objectAtIndex:index] currentVal];
    NSView *replaceView = [[buttonViewControllers objectAtIndex:index] view];
    
    switch (b) {
        case 0: {
            
            // Adjusting the val when switching between button types
            int previousType = [(ButtonViewController *)[buttonViewControllers objectAtIndex:index] type];
            int newVal = previousVal;
            if(previousType == 1) {
                if(previousVal > 512) {
                    newVal = 1;
                } else {
                    newVal = 0;
                }
            }
            
            // Setting up & adding button
            ButtonViewController *buttonVC;
            buttonVC = [[ButtonViewController alloc] initWithNibName:@"ButtonViewController" bundle:nil];
            buttonVC.pin = index+2;
            buttonVC.type = b;
            buttonVC.currentVal = newVal;
            [[buttonVC view] setFrame:[replaceView frame]];
            [self.window.contentView replaceSubview:replaceView with:[buttonVC view]];
            [buttonVC updateFillColor:previousColor];
            [buttonViewControllers replaceObjectAtIndex:index withObject:buttonVC];
            [buttonVC release];
            
            break;
        }
        case 1: {
            
            // Adjusting the val when switching between button types
            int previousType = [(RotaryViewController *)[buttonViewControllers objectAtIndex:index] type];
            int newVal = previousVal;
            if(previousType == 0) {
                if(previousVal == 0) {
                    newVal = 0;
                } else {
                    newVal = 255;
                }
            }
            
            // Setting up & adding button
            RotaryViewController *rotVC;
            rotVC = [[RotaryViewController alloc] initWithNibName:@"RotaryViewController" bundle:nil];
            rotVC.pin = index+2;
            rotVC.type = b;
            rotVC.currentVal = newVal;
            [[rotVC view] setFrame:[replaceView frame]];
            [self.window.contentView replaceSubview:replaceView with:[rotVC view]];
            [rotVC updateFillColor:previousColor];
            [buttonViewControllers replaceObjectAtIndex:index withObject:rotVC];
            [rotVC release];
            
            break;
        }
        default:
            break;
    }
    
}

- (void) updatedColor:(NSColor *)c forPin:(int)p {
    
    int index = p-2;
    
    // Have to make sure it is an RGB colour!
    if([c colorSpace] == [NSColorSpace genericRGBColorSpace]) {
        [[buttonViewControllers objectAtIndex:index] updateFillColor:c];
    }
    
}

@end
