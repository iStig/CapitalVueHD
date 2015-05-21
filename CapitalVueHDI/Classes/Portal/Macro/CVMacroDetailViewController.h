//
//  CVMacroDetailViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/25/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortalSetMacroCoordinates.h"

#import "CVPortletViewController.h"
#import "CVNavigatorDetailController.h"
#import "CVMacroNavigatorViewController.h"
#import "CVNewsrelatedView.h"
#import "cvChartView.h"
#import "CVMacroFormHeaderView.h"
#import "NSString+Number.h"

@interface CVMacroDetailViewController : CVPortletViewController <CVNavigatorDetailControllerDelegate, 
	CVMacroNavigatorViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, StockChartDataSource, CVLoadNewsDelegate> {
@private
	UIButton *_addButton;
	UIButton *_relatedNewsButton;
	UILabel *_titleLabel;
	UIImageView *_backgroundImageView;
	UIImage *_bgImagePortrait;
	UIImage *_bgImageLandscape;
	
	UIActivityIndicatorView *_activityIndicator;
	
	NSArray *_headArray;
	NSArray *_dataArray;
	
	BOOL _valuedData;
	
	cvChartView *_macroChartView;
	CVMacroFormHeaderView *_macroFormHeaderView;
	UITableView *_macroTableView;
	CVNewsrelatedView *_newsrelatedView;
	NSLock *_threadMutex;
}

@property(nonatomic,readonly)BOOL valuedData;

- (void)dismissRotationView;
- (void) setButtonImage;
- (void) afterLoadData:(NSDictionary *)dict;
-(NSMutableArray *)invertOrderArray:(NSMutableArray *)originalArray;
@end
