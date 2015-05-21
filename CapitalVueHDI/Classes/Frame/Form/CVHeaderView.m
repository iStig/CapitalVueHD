//
//  CVHeaderView.m
//  TableDesign
//
//  Created by ANNA on 10-8-11.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVHeaderView.h"
#import "CVTableLabel.h"
#import "CVLabelStyle.h"
#import "UIView+FrameAdjust.h"

@implementation CVHeaderView

@synthesize dataArray = _dataArray;
@synthesize styleArray = _styleArray;
@synthesize widthArray = _widthArray;
@synthesize accumArray = _accumArray;

@synthesize height	   = _height;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        _dataArray = [NSMutableArray new];
		_styleArray = [NSMutableArray new];
		_labelArray = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc 
{
	[_dataArray release];
	[_styleArray release];
	[_widthArray release];
	[_accumArray release];
	[_labelArray release];
	
    [super dealloc];
}

- (void)illustrateHeader:(NSMutableArray *)dataArray withStyle:(NSMutableArray *)styleArray
{
	NSAssert( [dataArray count] == [styleArray count], @"HeaderView, number of data and style do not match" );
	
	[_labelArray removeAllObjects];
	for (UIView* subView in [self subviews] )
	{
		[subView removeFromSuperview];
	}
	
	self.dataArray = dataArray;
	self.styleArray = styleArray;
	
	for (int i = 0; i < [self.dataArray count]; ++i)
	{
		float posx = [[_accumArray objectAtIndex:i] floatValue];
		float width = [[_widthArray objectAtIndex:i] floatValue];
		CVTableLabel* label = [[CVTableLabel alloc] initWithFrame:CGRectMake(posx, 0, width, self.height)];
		label.text = [self.dataArray objectAtIndex:i];
		CVLabelStyle* style = [self.styleArray objectAtIndex:i];
		label.textColor = style.foreColor;
		label.backgroundColor = style.backColor;
		label.font = style.font;
		label.textAlignment = style.textAlign;
		[self addSubview:label];
		[_labelArray addObject:label];
		[label release];
	}
	
	float width = [[_accumArray lastObject] floatValue] + [[_widthArray lastObject] floatValue];
	[self setWidth:width];
	[self setHeight:self.height];
}

@end
