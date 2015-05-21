//
//  CVPieChartView.h
//  CapitalVueHD
//
//  Created by ANNA on 10-9-19.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPieChartConstants.h"
#import "CVPieChartProtocol.h"
#import "CVShareInfo.h"

@protocol CVPieChartViewDelegate

- (CVShareInfo *)sectorShareInfoAtIndex:(int)index;

- (void) postNotificationToScroll:(NSInteger)index;

@end


@class CVPieChart;
@class CVShareInfoView;

@interface CVPieChartView : UIView <CVPiewChartDelegate>
{
	id <CVPieChartViewDelegate,CVPiewChartDelegate> delegate;
	CVPieChart* _chartView;
	CVShareInfoView* _shareInfoView;
}

@property (nonatomic, assign) id <CVPieChartViewDelegate,CVPiewChartDelegate> delegate;

- (void)orietationChangedTo:(CVPieViewType)viewType;
- (void)setSum:(NSString *)sum;
- (void)illustrateShareArray:(NSMutableArray *)shareArray colorArray:(NSMutableArray *)colorArray;
- (void) adjustToIndex:(int)index;
- (BOOL) isMoving;
@end
