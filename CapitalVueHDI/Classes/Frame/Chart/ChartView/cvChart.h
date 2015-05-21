//
//  cvChart.h
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "cvChartFormatter.h"

#import "stockChartDataSource.h"


@interface cvChart : CALayer {
    NSArray *financialData;
	StockDataTimeFrame_e timeFrame;
    cvChartFormatterChart *chartCfg;
	
	float highest;
	float lowest;
	float _YMin, _YMax;
	float _YStep, _XStep;
	float _valueStep;
	
	//number of no use point for non-intra while chart is not full filled
	NSInteger _nonIntraInvalidNum;
	NSInteger _intrayInvalidNum;
	
	BOOL isPercent;
}

@property (nonatomic, retain) NSArray *financialData;
@property (nonatomic, assign) NSInteger nonIntraInvalidNum;
@property (nonatomic, assign) NSInteger intrayInvalidNum;
@property (nonatomic, assign) StockDataTimeFrame_e timeFrame;
@property (nonatomic, retain) cvChartFormatterChart *chartCfg;
@property BOOL isPercent;


-(id)initWithConfig:(cvChartFormatterChart *)cfg;

@end
