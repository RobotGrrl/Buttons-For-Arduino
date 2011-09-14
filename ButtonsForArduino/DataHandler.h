//
//  DataHandler.h
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface DataHandler : NSObject {
    NSString *myFile;
    NSMutableDictionary *rootDict;
}

@property (nonatomic, retain) NSString *myFile;
@property (nonatomic, retain) NSMutableDictionary *rootDict;

- (void) initPlist;
+ (DataHandler *)sharedDataHandler;

// Getters
- (int) getTypeForPin:(int)p;
- (NSColor *) getColourForPin:(int)p;
- (int) getValueForPin:(int)p;
- (NSDictionary *) pinSettings:(int)p;

// Setters
- (void) setType:(int)t forPin:(int)p;
- (void) setColour:(NSColor *)c forPin:(int)p;
- (void) setValue:(int)v forPin:(int)p;
- (void) updateDict:(NSDictionary *)dict forPin:(int)p;

@end
