//
//  CVMenuItem.m
//  CapitalVueHD
//
//  Created by jishen on 9/3/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMenuItem.h"


@implementation CVMenuItem

@synthesize title;
@synthesize select;
@synthesize name;

- (void)dealloc {
	[title release];
	[name release];
	[super dealloc];
}

@end
