//
//  CVTextLayer.m
//  TextContext
//
//  Created by ANNA on 10-9-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVTextLayer.h"


@implementation CVTextLayer

@synthesize text = _text;
@synthesize font = _font;
@synthesize textColor = _textColor;

@synthesize angle = _angle;

- (void)dealloc
{
	[_font release];
	[_text release];
	[_textColor release];
	
	[super dealloc];
}

- (void)setAngle:(CGFloat)angle
{
	
}

- (void)drawInContext:(CGContextRef)context
{
	CGContextSelectFont( context, [[_font fontName] UTF8String], [_font pointSize], kCGEncodingMacRoman );
	CGContextSetTextDrawingMode( context, kCGTextFill );
	CGContextSetTextPosition( context, 0, -[_font descender] );
	CGContextSetFillColorWithColor(context, [_textColor CGColor]);
	CGContextShowText( context, [_text UTF8String], [_text length] );
	
}

@end
