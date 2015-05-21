//
//  CVFinancialSummaryIndicesViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cvChartView.h"

#import "CVFinancialSummary.h"

#define CVPORTLET_FINANCE_SUMMARY_PORTRAIT_WIDTH   363
#define CVPORTLET_FINANCE_SUMMARY_PORTRAIT_HEIGHT  163

#define CVPORTLET_FINANCE_SUMMARY_LANDSCAPE_WIDTH  447
#define CVPORTLET_FINANCE_SUMMARY_LANDSCAPE_HEIGHT 190


@interface CVFinancialSummaryIndicesViewController : UIViewController <StockChartDataSource> {
	NSString *symbol;
	NSString *code;
	CVFinancialSummaryType indicesType;
	cvChartView *chartView;
@private
	NSDictionary *dictFromServer;
	NSArray *arrayDataSource;
	UIActivityIndicatorView	*activityIndicator;
	BOOL _ifLoaded;
	BOOL _valuedData;
}

@property (nonatomic, retain) NSString *symbol;
@property (nonatomic, retain) NSString *code;
@property (nonatomic) CVFinancialSummaryType indicesType;
@property (nonatomic, retain) cvChartView *chartView;
@property (nonatomic, assign) BOOL valuedData;

- (void)adjustChartView:(UIInterfaceOrientation)orientation;
- (void)reloadData;

@end
