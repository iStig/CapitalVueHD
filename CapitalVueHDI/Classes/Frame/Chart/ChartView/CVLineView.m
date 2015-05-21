//
//  CVLineView.m
//  LineChart
//
//  Created by ANNA on 10-7-20.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVLineView.h"

@interface CVLineView()

- (void)drawInContext:(CGContextRef)context;

@end


@implementation CVLineView

@synthesize fillColor;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        fillColor = [[UIColor alloc] initWithRed:0.7 green:0.3 blue:1.0 alpha:0.7];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
    float r, g, b, a;
    float *currColor = (float *)CGColorGetComponents([fillColor CGColor]);
    
    r = currColor[0]; g = currColor[1];
    b = currColor[2]; a = currColor[3];
	CGContextSetRGBFillColor(context, r, g, b, a);
	CGContextFillRect(context, self.bounds);
}

- (void)dealloc {
    [fillColor release];
    [super dealloc];
}


@end
