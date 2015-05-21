//
//  cvChartLegend.h
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "cvChartFormatter.h"


@interface cvChartLegend : CALayer {
    NSArray *financialData;
    cvChartFormatterLegend *legendCfg;
    int focusIndex;
	NSMutableArray *aryTitles;
	NSString *_langCode;
}

@property (nonatomic, retain) NSArray *financialData;
@property (nonatomic, retain) cvChartFormatterLegend *legendCfg;
@property (nonatomic, assign) int focusIndex;

-(id)initWithConfig:(cvChartFormatterLegend *)cfg;

@end
