//
//  CVIndexFormView.m
//  TableDesign
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVIndexFormView.h"


@implementation CVIndexFormView

@synthesize indexType = _indexType;

- (void)drawInContext:(CGContextRef)context
{
	UIImage* cell;
	if ( CVIndexGreen == _indexType )
	{
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"green_cell.png" ofType:nil];
		cell = [[UIImage alloc] initWithContentsOfFile:pathx];
	}
	else 
	{
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"red_cell.png" ofType:nil];
		cell = [[UIImage alloc] initWithContentsOfFile:pathx];
	}
	CGContextRotateCTM(context, M_PI);
	CGContextTranslateCTM(context, -self.frame.size.width , -self.frame.size.height);
	for (int i = 0; i < [self.dataArray count]; ++i)
	{
		CGRect rowRect = CGRectMake(0, _rowHeight*i, self.frame.size.width, _rowHeight);
		CGContextDrawImage(context, CGRectInset(rowRect, 0, 5.0), [cell CGImage]);
	}
	[cell release];
}

@end
