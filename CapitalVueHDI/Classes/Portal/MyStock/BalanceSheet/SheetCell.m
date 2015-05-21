//
//  SheetCell.m
//  CapitalVueHD
//
//  Created by jishen on 10/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "SheetCell.h"


@implementation SheetCell

@synthesize type;
@synthesize isHeader;
@synthesize title;
@synthesize value;

- (void)dealloc {
	[title release];
	[value release];
	
	[super dealloc];
}

@end
