//
//  CVCharDataLoadOperation.m
//  CapitalVueHD
//
//  Created by jishen on 9/15/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVChartDataLoadOperation.h"
#import "CVDataProvider.h"


@implementation CVChartDataLoadOperation

@synthesize code;
@synthesize symbol;
@synthesize index;
@synthesize defaultImage;

@synthesize delegate;

 
- (void)dealloc {
	[code release];
	[symbol release];
	
	[defaultImage release];
	
	[super dealloc];
}


@end
