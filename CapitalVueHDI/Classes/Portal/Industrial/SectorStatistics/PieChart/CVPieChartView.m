//
//  CVPieChartView.m
//  CapitalVueHD
//
//  Created by ANNA on 10-9-19.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPieChartView.h"
#import "CVPieChart.h"
#import "CVShareInfoView.h"
#import "UIView+FrameInfo.h"

@implementation CVPieChartView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		_chartView = [[CVPieChart alloc] initWithFrame:CGRectMake((frame.size.width - kVertiacalChartWidth)/2, 40, 
																  kVertiacalChartWidth, kVertiacalChartWidth)];
		_chartView.userInteractionEnabled = YES;
		_chartView.pieLayer.chartDelegate = self;
		[self addSubview:_chartView];
		_chartView.backgroundColor = [UIColor clearColor];
		
		//_shareInfoView = [[CVShareInfoView alloc] initWithFrame:CGRectMake((frame.size.width - kHorizonalInfoWidth)/2,
//																			kVertiacalChartWidth, kVertiacalInfoWidth, kVertiacalInfoHeight)];
//		_shareInfoView.viewType = CVPiewViewVertical;
//		_shareInfoView.backgroundColor = [UIColor clearColor];
//		[self addSubview:_shareInfoView];
    }
    return self;
}

- (void)dealloc 
{
//	[_shareInfoView release];
	[_chartView release];
	
    [super dealloc];
}

- (void)orietationChangedTo:(CVPieViewType)viewType
{
	if ( CVPiewViewVertical == viewType )
	{
		// frame for landscape
		_chartView.frame = CGRectMake(0, 20, kVertiacalChartWidth, kVertiacalChartWidth);
		//_shareInfoView.frame = CGRectMake([_chartView width] - 40,
//										  25, kVertiacalInfoWidth, kVertiacalInfoHeight);
//		_shareInfoView.viewType = CVPieViewHorizonal;
		[_chartView changeViewTypeTo:CVPieViewHorizonal];
	}
	else
	{
		// frame for portrait
		_chartView.frame = CGRectMake((self.frame.size.width - kHorizonalChartWidth)/2, 40, kHorizonalChartWidth, kHorizonalChartWidth);
		//_shareInfoView.frame = CGRectMake(0,
//										  kHorizonalChartWidth, kVertiacalInfoWidth, kVertiacalInfoHeight);
//		_shareInfoView.viewType = CVPiewViewVertical;
		[_chartView changeViewTypeTo:CVPiewViewVertical];
	}
}

- (void)setSum:(NSString *)sum
{
	_chartView.total = sum;
}

- (void)illustrateShareArray:(NSMutableArray *)shareArray colorArray:(NSMutableArray *)colorArray
{
	[_chartView illustrateShare:shareArray color:colorArray];
}

#pragma mark -
#pragma mark CVPieChart delegate
- (void)didRunIntoRegion:(int)index
{
	//CVShareInfo* shareInfo;
//	shareInfo = [delegate sectorShareInfoAtIndex:index];
//
	//	[_shareInfoView showData:shareInfo];
	[delegate didRunIntoRegion:index];
}


//Dream's
- (void)adjustToIndex:(int)index
{
	[_chartView adjustToIndex:index];
}

- (BOOL) isMoving
{
	return _chartView.isMoving;
}
@end
