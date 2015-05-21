//
//  PieChartLayer.m
//  PieChart
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVPieChartLayer.h"
#import "CVPieUtil.h"
#import "CVTextLayer.h"

#define kEdgeWidth	15.0
#define kCenterRadius 30.0

@implementation CVPieChartLayer

@synthesize shareArray = _shareArray;
@synthesize shareAccumArray = _shareAccumArray;
@synthesize colorArray = _colorArray;
@synthesize rotateAngle = _rotateAngle;
@synthesize orietationOffset = _orietationOffset;
@synthesize chartDelegate = _chartDelegate;

- (void)dealloc
{
	[_shareArray release];
	[_shareAccumArray release];
	[_colorArray release];
	[_infoLayerArray release];
	
	[super dealloc];
}

- (void)adjustAngle
{
	float angle = 0.0;
	float currentStandard = _rotateAngle+_orietationOffset;
	
	while (currentStandard > 2*M_PI)
	{
		currentStandard -= 2*M_PI;
	}
	while ( currentStandard < 0)
	{
		currentStandard += 2*M_PI;
	}
	
	for (int i = 1; i < [_shareAccumArray count]; ++i)
	{
		float endAngle = [[_shareAccumArray objectAtIndex:i] floatValue];
		if ( endAngle > currentStandard )
		{
			float startAngle = [[_shareAccumArray objectAtIndex:i-1] floatValue];
			_currentRegion = i-1;
			angle = (startAngle + endAngle)/2 - currentStandard;
			break;
		}
	}
	
	[self rotate:angle];
	
	[self.chartDelegate didRunIntoRegion:_currentRegion];
}

- (void)rotate:(float)angle
{
	_rotateAngle += angle;
	self.transform = CATransform3DRotate(self.transform, angle, 0, 0, -1);
//	[self.layerDelegate layerRotateDegree:_rotateAngle];
	int totalCount = [_infoLayerArray count];
	for ( int i=0;i<totalCount;i++ )
	{
		CVTextLayer *layer = [_infoLayerArray objectAtIndex:i];
		layer.transform = CATransform3DRotate(layer.transform, angle, 0, 0, 1);
		
//		_orietationOffset = 0.0;
	}
}

- (void)addInfoLayers
{
	[_infoLayerArray release];
	_infoLayerArray = [NSMutableArray new];
	
	for (int i = 0; i < [_shareArray count]; ++i)
	{
		CVTextLayer* layer = [[CVTextLayer alloc] init];
		
		NSString* text = [NSString stringWithFormat:@"%.1f%%", [[_shareArray objectAtIndex:i] floatValue]*100];
		UIFont*	  font = [UIFont systemFontOfSize:15];
		UIColor*  color = [UIColor whiteColor];
		CGSize    size = [text sizeWithFont:font];
		layer.textColor = color;
		layer.text = text;
		layer.font = font;
		layer.geometryFlipped = YES;
		layer.transform = CATransform3DRotate(layer.transform, M_PI, 0, 0, 1);
		layer.backgroundColor = [[UIColor clearColor] CGColor];
		CGFloat curCenterDegree = [[_shareArray objectAtIndex:i] floatValue]/2*M_PI*2 + [[_shareAccumArray objectAtIndex:i] floatValue];
		float radius = self.frame.size.width/2;
		CGPoint pos = getInnerPos(radius, radius*3.0/4.0, curCenterDegree);	
		layer.position = pos;
		layer.bounds = CGRectMake(0, 0, size.width, size.height);
		[self addSublayer:layer];
		[_infoLayerArray addObject:layer];
		[layer setNeedsDisplay];
		[layer release];
	}
}

- (void)drawInContext:(CGContextRef)context
{
	if ( !_shareArray || !_colorArray )
	{
		NSLogv(@"color array or share array is NULL", nil);
		return;
	}
	
	NSAssert( [_shareArray count] == [_colorArray count], @"Share count does not match Color count");
	
	CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	CGFloat radius = self.bounds.size.width/2;// - kEdgeWidth;
	CGMutablePathRef path;
	
	for (int i = 0; i < [_shareAccumArray count] - 1; ++i)
	{
		path = CGPathCreateMutable();

		float startAngle = [[_shareAccumArray objectAtIndex:i] floatValue];
		float endAngle = [[_shareAccumArray objectAtIndex:i+1] floatValue];
		CGPoint pos1 = getPos(radius, [[_shareAccumArray objectAtIndex:i] floatValue]);
		CGPathMoveToPoint(path, NULL, center.x, center.y);
		CGPathAddLineToPoint(path, NULL, pos1.x, pos1.y);
		CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, CVClockWise);
		CGPathCloseSubpath(path);
		
		UIColor* fillColor = [_colorArray objectAtIndex:i];
		CGContextSetFillColorWithColor(context, [fillColor CGColor]);
		CGContextAddPath(context, path);
		CGContextFillPath(context);
		CGPathRelease(path);
	}
	
	//path = CGPathCreateMutable();
//	CGPathAddEllipseInRect(path, NULL, CGRectInset(self.bounds, radius - kCenterRadius, radius-kCenterRadius));
//	CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.4 alpha:0.3] CGColor]);
//	CGContextAddPath(context, path);
//	CGContextFillPath(context);
//	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
//	CGContextAddPath(context, path);
//	CGContextStrokePath(context);
//	CGPathRelease(path);
//	
//	path = CGPathCreateMutable();
//	CGPathAddEllipseInRect(path, NULL, CGRectInset(self.bounds, kEdgeWidth, kEdgeWidth));
//	CGPathAddEllipseInRect(path, NULL, self.bounds);
//	CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
//	CGContextAddPath(context, path);
//	CGContextEOFillPath(context);
//	CGPathRelease(path);
//	
//	CGFloat componets [] = {0.0, 0.0, 0.0, 0.5,0.0,0.0,0.0,0.1};
//	
//	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//	
//	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, componets, nil, 2);
//	CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0 );
}


- (void) adjustToIndex:(int)index
{
	float startAngle,endAngle,angle;

		startAngle = [[_shareAccumArray objectAtIndex:index] floatValue];
		endAngle = [[_shareAccumArray objectAtIndex:index+1] floatValue];
		
	angle = (startAngle + endAngle)/2.0;
	float standard = _rotateAngle + _orietationOffset;
	angle -= standard;
	[self rotate:angle];
	int totalCount = [_infoLayerArray count];
	for (int i=0;i<totalCount;i++ )
	{
		CVTextLayer* layer = [_infoLayerArray objectAtIndex:i];
		layer.transform = CATransform3DRotate(CATransform3DIdentity, _rotateAngle, 0, 0, 1);
		if ([[[layer.text componentsSeparatedByString:@"%"] objectAtIndex:0] floatValue] < 8.0 && [_infoLayerArray indexOfObject:layer]!=index)
			layer.hidden = YES;
		else
			layer.hidden = NO;
			
		
		//		_orietationOffset = 0.0;
	}
//	[self adjustAngle];
}
@end
