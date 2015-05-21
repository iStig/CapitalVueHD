//
//  CVPieChartView.h
//  PieChart
//
//  Created by ANNA on 10-8-13.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPieChartLayer.h"
#import "CVPieChartConstants.h"


@interface CVPieChart : UIView 
{
	CVPieChartLayer* _pieLayer;
	UILabel*		 _sumInfoLabel;
	NSMutableArray*		 _shareArray;
	NSMutableArray*	 _shareAccumArray;
	
	NSString*		 _total;
	CGPoint			 _startPoint;
	CGFloat			 _lastAngle;
	
	NSTimer*		 _timer;
	BOOL			 _moved;
	
	CVPieViewType	 _viewType;
	UIImageView *imgvPieBottom;
	UIImageView *imgvPieCover;
	BOOL	isMoving;

}

@property (nonatomic, readonly) CVPieChartLayer* pieLayer;
@property (nonatomic, copy)		NSString* total;
@property (nonatomic, retain)	NSMutableArray* shareArray;
@property (nonatomic, retain)	NSMutableArray*	 shareAccumArray;
@property (nonatomic, assign)	CVPieViewType	  viewType;
@property BOOL isMoving;
- (void)illustrateShare:(NSMutableArray *)shareArray color:(NSMutableArray *)colorArray;
- (void)changeViewTypeTo:(CVPieViewType)viewType;

- (void)timerAlert:(NSTimer *)timer;
- (void) adjustToIndex:(int)index;

@end
