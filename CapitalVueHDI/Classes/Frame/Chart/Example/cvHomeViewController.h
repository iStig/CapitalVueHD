//
//  cvHomeViewController.h
//  cvChart
//
//  Created by He Jun on 10-8-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cvChartView.h"
#import "cvChartFormatter.h"


@interface cvHomeViewController : UIViewController <StockChartDataSource>{
    cvChartView *simpleChart1;
    cvChartView *simpleChart2;
    cvChartView *simpleChart3;
    cvChartView *indexChart;
    
    cvChartView *stockDetailChart;
    cvChartView *marcoDetailChart;
    NSDictionary *finianceData;
}

@property (nonatomic, retain) cvChartView *simpleChart1;
@property (nonatomic, retain) cvChartView *simpleChart2;
@property (nonatomic, retain) cvChartView *simpleChart3;
@property (nonatomic, retain) cvChartView *indexChart;
@property (nonatomic, retain) NSDictionary *finianceData;

@property (nonatomic, retain) cvChartView *stockDetailChart;
@property (nonatomic, retain) cvChartView *macroDetailChart;


@end
