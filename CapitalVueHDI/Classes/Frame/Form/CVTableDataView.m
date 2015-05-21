//
//  CVTableDataView.m
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVTableDataView.h"
#import "CVTableLabel.h"
#import "CVLabelStyle.h"
#import "UIView+FrameAdjust.h"

@implementation CVTableDataView

@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
	if ( self = [super initWithFrame:frame] )
	{
		_labelArray = [NSMutableArray new];
		
	}
	return self;
}

- (void)dealloc
{
	[_labelArray release];
	
	[super dealloc];
}

- (void)reloadData
{
	CVTableLabel* label;
	
	for ( label in _labelArray )
	{
		[label removeFromSuperview];
	}
	[_labelArray removeAllObjects];
	
	for ( int i = 0; i < [self.dataSource rowNumber]; ++i )
	{
		for ( int j = 0; j < [self.dataSource columnNumber]; ++j )
		{
			CVTableLabel* label = [[CVTableLabel alloc] initWithFrame:[self.dataSource rectAtRow:i Column:j]];
			label.text = [self.dataSource dataAtRow:i Column:j];
			CVLabelStyle* style = [self.dataSource styleAtRow:i Column:j];
			label.font = style.font;
			label.textColor = style.foreColor;
			label.backgroundColor = style.backColor;
			label.textAlignment = style.textAlign;
			[self addSubview:label];
			[_labelArray addObject:label];
			[label release];
		}
	}
	
	CGRect lastRect = [self.dataSource rectAtRow:[self.dataSource rowNumber]-1 Column:[self.dataSource columnNumber]-1];
	
	float width = lastRect.size.width + lastRect.origin.x;
	float height = lastRect.size.height + lastRect.origin.y;
	[self setWidth:width];
	[self setHeight:height];
}


@end
