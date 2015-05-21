//
//  CVMacroFormView.m
//  TableDesign
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVMacroFormView.h"

#define kEndMargin	5.0

@implementation CVMacroFormView

- (void)drawInContext:(CGContextRef)context
{
	CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
	CGContextSetLineWidth(context, 3.0);
	
	CGContextMoveToPoint(context, 0, _headerHeight);
	CGContextAddLineToPoint(context, self.frame.size.width - kEndMargin, _headerHeight);
	CGContextStrokePath(context);
	
	CGContextSetLineWidth(context, 1.0);
	for (int i = 1; i <= [self.dataArray count]; ++i)
	{
		CGContextMoveToPoint(context, 0, _headerHeight+_rowHeight*i);
		CGContextAddLineToPoint(context, self.frame.size.width - kEndMargin, _headerHeight + _rowHeight*i);
		CGContextStrokePath(context);
	}
	
	for (int i = 1; i < [_accumArray count]; ++i)
	{
		float posx = [[_accumArray objectAtIndex:i] floatValue];
		CGContextMoveToPoint(context, posx, _headerHeight + 2.0);
		CGContextAddLineToPoint(context, posx, self.frame.size.height);
		CGContextStrokePath(context);
	}
}

@end
