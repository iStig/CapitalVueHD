//
//  RectImage.m
//  CapitalVueHD
//
//  Created by Dream on 10-9-25.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "RectImage.h"
#import "CVPortal.h"

@implementation RectImage

@synthesize lblLeft;
@synthesize lblCenter;
@synthesize lblRight;
@synthesize btnAction;

@synthesize code;

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	self.userInteractionEnabled = YES;
	UILabel *left = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width, frame.size.height)];
	UILabel *centerL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(-15, 0, frame.size.width, frame.size.height)];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	left.backgroundColor = [UIColor clearColor];
	centerL.backgroundColor = [UIColor clearColor];
	right.backgroundColor = [UIColor clearColor];
	left.textAlignment = UITextAlignmentLeft;
	centerL.textAlignment = UITextAlignmentCenter;
	right.textAlignment = UITextAlignmentRight;
	left.textColor = [UIColor blackColor];
	centerL.textColor = [UIColor blackColor];
	right.textColor = [UIColor blackColor];
	button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	[button addTarget:self action:@selector(actionRespondTapping:) forControlEvents:UIControlEventTouchUpInside];
	UIFont *boldLabelFont = [UIFont boldSystemFontOfSize:14];
	UIFont *normalLabelFont = [UIFont systemFontOfSize:14];
	left.font = boldLabelFont;
	centerL.font = normalLabelFont;
	right.font = normalLabelFont;
	
	[self addSubview:left];
	[self addSubview:centerL];
	[self addSubview:right];
	[self addSubview:button];
	
	
	self.lblLeft = left;
	self.lblCenter = centerL;
	self.lblRight = right;
	self.btnAction = button;
	
	[left release];
	[centerL release];
	[right release];	
	return self;
}

- (void) dealloc
{
	[lblLeft release];
	[lblCenter release];
	[lblRight release];
	[btnAction release];
	
	[code release];
	
	[super dealloc];
}


- (IBAction)actionRespondTapping:(id)sender {
	if (nil != lblLeft.text) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		if (code) {
			[dict setObject:code forKey:@"code"];
			[dict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
			[dict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
			[[NSNotificationCenter defaultCenter] 
			 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
		}
		[dict autorelease];
	}
}

@end
