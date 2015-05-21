//
//  CVDataNews.m
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVDataNews.h"


@implementation CVDataNews

@synthesize postId;
@synthesize title;
@synthesize body;
@synthesize ownerId;
@synthesize timeStamp;
@synthesize setId;
@synthesize groupId;
@synthesize groupDn;
@synthesize summary;
@synthesize typeId;
@synthesize tagList;
@synthesize url;
@synthesize textBody;
@synthesize thumbUrl;
@synthesize smallThumbUrl;
@synthesize thumbSize;
@synthesize smallThumbSize;
@synthesize tagListText;

-(void)dealloc {
	[postId release];
	[title release];
	[body release];
	[ownerId release];
	[setId release];
	[groupId release];
	[groupDn release];
	[summary release];
	[typeId release];
	[tagList release];
	[url release];
	[textBody release];
	[thumbUrl release];
	[smallThumbUrl release];
	[tagListText release];
	[super dealloc];
}

@end
