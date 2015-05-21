//
//  CVMyIndexDetailInfoViewController.h
//  CapitalVueHD
//
//  Created by jishen on 11/2/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVMyIndexDetailInfoViewController : UIViewController {
	UILabel *latest;
	UILabel *latestValue;
	UILabel *change;
	UILabel *changeValue;
	UILabel *changeRatio;
	UILabel *changeRatioValue;
	UILabel *open;
	UILabel *openValue;
	UILabel *priorClose;
	UILabel *priorCloseValue;
	UILabel *high;
	UILabel *highValue;
	UILabel *low;
	UILabel *lowValue;
	UILabel *volumex100;
	UILabel *volumex100Value;
	UILabel *turnover000;
	UILabel *turnover000Value;
	UILabel *lblRealTime;
	
	NSDictionary *_nonIntrayDict;
	NSDictionary *_intrayDict;
}

@property (nonatomic, retain) IBOutlet UILabel *latest;
@property (nonatomic, retain) IBOutlet UILabel *latestValue;
@property (nonatomic, retain) IBOutlet UILabel *change;
@property (nonatomic, retain) IBOutlet UILabel *changeValue;
@property (nonatomic, retain) IBOutlet UILabel *changeRatio;
@property (nonatomic, retain) IBOutlet UILabel *changeRatioValue;
@property (nonatomic, retain) IBOutlet UILabel *open;
@property (nonatomic, retain) IBOutlet UILabel *openValue;
@property (nonatomic, retain) IBOutlet UILabel *priorClose;
@property (nonatomic, retain) IBOutlet UILabel *priorCloseValue;
@property (nonatomic, retain) IBOutlet UILabel *high;
@property (nonatomic, retain) IBOutlet UILabel *highValue;
@property (nonatomic, retain) IBOutlet UILabel *low;
@property (nonatomic, retain) IBOutlet UILabel *lowValue;
@property (nonatomic, retain) IBOutlet UILabel *volumex100;
@property (nonatomic, retain) IBOutlet UILabel *volumex100Value;
@property (nonatomic, retain) IBOutlet UILabel *turnover000;
@property (nonatomic, retain) IBOutlet UILabel *turnover000Value;
@property (nonatomic, retain) IBOutlet UILabel *lblRealTime;

@property (nonatomic, copy) NSDictionary *nonIntrayDict;
@property (nonatomic, copy) NSDictionary *intrayDict;

-(void)showTitle:(NSDictionary *)dict;

-(NSString *)getLatestValue;
-(NSString *)getPriorCloseValue;

-(void) showDefault;
//call this method after intraday chart is finish loading
-(void)showData;
// this method can only be called while there is no intra chart data back
-(void)showWhileNoIntradayChart;

@end
