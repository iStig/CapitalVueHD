//
//  PieChartLayer.h
//  PieChart
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVPieChartProtocol.h"

enum CVPieClockDirection
{
	CVClockWise = 0,
	CVCounterClockWise = 1
};
typedef enum CVPieClockDirection CVPieClockDirection;

@interface CVPieChartLayer : CALayer
{
	NSMutableArray* _shareArray;
	NSArray* _colorArray;
	NSMutableArray*	_infoLayerArray;
	NSMutableArray* _shareAccumArray;
	
	float	_rotateAngle;
	float	_orietationOffset;
	int		_currentRegion;
	
	id<CVPiewChartDelegate>	_chartDelegate;
}

@property (nonatomic, retain) NSArray* shareArray;
@property (nonatomic, retain) NSMutableArray* shareAccumArray;
@property (nonatomic, retain) NSArray* colorArray;
@property (nonatomic, assign) float rotateAngle;
@property (nonatomic, assign) float orietationOffset;

@property (nonatomic, assign) id<CVPiewChartDelegate> chartDelegate;

- (void)adjustAngle;

- (void)rotate:(float)angle;
- (void)addInfoLayers;
- (void) adjustToIndex:(int)index;

@end
