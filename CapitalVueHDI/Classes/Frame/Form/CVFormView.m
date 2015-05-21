//
//  CVTableView.m
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVFormView.h"
#import "CVTableDataView.h"
#import "CVHeaderView.h"
#import "CVTableLabel.h"
#import "CVIndexButton.h"
#import "CVLabelStyle.h"
#import "NSArray+Sort.h"
#import "UIView+FrameAdjust.h"
#import "UIColor+DespInit.h"

@interface CVFormView()

- (void)analyticSize;
- (void)reloadButton;
- (CVLabelStyle *)styleForRow:(int)row Column:(int)column;

@end


@implementation CVFormView

@synthesize dataArray = _dataArray;
@synthesize styleArray = _styleArray;
@synthesize widthArray = _widthArray;
@synthesize spaceArray = _spaceArray;
@synthesize headerArray = _headerArray;
@synthesize headerStyleArray = _headerStyleArray;
@synthesize rowHeight = _rowHeight;
@synthesize headerHeight = _headerHeight;
@synthesize selfAdjust = _selfAdjust;
@synthesize formDelegate = _formDelegate;
@synthesize filterArray = _filterArray;
@synthesize filterPath  = _filterPath;


@synthesize isFiltered;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame]))
	{
        _buttonArray = [NSMutableArray new];
		_widthArray = [NSMutableArray new];
		_accumArray = [NSMutableArray new];
		_styleArray = [NSMutableArray new];
		_rowButtonArray = [NSMutableArray new];
		_dataArray = [NSMutableArray new];
		
		_dataView = [[CVTableDataView alloc] initWithFrame:CGRectZero];
		_dataView.dataSource = self;
		[self addSubview:_dataView];
		
		_headerView = [[CVHeaderView alloc] initWithFrame:CGRectZero];
		[self addSubview:_headerView];
		
		_ascending = YES;
		_selfAdjust = NO;
    }
    return self;
}

- (void)dealloc 
{
	[_dataArray release];
	[_buttonArray release];
	[_dataView release];
	[_headerView release];
	[_headerArray release];
	[_headerStyleArray release];
	[_widthArray release];
	[_spaceArray release];
	[_accumArray release];
	[_styleArray release];
	[_rowButtonArray release];
	[_filterArray release];
	[_filterPath  release];
	
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
	//nothing to do in the super class
}

- (void)illustrateAll
{
	if ( self.filterArray && (NO == isFiltered))
	{
		for (int i = 0; i < [self.dataArray count]; ++i)
		{
			NSMutableArray* filterElem = [[self.dataArray objectAtIndex:i] filterWithArray:self.filterArray];
			[self.dataArray replaceObjectAtIndex:i withObject:filterElem];
		}
		self.headerArray= [self.headerArray filterWithArray:self.filterArray];
		isFiltered = YES;
	}
//	self.dataArray = [self.dataArray filterWithArrayInFile:self.filterPath];
//	self.headerArray = [self.headerArray filterWithArrayInFile:self.filterPath];
	
	[self analyticSize];

	_headerView.height = _headerHeight;
	_headerView.widthArray = _widthArray;
	_headerView.accumArray = _accumArray;
	[_headerView illustrateHeader:self.headerArray withStyle:self.headerStyleArray];
	
	[_dataView reloadData];
	[_dataView setPosY:_headerHeight];

	[self reloadButton];
	
	if ( self.selfAdjust )
	{
		[self setWidth:_dataView.frame.size.width];
		[self setHeight:_dataView.frame.origin.y + _dataView.frame.size.height];
	}
}

#pragma mark -
#pragma mark CVTableDataViewDataSource
- (int)rowNumber
{
	return [self.dataArray count];
}

- (int)columnNumber
{
	return [[self.dataArray objectAtIndex:0] count];
}

- (CGRect)rectAtRow:(int)row Column:(int)column
{
	float posx = [[_accumArray objectAtIndex:column] floatValue];
	float posy = row * _rowHeight;
	float width = [[_widthArray objectAtIndex:column] floatValue];
	if (self.spaceArray != nil) {
		width -= [[self.spaceArray objectAtIndex:column] floatValue];
	}
	return CGRectMake(posx, posy, width, _rowHeight);
}

- (NSString *)dataAtRow:(int)row Column:(int)column
{
	return [[self.dataArray objectAtIndex:row] objectAtIndex:column];
}

- (CVLabelStyle *)styleAtRow:(int)row Column:(int)column
{
	return [self styleForRow:row Column:column];
}

- (void)sortData:(CVIndexButton *)button
{
	[self.dataArray sortWithSubIndex:button.index ascending:_ascending];
	_ascending = !_ascending;
	[_dataView reloadData];
}

- (void)jumpForRow:(CVIndexButton *)button
{
	[self.formDelegate didSelectRow:button.index];
}

