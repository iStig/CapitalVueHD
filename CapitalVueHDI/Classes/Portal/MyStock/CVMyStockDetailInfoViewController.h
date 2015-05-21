//
//  CVMyStockDetailInfoViewController.h
//  CapitalVueHD
//
//  Created by leon on 10-10-8.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVMyStockDetailInfoViewController : UIViewController {
	UILabel *_labelMoney;
	UILabel *_labelLatest;
	UILabel *_labelChange;
	UILabel *_labelChangePercent;
	UILabel *_labelOpen;
	UILabel *_labelHigh;
	UILabel *_labelPETTM;
	UILabel *_labelPELastyr;
	UILabel *_labelVolume;
	UILabel *_labelPriorClose;
	UILabel *_labelLow;
	UILabel *_labelPBMRQ;
	UILabel *_labelTotalAShares;
	UILabel *_labelTurnover;
	UILabel *lblRealTime;
	
	NSDictionary *_nonIntrayDict;
	NSDictionary *_intrayDict;
	
	UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, retain) UILabel *_labelMoney;
@property (nonatomic, retain) UILabel *_labelLatest;
@property (nonatomic, retain) UILabel *_labelChange;
@property (nonatomic, retain) UILabel *_labelChangePercent;
@property (nonatomic, retain) UILabel *_labelOpen;
@property (nonatomic, retain) UILabel *_labelHigh;
@property (nonatomic, retain) UILabel *_labelPETTM;
@property (nonatomic, retain) UILabel *_labelPELastyr;
@property (nonatomic, retain) UILabel *_labelVolume;
@property (nonatomic, retain) UILabel *_labelPriorClose;
@property (nonatomic, retain) UILabel *_labelLow;
@property (nonatomic, retain) UILabel *_labelPBMRQ;
@property (nonatomic, retain) UILabel *_labelTotalAShares;
@property (nonatomic, retain) UILabel *_labelTurnover;
@property (nonatomic, retain) IBOutlet UILabel *lblRealTime;

@property (nonatomic, copy) NSDictionary *nonIntrayDict;
@property (nonatomic, copy) NSDictionary *intrayDict;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(void) createLabel;
-(void) showDefault;

-(NSString *)getLatestValue;
-(NSString *)getChangeValue;
-(NSString *)getChangePercentValue;
-(NSString *)getOpenValue;
-(NSString *)getPriorCloseValue;

-(void) setData:(NSMutableDictionary *)mutableDict;
//call this method after intraday chart is finish loading
-(void)showData;
// this method can only be called while there is no intra chart data back
-(void)showWhileNoIntradayChart;
@end
