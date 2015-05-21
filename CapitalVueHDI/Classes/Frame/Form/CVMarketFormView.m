//
//  CVMarketFormView.m
//  TableDesign
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVMarketFormView.h"


@implementation CVMarketFormView

- (void)drawInContext:(CGContextRef)context
{
	CGContextRotateCTM(context, M_PI);
	CGContextTranslateCTM(context, -self.frame.size.width, -self.frame.size.height);
	CGContextSaveGState(context);
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"header_grade.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	CGRect headerRect = CGRectMake(0, self.frame.size.height-_headerHeight, self.frame.size.width, _headerHeight);
	CGContextDrawImage(context, headerRect, [image CGImage]);
	[image release];
}

@end
