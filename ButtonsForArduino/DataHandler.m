//
//  DataHandler.m
//  ButtonsForArduino
//
/*
 Buttons for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Buttons for Arduino Copyright (c) 2011, RobotGrrl.com. All rights reserved.
 */

#import "DataHandler.h"

static DataHandler *sharedInstance = nil;

@implementation DataHandler

@synthesize myFile, rootDict;

#pragma mark - Singleton Methods

- (id) init {
	@synchronized(self) {
        [self initPlist];
        [super init];
		return self;
    }
}

+ (DataHandler *)sharedDataHandler {
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

#pragma mark - Plists

- (void) initPlist {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~/Library/Application Support/Buttons for Arduino/";
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO) {
		[fileManager createDirectoryAtPath: folder withIntermediateDirectories:NO attributes:nil error:nil];
	}
    
	NSString *fileName = @"Settings.plist";
	NSString *plistPath = [folder stringByAppendingPathComponent:fileName];
		
	NSBundle *mainBundle;
	mainBundle = [NSBundle mainBundle];
	
	NSString *bundleFile = [mainBundle pathForResource:@"Settings" ofType:@"plist"];
	
	if([fileManager fileExistsAtPath:plistPath] == NO) {
		[fileManager copyItemAtPath:bundleFile toPath:plistPath error:nil];
	}
	
	self.myFile = plistPath;
	
	self.rootDict = [NSMutableDictionary dictionaryWithContentsOfFile:self.myFile];
	
}

#pragma mark - Getters

- (int) getTypeForPin:(int)p {
    NSNumber *type = [[self pinSettings:p] objectForKey:@"type"];
    if(type != nil) return [type intValue];
    return 99;
}

- (NSColor *) getColourForPin:(int)p {
    NSDictionary *colourDict = [[self pinSettings:p] objectForKey:@"colour"];
    NSNumber *r = [colourDict objectForKey:@"red"];
    NSNumber *g = [colourDict objectForKey:@"green"];
    NSNumber *b = [colourDict objectForKey:@"blue"];
    NSNumber *a = [colourDict objectForKey:@"alpha"];
    
    NSColor *saved = [NSColor colorWithCalibratedRed:[r doubleValue] green:[g doubleValue] blue:[b doubleValue] alpha:[a doubleValue]];
    return saved;
}

- (int) getValueForPin:(int)p {
    NSNumber *valNum = [[self pinSettings:p] objectForKey:@"val"];
    return [valNum intValue];
}

- (NSDictionary *) pinSettings:(int)p {
    NSString *key = [NSString stringWithFormat:@"%d", p];
    NSDictionary *pinDict = [self.rootDict objectForKey:key];
    return pinDict;
}

#pragma mark - Setters

- (void) setType:(int)t forPin:(int)p {
    NSMutableDictionary *editDict = [NSMutableDictionary dictionaryWithDictionary:[self pinSettings:p]];
    [editDict setObject:[NSNumber numberWithInt:t] forKey:@"type"];
    [self updateDict:editDict forPin:p];
}

- (void) setColour:(NSColor *)c forPin:(int)p {
    
    if([c colorSpace] == [NSColorSpace genericRGBColorSpace]) {
    
        NSNumber *r = [NSNumber numberWithDouble:[c redComponent]];
        NSNumber *g = [NSNumber numberWithDouble:[c greenComponent]];
        NSNumber *b = [NSNumber numberWithDouble:[c blueComponent]];
        NSNumber *a = [NSNumber numberWithDouble:1.0f];//[c alphaComponent]];
    
        NSMutableDictionary *colourDict = [[NSMutableDictionary alloc] initWithCapacity:4];
        [colourDict setObject:r forKey:@"red"];
        [colourDict setObject:g forKey:@"green"];
        [colourDict setObject:b forKey:@"blue"];
        [colourDict setObject:a forKey:@"alpha"];
    
        NSMutableDictionary *editDict = [NSMutableDictionary dictionaryWithDictionary:[self pinSettings:p]];
        [editDict setObject:colourDict forKey:@"colour"];
        [self updateDict:editDict forPin:p];
        
    }
    
}

- (void) setValue:(int)v forPin:(int)p {
    NSMutableDictionary *editDict = [NSMutableDictionary dictionaryWithDictionary:[self pinSettings:p]];
    [editDict setObject:[NSNumber numberWithInt:v] forKey:@"val"];
    [self updateDict:editDict forPin:p];
}

- (void) updateDict:(NSDictionary *)dict forPin:(int)p {
    NSString *key = [NSString stringWithFormat:@"%d", p];
    [self.rootDict setObject:dict forKey:key];
    [self.rootDict writeToFile:self.myFile atomically:YES];
}

@end
