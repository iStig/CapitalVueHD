//
//  CVStockRelatedNews.h
//  CapitalVueHD
//
//  Created by Stan on 11-2-28.
//  Copyright 2011 CapitalVue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cvChartView.h"

#define NEWS_SNAPSHOT_DEFAULT_CODE @"000300"
#define fontsize @"4"


#define kNewsPerPage 10

#define kChartXL	10.
#define kChartYL	75.
#define kChartWL	253.
#define kChartHL	138.

#define kChartBGRectL CGRectMake(kChartXL, kChartYL, kChartWL, kChartHL)
#define kChartRectL CGRectMake(kChartXL+7, kChartYL, kChartWL, kChartHL)

#define kLabelCodeRectL				CGRectMake(20, 14, 120, 21)
#define kLabelNameRectL				CGRectMake(20, 44, 245, 22)
#define kLabelLatestRectL			CGRectMake(20, 225, 60, 15)
#define kLabelChangeRectL			CGRectMake(105, 225, 60, 15)
#define kLabelChangePercentRectL	CGRectMake(187, 225, 60, 15)
#define kLabelLatestVRectL			CGRectMake(20, 246, 70, 20)
#define kLabelChangeVRectL			CGRectMake(105, 246, 70, 20)
#define kLabelChangePercentVRectL	CGRectMake(187, 246, 70, 20)

#define kTableRectL					CGRectMake(1, 280, 272, 335)

#define kWebRectL					CGRectMake(300, 15, 600, 580)

@interface CVStockRelatedNews : UIView <UITableViewDelegate,UITableViewDataSource,StockChartDataSource,UIWebViewDelegate>{
	UILabel *_lblCode,*_lblName;
	cvChartView *_chartSnapshot;
	UIImageView *_imgvChartBG;
	UILabel *_lblChange,*_lblLatest,*_lblChangePercent,*_lblChangeValue,*_lblLatestValue,*_lblChangePercentValue;
	UITableView *_tvRelatedNews;
	UIWebView *_wvNewsContent;
	UIButton *_btnBack;
	
	NSArray *_chartData;
	NSMutableArray *_newsList;
	NSDictionary *_newsContent,*_stockInfo;
	
	UIActivityIndicatorView *_indicator;

}
@property (nonatomic,retain) UILabel *lblCode,*lblName;
@property (nonatomic,retain) cvChartView *chartSnapshot;
@property (nonatomic,retain) UIImageView *imgvChartBG;
@property (nonatomic,retain) UILabel *lblChange,*lblLatest,*lblChangePercent,*lblChangeValue,*lblLatestValue,*lblChangePercentValue;
@property (nonatomic,retain) UITableView *tvRelatedNews;
@property (nonatomic,retain) UIWebView *wvNewsContent;
@property (nonatomic,retain) UIButton *btnBack;

@property (nonatomic,retain) NSArray *chartData;
@property (nonatomic,retain) NSMutableArray *newsList;
@property (nonatomic,retain) NSDictionary *newsContent,*stockInfo;

@property (nonatomic,retain) UIActivityIndicatorView *indicator;

-(void)loadData:(NSDictionary *)infoDict;
-(void)adjustSubviews:(UIInterfaceOrientation)orientation;
-(NSString *)stampchangetime:(NSString *)timestamp isDetail:(BOOL)isDetail;
-(NSString *)addImageUrl:(NSString *)strContent;
-(void)loadWebContent:(NSDictionary *)dict;
@end
