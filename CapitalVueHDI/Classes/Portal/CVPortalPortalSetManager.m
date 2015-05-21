//
//  CVPortalPortalSetManager.m
//  CapitalVueHD
//
//  Created by jishen on 8/30/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalPortalSetManager.h"

@interface CVPortalPortalSetManager()

@property (nonatomic, retain) NSMutableArray *arrayPortalSet;

@end

@implementation CVPortalPortalSetManager

@synthesize arrayPortalSet;

- (id)init {
    if ((self = [super init])) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		// PortalSet are created lazily. Never load it until need.
		for (unsigned i = 0; i < CVPortalSetTypeMax; i++) {
			[array addObject:[NSNull null]];
		}
		self.arrayPortalSet = array;
	}
	
	return self;
}

- (void)dealloc {
	[arrayPortalSet release];
	[super dealloc];
}

/*
 * It stores the PortalSet.
 *
 * @param: controller - a controller of PortalSet
 *         type - the PortalSet type
 * @return: YES if it is stored, else NO
 */
- (BOOL)setPortalSet:(id)controller type:(CVPortalSetType)type {
	BOOL isSet;
	
	isSet = NO;
	
	if (nil != controller && type < CVPortalSetTypeMax) {
		[arrayPortalSet replaceObjectAtIndex:type withObject:controller];
		isSet = YES;
	}
	
	return isSet;
}

/*
 * It returns the specified controller of PortalSet
 *
 * @param: type - the specified PortalSet
 * @return: controller of PortalSet
 */
- (id)getPortalSet:(CVPortalSetType)type {
	id obj;
	
	obj = nil;
	
	if (type < CVPortalSetTypeMax) {
		obj = [arrayPortalSet objectAtIndex:type];
		if ([NSNull null ] == (NSNull *)obj)
			obj = nil;
	}
	
	return obj;
}

/*
 * It checks whether the specified PortalSet has already
 * created and cached.
 *
 * @param: type - the specified PortalSet
 * @return: YES if existed, else NO.
 */
- (BOOL)isPortalSetExisted:(CVPortalSetType)type {
	BOOL isExist;
	
	isExist = NO;
	if (nil != [self getPortalSet:type])
		isExist = YES;
	
	return isExist;
}

@end