#pragma mark -
#pragma mark Private Method
- (void)analyticSize
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[_accumArray removeAllObjects];
	

	
	if ( [_widthArray count] != [[self.dataArray objectAtIndex:0] count] )
	{
		[_widthArray removeAllObjects];
		for (int i = 0; i < [[self.dataArray objectAtIndex:0] count]; ++i)
		{
			[_widthArray addObject:[NSNumber numberWithFloat:0.0]];
		}
	}
	
	CVTableLabel* label = [[CVTableLabel alloc] initWithFrame:CGRectZero];
	for (int i = 0; i < [self.dataArray count]; ++i)
	{
		for (int j = 0; j < [[self.dataArray objectAtIndex:0] count]; ++j)
		{
			label.text = [[self.dataArray objectAtIndex:i] objectAtIndex:j];			
			CVLabelStyle* style = [self styleForRow:i Column:j];
			label.font = style.font;
			[label sizeToFit];
			
			float width = label.frame.size.width;
			if ( width > [[_widthArray objectAtIndex:j] floatValue] )
			{
				[_widthArray replaceObjectAtIndex:j withObject:[NSNumber numberWithFloat:width]];
			}
		}
	}
	
	for (int i = 0; i < [self.headerArray count]; ++i)
	{
		label.text = [self.headerArray objectAtIndex:i];
		label.font = [[self.headerStyleArray objectAtIndex:i] font];
		[label sizeToFit];
		
		float width = label.frame.size.width;
		if ( width > [[_widthArray objectAtIndex:i] floatValue] )
		{
			[_widthArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:width]];
		}
	}
	[label release];
	
	[_accumArray addObject:[NSNumber numberWithFloat:0.0]];
	for (int i = 1; i < [[self.dataArray objectAtIndex:0] count]; ++i)
	{
		float accumWidth  = [[_accumArray lastObject] floatValue] + [[_widthArray objectAtIndex:i-1] floatValue];
		[_accumArray addObject:[NSNumber numberWithFloat:accumWidth]];
	}
	
	[pool release];
}

- (void)reloadButton
{
	for ( CVIndexButton* indexButton in _buttonArray )
	{
		[indexButton removeFromSuperview];
	}
	for (CVIndexButton* indexButton in _rowButtonArray )
	{
		[indexButton removeFromSuperview];
	}
	[_buttonArray removeAllObjects];
	[_rowButtonArray removeAllObjects];
	
	for ( int i = 0; i < [_headerArray count]; ++i )
	{
		float posx = [[_accumArray objectAtIndex:i] floatValue];
		float width = [[_widthArray objectAtIndex:i] floatValue];
		CVIndexButton* indexButton = [[CVIndexButton alloc] initWithFrame:CGRectMake(posx, 0, width, self.headerHeight)];
		indexButton.index = i;
		[indexButton addTarget:self action:@selector(sortData:) forControlEvents:UIControlEventTouchUpInside];
		indexButton.backgroundColor = [UIColor clearColor];
		[self addSubview:indexButton];
		[_buttonArray addObject:indexButton];
		[indexButton release];
	}
	
	for (int i = 0; i < [_dataArray count]; ++i)
	{
		float posy = i*self.rowHeight + self.headerHeight;
		CVIndexButton* rowButton = [[CVIndexButton alloc] initWithFrame:CGRectMake(0, posy,
																					 _dataView.frame.size.width, self.rowHeight)];
		rowButton.index = i;
		[rowButton addTarget:self action:@selector(jumpForRow:) forControlEvents:UIControlEventTouchUpInside];
		rowButton.backgroundColor = [UIColor clearColor];
		[self addSubview:rowButton];
		[_rowButtonArray addObject:rowButton];
		[rowButton release];
	}
}

- (CVLabelStyle *)styleForRow:(int)row Column:(int)column
{
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FormViewStyle" ofType:@"plist"];
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	int keyColumn = [[dict objectForKey:@"KeyColumn"] intValue];
	int fontSize = [[dict objectForKey:@"Size"] floatValue];
	int start    = [[dict objectForKey:@"Start"] intValue];
	NSString* incColor = [dict objectForKey:@"Inc"];
	NSString* decColor = [dict objectForKey:@"Dec"];
	UITextAlignment align = [[dict objectForKey:@"Align"] intValue];
	
	CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];
	if ( column < start)
	{
		labelStyle.font = [UIFont boldSystemFontOfSize:20.0];
		labelStyle.textAlign = UITextAlignmentCenter;
		labelStyle.foreColor = [UIColor whiteColor];
		labelStyle.backColor = [UIColor clearColor];
	}
	else 
	{
		labelStyle.font = [UIFont systemFontOfSize:fontSize];
		labelStyle.textAlign = align;
		labelStyle.backColor = [UIColor clearColor];
		float keyValue = [[[self.dataArray objectAtIndex:row] objectAtIndex:keyColumn] floatValue];
		if (keyValue < 0 )
		{
			labelStyle.foreColor = [UIColor colorWithDesp:decColor];
		}
		else 
		{
			labelStyle.foreColor = [UIColor colorWithDesp:incColor];
		}
	}
	
	return [labelStyle autorelease];	
}

+ (NSMutableArray *)dataArrayFromDict:(NSDictionary *)dict
{
	NSArray * roughArray = [dict objectForKey:@"data"];
	NSMutableArray *trimArray = [NSMutableArray array];
	for (int i = 0; i < [roughArray count]; ++i)
	{
		NSMutableArray* innerArray = [NSMutableArray array];
		NSArray* roughInnerArray = [roughArray objectAtIndex:i];
		for (int j = 0; j < [roughInnerArray count]; ++j)
		{
			[innerArray addObject:[[roughInnerArray objectAtIndex:j] objectForKey:@"value"]];
		}
		[trimArray addObject:innerArray];
	}
	return trimArray;
}

+ (NSMutableArray *)headerArrayFromDict:(NSDictionary *)dict
{
	NSArray* roughArray = [dict objectForKey:@"head"];
	NSMutableArray* trimArray = [NSMutableArray array];
	for (int i = 0; i < [roughArray count]; ++i)
	{
		[trimArray addObject:[[roughArray objectAtIndex:i] objectForKey:@"value"]];
	}
	return trimArray;
}

@end
