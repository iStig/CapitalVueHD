//
//  CVShareInfoContentView.m
//  PieChart
//
//  Created by ANNA on 10-9-19.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVShareInfoContentView.h"
#import "UIView+FrameInfo.h"
#import "CVPieChartConstants.h"

@implementation CVShareInfoContentView
@synthesize fLinePosX;

- (void)drawRect:(CGRect)rect 
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}


- (void)drawInContext:(CGContextRef)context
{
	return;
	CGFloat tableY=0.0;
	CGFloat tableHeight=0.0;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation==UIInterfaceOrientationLandscapeLeft
		|| orientation==UIInterfaceOrientationLandscapeRight)
	{
		fLinePosX = kSLPosx;
		tableY = kTableInitPosL;
		tableHeight = kLabelHeightL;
	}
	else
	{
		fLinePosX = kSLPosx-50;
		tableY = kTableInitPosP;
		tableHeight = kLabelHeightP;
	}
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"line.png" ofType:nil];
	UIImage *lineImage = [[UIImage alloc] initWithContentsOfFile:pathx];
	for (int i = 1; i <= 4; ++i)
	{		
		CGRect   lineRect = CGRectMake(0, tableY + i*tableHeight, [self width], 1.0);
		CGContextDrawImage(context, lineRect, [lineImage CGImage]);
	}
	
	CGRect upVerticalRect = CGRectMake(fLinePosX - 10, tableY, 1, tableHeight*2);
	CGContextDrawImage(context, upVerticalRect, [lineImage CGImage]);
	
	CGRect downVerticalRect = CGRectMake(fLinePosX - 10., tableHeight*3 + tableY, 1, tableHeight*2);
	CGContextDrawImage(context, downVerticalRect, [lineImage CGImage]);
	[lineImage release];
}


@end
