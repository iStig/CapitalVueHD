//
//  CVMyStockFormView.m
//  TableDesign
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVMyStockFormView.h"


@implementation CVMyStockFormView

- (void)drawInContext:(CGContextRef)context
{
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, self.frame.size.width, 0);
	CGContextAddLineToPoint(context, self.frame.size.width, _headerHeight);
	CGContextAddLineToPoint(context, 0, _headerHeight);
	CGContextClosePath(context);
	CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	CGContextFillPath(context);
	
	CGContextSetLineWidth(context, 0.5);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextMoveToPoint(context, 0, 1);
	CGContextAddLineToPoint(context, self.frame.size.width, 1);
	CGContextStrokePath(context);
	CGContextMoveToPoint(context, 0, _headerHeight);
	CGContextAddLineToPoint(context, self.frame.size.width, _headerHeight);
	CGContextStrokePath(context);
	
	for (int i = 1; i < [self.dataArray count]; ++i)
	{
		CGContextMoveToPoint(context, 0, _headerHeight + _rowHeight*i);
		CGContextAddLineToPoint(context, self.frame.size.width, _headerHeight + _rowHeight*i);
		CGContextStrokePath(context);
	}
	
	CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
	CGContextMoveToPoint(context, 0, 2*_rowHeight+_headerHeight);
	CGContextAddLineToPoint(context, self.frame.size.width, 2*_rowHeight+_headerHeight);
	CGContextAddLineToPoint(context, self.frame.size.width, 3*_rowHeight+_headerHeight);
	CGContextAddLineToPoint(context, 0, _rowHeight*3+_headerHeight);
	CGContextClosePath(context);
	CGContextFillPath(context);
}

@end
