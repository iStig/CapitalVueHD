//
//  cvChartView.h
//  cvChart
//
//  Created by He Jun on 10-8-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cvChartFormatter.h"
#import "stockChartDataSource.h"
#import "CVLineView.h"
#import "cvChartLegend.h"
#import "cvChartPeriodSelector.h"
@protocol DreamChartDelegate

@optional
-(void)chartLoaded;

@end



@interface cvChartView : UIView {
    cvChartFormatter *formatter;
    NSArray *charts;
    id<StockChartDataSource> dataProvider;
    NSArray *financialData;
    NSString *symbolName;
    StockDataTimeFrame_e timeFrame;
    
    CVLineView *_focusline;
	
	CALayer *plotAreaLayer;
	cvChartLegend *legend;
	cvChartPeriodSelector *periodControl;
	
	UIActivityIndicatorView *busyIndicator;
	BOOL loadingData;
	StockDataTimeFrame_e targetTime;
	NSString *targetSymbol;
	UIImageView *errView;
	
	//number of no use point for non-intra while chart is not full filled
	NSInteger _nonIntraInvalidNum;
	
	NSInteger _intrayInvalidNum;
	
	id<DreamChartDelegate> dream_delegate;
}

@property (nonatomic, retain) cvChartFormatter *formatter;
@property (nonatomic, retain) NSArray *charts;
@property (nonatomic, retain) id<StockChartDataSource> dataProvider;
@property (nonatomic, retain) CVLineView *_focusline;
@property (nonatomic, retain) NSArray *financialData;
@property (nonatomic, retain) NSString *symbolName;
@property (nonatomic, assign) StockDataTimeFrame_e timeFrame;
@property (nonatomic, assign) NSInteger nonIntraInvalidNum;
@property (nonatomic, assign) NSInteger intrayInvalidNum;
@property (nonatomic, assign) id<DreamChartDelegate> dream_delegate;
@property (nonatomic, retain) UIActivityIndicatorView *busyIndicator;

- (id)initWithFrame:(CGRect)frame FormatFile:(NSString *)file;

-(void)setTitles:(NSArray *)titleArray;
/*
 * set the symbole name
 */
- (void)defineSymbolName:(NSString *)name timeFrame:(StockDataTimeFrame_e)newTimeFrame;

/*
 * draw the chart synchronously
 */
- (void)drawChart:(NSString *)name timeFrame:(StockDataTimeFrame_e)newTimeFrame;
- (void)resize:(CGRect)newSize;

/*
 * clear chart data
 */
- (void)clearData;

@end
