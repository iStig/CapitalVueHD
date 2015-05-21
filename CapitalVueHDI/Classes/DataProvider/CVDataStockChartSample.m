//
//  CVDataStockChartSample.m
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVDataStockChartSample.h"


@implementation CVDataStockChartSample

@synthesize date;
@synthesize cjl;
@synthesize cjlRZdj;
@synthesize cjlRSpj;
@synthesize cjje;
@synthesize cjjeRKpj;
@synthesize cjjeRZgj;

-(void)dealloc {
	[date release];
	[super dealloc];
}

@end
