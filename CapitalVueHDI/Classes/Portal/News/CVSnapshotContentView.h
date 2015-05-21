//
//  CVSnapshotContentView.h
//  CapitalVueHD
//
//  Created by leon on 10-10-20.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cvChartView.h"

@interface CVSnapshotContentView : UIView <StockChartDataSource> {
	UILabel *labelCode;
	UILabel *labelCompany;
	UILabel *labelOpen;
	UILabel *labelOpenValue;
	UILabel *labelHigh;
	UILabel *labelHighValue;
	UILabel *labelPriorClose;
	UILabel *labelPriorCloseValue;
	UILabel *labelLow;
	UILabel *labelLowValue;
	UILabel *labelPETTM;
	UILabel *labelPETTMValue;
	UILabel *labelPELastyr;
	UILabel *labelPELastyrValue;
	UILabel *labelPBMRQ;
	UILabel *labelPBMRQValue;
	UILabel *labelTotalAShares;
	UILabel *labelTotalASharesValue;
	UILabel *labelVolume;
	UILabel *labelVolumeValue;
	UILabel *labelTurnover;
	UILabel *labelTurnoverValue;
	UILabel *labelLatest;
	UILabel *labelLatestValue;
	UILabel *labelChange;
	UILabel *labelChangeValue;
	UILabel *labelChangePercent;
	UILabel *labelChangePercentValue;
	
	UIImageView *chartBackground;
	UIButton *goMyStockButton;
	
	NSString *_strCode;
	cvChartView *charView;
	NSMutableArray *_arrayDataSource;
	NSDictionary *_dictFromServer;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet UILabel *labelCode;
@property (nonatomic, retain) IBOutlet UILabel *labelCompany;
@property (nonatomic, retain) IBOutlet UILabel *labelOpen;
@property (nonatomic, retain) IBOutlet UILabel *labelOpenValue;
@property (nonatomic, retain) IBOutlet UILabel *labelHigh;
@property (nonatomic, retain) IBOutlet UILabel *labelHighValue;
@property (nonatomic, retain) IBOutlet UILabel *labelPriorClose;
@property (nonatomic, retain) IBOutlet UILabel *labelPriorCloseValue;
@property (nonatomic, retain) IBOutlet UILabel *labelLow;
@property (nonatomic, retain) IBOutlet UILabel *labelLowValue;
@property (nonatomic, retain) IBOutlet UILabel *labelPETTM;
@property (nonatomic, retain) IBOutlet UILabel *labelPETTMValue;
@property (nonatomic, retain) IBOutlet UILabel *labelPELastyr;
@property (nonatomic, retain) IBOutlet UILabel *labelPELastyrValue;
@property (nonatomic, retain) IBOutlet UILabel *labelPBMRQ;
@property (nonatomic, retain) IBOutlet UILabel *labelPBMRQValue;
@property (nonatomic, retain) IBOutlet UILabel *labelTotalAShares;
@property (nonatomic, retain) IBOutlet UILabel *labelTotalASharesValue;
@property (nonatomic, retain) IBOutlet UILabel *labelVolume;
@property (nonatomic, retain) IBOutlet UILabel *labelVolumeValue;
@property (nonatomic, retain) IBOutlet UILabel *labelTurnover;
@property (nonatomic, retain) IBOutlet UILabel *labelTurnoverValue;
@property (nonatomic, retain) IBOutlet UILabel *labelLatest;
@property (nonatomic, retain) IBOutlet UILabel *labelLatestValue;
@property (nonatomic, retain) IBOutlet UILabel *labelChange;
@property (nonatomic, retain) IBOutlet UILabel *labelChangeValue;
@property (nonatomic, retain) IBOutlet UILabel *labelChangePercent;
@property (nonatomic, retain) IBOutlet UILabel *labelChangePercentValue;

@property (nonatomic, retain) IBOutlet UIImageView *chartBackground;
@property (nonatomic, retain) IBOutlet UIButton *goMyStockButton;

@property (nonatomic, retain) NSString *strCode;
@property (nonatomic, retain) NSMutableArray *arrayDataSource;
@property (nonatomic, retain) NSDictionary *dictFromServer;

-(void)createLabel;
-(void)loadData;
-(void)getData:(NSDictionary *)dict;

- (IBAction)clickCode:(id)sender;

@end
