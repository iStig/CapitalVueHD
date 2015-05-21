//
//  cvChartPeriodSelector.h
//  cvChart
//
//  Created by He Jun on 10-8-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "cvChartFormatter.h"


@interface cvChartPeriodSelector : UIControl {
    int selectedIndex;
    int numberOfSegments;
    cvChartFormatterPeriodSelector *periodCfg;
	NSMutableArray *paths;
}

@property (nonatomic, assign) int selectedIndex;
@property(nonatomic, readonly) int numberOfSegments;
@property (nonatomic, retain) cvChartFormatterPeriodSelector *periodCfg;

- (id)initWithConfig:(cvChartFormatterPeriodSelector *)cfg;

@end
