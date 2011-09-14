//
//  ButtonWindowController.h
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import <Cocoa/Cocoa.h>

@class DataHandler;

@interface ButtonWindowController : NSWindowController {
    
    // Handler
    DataHandler *dataHandler;
    
    // Button Views
    IBOutlet NSView *pin2View;
    IBOutlet NSView *pin3View;
    IBOutlet NSView *pin4View;
    IBOutlet NSView *pin5View;
    IBOutlet NSView *pin6View;
    IBOutlet NSView *pin7View;
    IBOutlet NSView *pin8View;
    IBOutlet NSView *pin9View;
    IBOutlet NSView *pin10View;
    IBOutlet NSView *pin11View;
    IBOutlet NSView *pin12View;
    IBOutlet NSView *pin13View;
    
    // Button Titles
    IBOutlet NSButton *pin2Button;
    IBOutlet NSButton *pin3Button;
    IBOutlet NSButton *pin4Button;
    IBOutlet NSButton *pin5Button;
    IBOutlet NSButton *pin6Button;
    IBOutlet NSButton *pin7Button;
    IBOutlet NSButton *pin8Button;
    IBOutlet NSButton *pin9Button;
    IBOutlet NSButton *pin10Button;
    IBOutlet NSButton *pin11Button;
    IBOutlet NSButton *pin12Button;
    IBOutlet NSButton *pin13Button;
    
    // Funky vars
    NSArray *pinViews;
    NSMutableArray *buttonViewControllers;
    
}

// Window
- (void) saveAllValues;
- (void) updatedButton:(int)b forPin:(int)p;
- (void) updatedColor:(NSColor *)c forPin:(int)p;

@end
