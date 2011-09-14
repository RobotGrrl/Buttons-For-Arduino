//
//  ButtonsForArduinoAppDelegate.h
//  ButtonsForArduino
//
/*
 
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the RobotGrrl.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import <Cocoa/Cocoa.h>

@class ButtonWindowController, DataHandler, UpdateHandler;

@interface ButtonsForArduinoAppDelegate : NSObject <NSApplicationDelegate> {
    
    // Windows
    NSWindow *window;
    ButtonWindowController *buttonWindow;
    
    // Preferences
    IBOutlet NSPopUpButton *serialSelectMenu;
    IBOutlet NSButton *connectButton;
    
    // Popup Buttons
    IBOutlet NSPopUpButton *pin2Popup;
    IBOutlet NSPopUpButton *pin3Popup;
    IBOutlet NSPopUpButton *pin4Popup;
    IBOutlet NSPopUpButton *pin5Popup;
    IBOutlet NSPopUpButton *pin6Popup;
    IBOutlet NSPopUpButton *pin7Popup;
    IBOutlet NSPopUpButton *pin8Popup;
    IBOutlet NSPopUpButton *pin9Popup;
    IBOutlet NSPopUpButton *pin10Popup;
    IBOutlet NSPopUpButton *pin11Popup;
    IBOutlet NSPopUpButton *pin12Popup;
    IBOutlet NSPopUpButton *pin13Popup;
    
    // Colour Wells
    IBOutlet NSColorWell *pin2ColourWell;
    IBOutlet NSColorWell *pin3ColourWell;
    IBOutlet NSColorWell *pin4ColourWell;
    IBOutlet NSColorWell *pin5ColourWell;
    IBOutlet NSColorWell *pin6ColourWell;
    IBOutlet NSColorWell *pin7ColourWell;
    IBOutlet NSColorWell *pin8ColourWell;
    IBOutlet NSColorWell *pin9ColourWell;
    IBOutlet NSColorWell *pin10ColourWell;
    IBOutlet NSColorWell *pin11ColourWell;
    IBOutlet NSColorWell *pin12ColourWell;
    IBOutlet NSColorWell *pin13ColourWell;
    
    // Handlers
    DataHandler *dataHandler;
    UpdateHandler *updateHandler;
    
    // Misc
    NSMutableArray *popups;
    NSMutableArray *colourWells;
    
}

@property (assign) IBOutlet NSWindow *window;

// Preferences
- (IBAction)colorAction:(id)sender;
- (IBAction)popupAction:(id)sender;

// Buttons for connection related
- (IBAction) connectPressed:(id)sender;
- (void) setButtonsEnabled;
- (void) setButtonsDisabled;

// UpdateHandler
- (void) portAdded:(NSArray *)ports;
- (void) portRemoved:(NSArray *)ports;
- (void) portClosed;

@end
