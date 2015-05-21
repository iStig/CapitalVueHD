//
//  CVDataMacroChartSample.m
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVDataMacroChartSample.h"


@implementation CVDataMacroChartSample

@synthesize date;
@synthesize growth;
@synthesize value;

-(void)dealloc {
	[date release];
	[super dealloc];
}

@end
