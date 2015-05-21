//
//  CVTableLabel.m
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVTableLabel.h"

#define kLineWidth		1.0
#define kMarginWidth	5.0

@implementation CVTableLabel


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        _border = CVNoLine;
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect BorderType:(CVBorderType)border
{
	if ( self = [super initWithFrame:rect] )
	{
		_border = border;
	}
	return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	CGSize newSize = [super sizeThatFits:size];
	
	return CGSizeMake(newSize.width+2*kMarginWidth, newSize.height);
}


- (void)drawRect:(CGRect)rect 
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetLineWidth(context, kLineWidth);
	if ( _border & CVTopLine )
	{
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, self.frame.size.width, 0);
		CGContextStrokePath(context);
	}
	if ( _border & CVBottomLine )
	{
		CGContextMoveToPoint(context, 0, self.frame.size.height);
		CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
		CGContextStrokePath(context);
	}
	if ( _border & CVLeftLine )
	{
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, 0, self.frame.size.height);
		CGContextStrokePath(context);
	}
	if ( _border & CVRightLine )
	{
		CGContextMoveToPoint(context, self.frame.size.width, 0);
		CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
		CGContextStrokePath(context);
	}
	
	[super drawTextInRect:self.bounds];
}


@end
