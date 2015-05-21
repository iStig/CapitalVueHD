//
//  CVStockSnapShotViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/7/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cvChartView.h"

#define CVPORTLET_STOCK_IN_THE_NEW_WIDTH  240
#define CVPORTLET_STOCK_IN_THE_NEW_HEIGHT 211

@interface CVStockSnapShotViewController : UIViewController <StockChartDataSource> {
	cvChartView *charView;
	UILabel *code;
	UILabel *symbol;
	UILabel *price;
	UILabel *desc;
	UIImageView *priceIndicator;
	UIButton *goNewsButton;
	UIButton *goStockButton;
	UIImageView *chartBackground;
	
	NSString *stockCode;
	NSString *strPostID;
	CGFloat previousPrice;
	CGFloat currentPrice;

@private
	NSDictionary *dictFromServer;
	NSArray *arrayDataSource;
	UIActivityIndicatorView	*activityIndicator;
	BOOL isNeedRefresh;
}

@property (nonatomic, retain) cvChartView *charView;

@property (nonatomic, retain) UILabel *code;
@property (nonatomic, retain) UILabel *symbol;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UILabel *desc;
@property (nonatomic, retain) UIImageView *priceIndicator;
@property (nonatomic, retain) UIButton *goStockButton;
@property (nonatomic, retain) UIButton *goNewsButton;
@property (nonatomic, retain) UIImageView *chartBackground;

@property (nonatomic, retain) NSString *stockCode;
@property (nonatomic, retain) NSString *strPostID;
@property (nonatomic, assign) CGFloat previousPrice;
@property (nonatomic, assign) CGFloat currentPrice;
@property (nonatomic, assign) BOOL isNeedRefresh;

/*
 *	set desc label top align;
 */
-(void)adjustDescLabel;

/*
 * It responds the tapping and switches to the portalset of my stock
 * where detail of stock is shown.
 *
 * @param: sender - the obj recieves the event of tap. Here is the goMyStockButton.
 * @return: none
 */
- (void)goMyStock;

/*
 * It responds the tapping and switches to the portalset of news
 * where detail of stock is shown.
 *
 * @param: sender - the obj recieves the event of tap. Here is the goNewsButton.
 * @return: none
 */
- (void)goNews;

@end
