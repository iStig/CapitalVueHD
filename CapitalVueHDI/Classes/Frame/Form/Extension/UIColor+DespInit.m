//
//  UIColor+NumberInit.m
//  CapitalVueHD
//
//  Created by ANNA on 10-8-29.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "UIColor+DespInit.h"


@implementation UIColor(DespInit)

+ (UIColor *)colorWithDesp:(NSString *)colorDesp
{
	float alpha  =  strtoul([[colorDesp substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16) / 256.0;
	float red    =  strtoul([[colorDesp substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16) / 256.0;
	float green  =  strtoul([[colorDesp substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16) / 256.0;
	float blue   =  strtoul([[colorDesp substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16) / 256.0;
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
