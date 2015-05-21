//
//  CVLabelStyle.m
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVLabelStyle.h"


@implementation CVLabelStyle

@synthesize font, foreColor, backColor, textAlign;

- (id)init
{
	if ( self = [super init] )
	{
		font = [[UIFont systemFontOfSize:20] retain];
		foreColor = [[UIColor blackColor] retain];
		backColor = [[UIColor clearColor] retain];
		textAlign = UITextAlignmentCenter;
	}
	return self;
}

- (void)dealloc
{
	[font release];
	[foreColor release];
	[backColor release];
	
	[super dealloc];
}

-(id)cloneOne{
	CVLabelStyle *labelStyle = [[CVLabelStyle alloc] init];
	labelStyle.font = font;
	labelStyle.foreColor = foreColor;
	labelStyle.backColor = backColor;
	labelStyle.textAlign = textAlign;
	return labelStyle;
}

@end
