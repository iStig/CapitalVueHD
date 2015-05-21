//
//  CVMyStockDetailViewController.h
//  CapitalVueHD
//
//  Created by leon on 10-9-28.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVNavigatorDetailController.h"
#import "CVMyStockDetailInfoViewController.h"
#import "CVMyStockNavigatorViewController.h"
#import "cvChartView.h"
#import "CVPeriodSegmentControl.h"
#import "CVNewsrelatedView.h"

#import "CVBlanceSheetViewController.h"
#import "CVIncomeStatementViewController.h"
#import "CVCashFlowViewController.h"

#import "CVMyIndexDetailInfoViewController.h"

#import "CVCompanyProfileViewController.h"
#import "CVCompositeIndexProfileViewController.h"

#import "NSString+Number.h"

#import "CVStockRelatedNews.h"

@interface CVMyStockDetailViewController : UIViewController<CVNavigatorDetailControllerDelegate,
StockChartDataSource, CVPeriodSegmentControlDelegate, UIActionSheetDelegate, CVLoadNewsDelegate,DreamChartDelegate> {
	UIInterfaceOrientation detailOrientation;
	
	UIButton *_buttonAdd;
	UIButton *_buttonShow;
	UILabel  *_labelCode;
	UILabel  *_labelTitle;
	UILabel  *_labelClass;
	
	NSArray *_stockDataArray;
	NSString *_strCurrentType;
	cvChartView *_stockChartView;
	
	CVMyStockNavigatorViewController  *_myStockNavigatorController;
	
	UIButton *_btnRefresh;
	
	UIButton *buttonNews;
	UIButton *buttonBalanceSheet;
	UIButton *buttonIncomeStatement;
	UIButton *buttonCashFlow;
	UIButton *buttonInfo;
	
	CVNewsrelatedView *_newsrelatedView;
	
	BOOL ifLoaded;
	BOOL ifChartLoading;
	
@private
	UIImageView *_imageBackground;
	UIImage *_imgLandscape;
	UIImage *_imgPortrait;
	UIActivityIndicatorView *_detailIndicator;
	
	NSDictionary *_dictCurrentElement;
	
	CVMyStockDetailInfoViewController *_detailInfoController;
	CVMyIndexDetailInfoViewController *_indexDetailInfoController;
	
	CVBlanceSheetViewController *_balanceSheetController;
	CVIncomeStatementViewController *_incomeStatementController;
	CVCashFlowViewController *_cashFlowController;
	CVCompanyProfileViewController *_companyProfileController;
	CVCompositeIndexProfileViewController *_compositeProfileController;
	
	CVStockRelatedNews *stockRelatedNews;
	
	CVPeriodSegmentControl *_segmentControl;
	
	NSTimer *_intradayChartTimer;
	NSTimer *_intradayDetailTimer;
	
	//check if the code was changed
	u_int32_t _randomKey;
	

}

@property (nonatomic) UIInterfaceOrientation detailOrientation;
@property (nonatomic, retain) CVMyStockNavigatorViewController  *myStockNavigatorController;
@property (nonatomic, retain) NSString *_strCurrentType;
@property (nonatomic, assign) id<DreamChartDelegate> dream_delegate;

- (CGRect)addDetailButtonFrame:(UIInterfaceOrientation)orientation;
- (CGRect)showDetailButtonFrame:(UIInterfaceOrientation)orientation;

- (CGRect)classLabelFrame:(UIInterfaceOrientation)orientation;
- (CGRect)detailInfoControllerFrame:(UIInterfaceOrientation)orientation;

- (void)getClassName:(NSString *)CODE;

- (void)createButtons;
- (void)dismissRotationView;
- (void) setButtonImage;

/*
 * Load data from home
 *
 */
-(void)loadDataFromHome:(NSDictionary *)dict;
@end
