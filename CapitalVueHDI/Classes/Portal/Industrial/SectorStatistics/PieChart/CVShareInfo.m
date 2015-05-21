//
//  CVShareInfo.m
//  PieChart
//
//  Created by ANNA on 10-9-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVShareInfo.h"


@implementation CVShareInfo

@synthesize sectorCode, co, chg, gainers, decliners, tradable, netmargin, roe, pe, pb, title, date, coTitle, chgTitle, gainersTitle, declinersTitle, tradableTitle, netmarginTitle, roeTitle, peTitle, pbTitle;

- (void)dealloc
{
	[sectorCode release];
	[coTitle release];
	[chgTitle release];
	[gainersTitle release];
	[declinersTitle release];
	[tradableTitle release];
	[netmarginTitle release];
	[roeTitle release];
	[peTitle release];
	[pbTitle release];
	
	[co release];
	[chg release];
	[gainers release];
	[decliners release];
	[tradable release];
	[netmargin release];
	[roe release];
	[pe release];
	[pb release];
	
	[title release];
	[date release];
	
	[super dealloc];
}

@end
