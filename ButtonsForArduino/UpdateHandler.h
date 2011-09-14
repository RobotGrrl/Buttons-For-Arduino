//
//  UpdateHandler.h
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import <Cocoa/Cocoa.h>
#import <Matatino/Matatino.h>

@class ButtonsForArduinoAppDelegate;

@interface UpdateHandler : NSObject <MatatinoDelegate> {
    Matatino *arduino;
    ButtonsForArduinoAppDelegate *appDelegate;
}

@property (nonatomic, retain) Matatino *arduino;

+ (UpdateHandler *)sharedUpdateHandler;

- (void) sendValue:(int)val forPin:(int)pin withType:(int)type;
- (void) updateNotification:(int)val forPin:(int)pin withType:(int)type;

@end
