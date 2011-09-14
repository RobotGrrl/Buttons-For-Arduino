//
//  UpdateHandler.m
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "UpdateHandler.h"
#import "ButtonsForArduinoAppDelegate.h"

#define UPDATE_NOTIFICATION @"com.robotgrrl.buttons.update"

static UpdateHandler *sharedInstance = nil;

@implementation UpdateHandler

@synthesize arduino;

#pragma mark - Singleton Methods

- (id) init {
	@synchronized(self) {
        arduino = [[Matatino alloc] initWithDelegate:self];
        appDelegate = (ButtonsForArduinoAppDelegate *)[[NSApplication sharedApplication] delegate];
        [super init];
		return self;
    }
}

+ (UpdateHandler *)sharedUpdateHandler {
	@synchronized (self) {
		if (sharedInstance == nil) {
			[[self alloc] init];
		}
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (oneway void)release {
	// do nothing
}

- (id)autorelease {
	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

#pragma mark - Data

- (void) sendValue:(int)val forPin:(int)pin withType:(int)type {
    
    NSString *pinSegment;
    NSString *valueSegment;
    NSString *typeSegment;
    NSString *sendString;
    
    if(pin >= 10) {
        pinSegment = [NSString stringWithFormat:@"P%d", pin];
    } else {
        pinSegment = [NSString stringWithFormat:@"P0%d", pin];
    }
    
    switch (type) {
        case 0:
            typeSegment = @"B";
            break;
        case 1:
            typeSegment = @"R";
            break;
        default:
            break;
    }
    
    if(val >= 1000) {
        valueSegment = [NSString stringWithFormat:@"%d", val];
    } else if(val >= 100) {
        valueSegment = [NSString stringWithFormat:@"0%d", val];
    } else if(val >= 10) {
        valueSegment = [NSString stringWithFormat:@"00%d", val];
    } else {
        valueSegment = [NSString stringWithFormat:@"000%d", val];
    }
    
    sendString = [NSString stringWithFormat:@"%@%@%@;", pinSegment, typeSegment, valueSegment];
    
    [arduino send:sendString];
    [arduino send:sendString];
    
    [self updateNotification:val forPin:pin withType:type];
    
}

- (void) updateNotification:(int)val forPin:(int)pin withType:(int)type {
    
    NSMutableDictionary *notif = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [notif setObject:[NSNumber numberWithInt:val] forKey:@"Value"];
    [notif setObject:[NSNumber numberWithInt:pin] forKey:@"Pin"];
    [notif setObject:[NSNumber numberWithInt:type] forKey:@"Type"];
    
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    [center postNotificationName:UPDATE_NOTIFICATION 
                          object:nil 
                        userInfo:[NSDictionary dictionaryWithDictionary:notif] 
              deliverImmediately:YES];
    
    [notif release];
    
}

#pragma mark - Arduino Delegate Methods

- (void) receivedString:(NSString *)rx {
}

- (void) portAdded:(NSArray *)ports {
    [appDelegate portAdded:ports];
}

- (void) portRemoved:(NSArray *)ports {
    [appDelegate portRemoved:ports];
}

- (void) portClosed {
    [appDelegate portClosed];
}


@end
