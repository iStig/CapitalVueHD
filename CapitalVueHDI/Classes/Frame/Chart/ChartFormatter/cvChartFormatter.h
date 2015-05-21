//
//  cvChartFormatter.h
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cvChartFormatterGeneral.h"
#import "cvChartFormatterHeader.h"
#import "cvChartFormatterLegend.h"
#import "cvChartFormatterPeriodSelector.h"
#import "cvChartFormatterChart.h"


@interface cvChartFormatter : NSObject {
    cvChartFormatterGeneral *General;
    cvChartFormatterHeader *Header;
    cvChartFormatterLegend *Legend;
    cvChartFormatterPeriodSelector *PeriodSelector;
	NSMutableDictionary *localPlistDict;
    NSArray *Charts;
	
	NSMutableDictionary *mutDict;
}

@property (nonatomic, retain) cvChartFormatterGeneral *General;
@property (nonatomic, retain) cvChartFormatterHeader *Header;
@property (nonatomic, retain) cvChartFormatterLegend *Legend;
@property (nonatomic, retain) cvChartFormatterPeriodSelector *PeriodSelector;
@property (nonatomic, retain) NSArray *Charts;

- (id)initWithConfigFile:(NSString *)FileName;
-(void)setTitles:(NSArray *)titleArray;

@end

