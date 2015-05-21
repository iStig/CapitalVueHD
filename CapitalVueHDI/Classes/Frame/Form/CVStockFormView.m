//
//  CVStockFormView.m
//  TableDesign
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVStockFormView.h"


@implementation CVStockFormView

- (void)drawInContext:(CGContextRef)context
{
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"line_seperator.png" ofType:nil];
	UIImage *seperator = [[UIImage alloc] initWithContentsOfFile:pathx];
	
	for ( int i = 1; i < [self.dataArray count] ; ++i)
	{
		CGRect seperatorRect = CGRectMake(0, _headerHeight + i*_rowHeight, self.frame.size.width, 1.0);
		CGContextDrawImage(context, seperatorRect, [seperator CGImage]);
	}
	[seperator release];
}

@end
