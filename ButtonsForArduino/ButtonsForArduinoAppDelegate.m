//
//  ButtonsForArduinoAppDelegate.m
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "ButtonsForArduinoAppDelegate.h"
#import "ButtonWindowController.h"
#import "DataHandler.h"
#import "UpdateHandler.h"

@implementation ButtonsForArduinoAppDelegate

@synthesize window;

#pragma mark - Lifecycle

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    buttonWindow = [[ButtonWindowController alloc] initWithWindowNibName:@"ButtonWindow"];
    [self.window makeKeyAndOrderFront:self];
    
}

- (void) awakeFromNib {
    
    dataHandler = [DataHandler sharedDataHandler];
    updateHandler = [UpdateHandler sharedUpdateHandler];
    
    [serialSelectMenu addItemsWithTitles:[[updateHandler arduino] deviceNames]];
    
    // Designate the pwm pins here
    // This will be good for if we ever need to change the board type
    NSArray *pwmPins = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], [NSNumber numberWithInt:9], [NSNumber numberWithInt:10], [NSNumber numberWithInt:11], nil];
    
    popups = [[NSMutableArray alloc] initWithCapacity:12];
    [popups addObject:pin2Popup];
    [popups addObject:pin3Popup];
    [popups addObject:pin4Popup];
    [popups addObject:pin5Popup];
    [popups addObject:pin6Popup];
    [popups addObject:pin7Popup];
    [popups addObject:pin8Popup];
    [popups addObject:pin9Popup];
    [popups addObject:pin10Popup];
    [popups addObject:pin11Popup];
    [popups addObject:pin12Popup];
    [popups addObject:pin13Popup];
    
    colourWells = [[NSMutableArray alloc] initWithCapacity:12];
    [colourWells addObject:pin2ColourWell];
    [colourWells addObject:pin3ColourWell];
    [colourWells addObject:pin4ColourWell];
    [colourWells addObject:pin5ColourWell];
    [colourWells addObject:pin6ColourWell];
    [colourWells addObject:pin7ColourWell];
    [colourWells addObject:pin8ColourWell];
    [colourWells addObject:pin9ColourWell];
    [colourWells addObject:pin10ColourWell];
    [colourWells addObject:pin11ColourWell];
    [colourWells addObject:pin12ColourWell];
    [colourWells addObject:pin13ColourWell];
    
    // Add types of buttons applicable to the popups
    for(int i=0; i<[popups count]; i++) {
        
        NSPopUpButton *pop = [popups objectAtIndex:i];
        NSNumber *tagNum = [NSNumber numberWithInt:(int)[pop tag]];
        
        [pop addItemWithTitle:@"Circle"];
        
        for(int j=0; j<[pwmPins count]; j++) {
            if([tagNum intValue] == [[pwmPins objectAtIndex:j] intValue]) {
                [pop addItemWithTitle:@"Rotary"];
            }
        }
     
        [pop selectItemAtIndex:[dataHandler getTypeForPin:i+2]];
     
        NSColorWell *well = [colourWells objectAtIndex:i];
        [well setColor:[dataHandler getColourForPin:i+2]];
        
    }
    
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender {
    
    // Save before closing
    [buttonWindow saveAllValues];
    
    // Safely disconnect
    [[updateHandler arduino] disconnect];
    return NSTerminateNow;
    
}


#pragma mark - Preferences

- (IBAction)popupAction:(id)sender {
    
    int buttonType;
    NSString *selectedTitle = [[sender selectedItem] title];
    
    if([selectedTitle isEqualToString:@"Circle"]) {
        buttonType = 0;
    } else if([selectedTitle isEqualToString:@"Rotary"]) {
        buttonType = 1;
    }
    
    [buttonWindow updatedButton:buttonType forPin:(int)[sender tag]];
    [dataHandler setType:buttonType forPin:(int)[sender tag]];
    
}

- (IBAction)colorAction:(id)sender {
    [buttonWindow updatedColor:[sender color] forPin:(int)[sender tag]];
    [dataHandler setColour:[sender color] forPin:(int)[sender tag]];
}

- (IBAction) showPrefs:(id)sender {
    
    if([[updateHandler arduino] isConnected]) { // Show the buttons as disabled
        [self setButtonsDisabled];
    } else { // Show the buttons as enabled
        [self setButtonsEnabled];
    }
    
    [self.window makeKeyAndOrderFront:self];
    
}

- (IBAction) launchWebsite:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://robotgrrl.com/apps4arduino/buttons.php"]];
}


#pragma mark - Buttons for connection

- (IBAction) connectPressed:(id)sender {
    
    if(![[updateHandler arduino] isConnected]) { // Pressing GO!
        
        if([[updateHandler arduino] connect:[serialSelectMenu titleOfSelectedItem] withBaud:B115200]) {
            
            [self setButtonsDisabled];
            [buttonWindow.window makeKeyAndOrderFront:self];
            //[self.window orderOut:self]; // keep debating whether this should stay or not after pressing go
            
        } else {
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert setMessageText:@"Connection Error"];
            [alert setInformativeText:@"Connection failed to start"];
            [alert addButtonWithTitle:@"OK"];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
        }
        
    } else { // Pressing Stop
        
        [[updateHandler arduino] disconnect];
        [buttonWindow.window orderOut:self];
        [self setButtonsEnabled];
        
    }
    
}

- (void) setButtonsEnabled {
    [serialSelectMenu setEnabled:YES];
    [connectButton setTitle:@"GO!"];
}

- (void) setButtonsDisabled {
    [serialSelectMenu setEnabled:NO];
    [connectButton setTitle:@"Stop"];
}


#pragma mark - UpdateHandler

- (void) portAdded:(NSArray *)ports {
    for(NSString *portName in ports) {
        [serialSelectMenu addItemWithTitle:portName];
    }
}

- (void) portRemoved:(NSArray *)ports {
    for(NSString *portName in ports) {
        [serialSelectMenu removeItemWithTitle:portName];
    }
}

- (void) portClosed {
    [buttonWindow.window orderOut:self];
    [self setButtonsEnabled];
    [self.window makeKeyAndOrderFront:self];
    
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText:@"Disconnected"];
    [alert setInformativeText:@"Apparently the Arduino was disconnected!"];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
}


@end
