//
//  CVFinancialSummaryTopMovingSecurityViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVFinancialSummary.h"
#import "CVScrollPageViewController.h"
#import "CVFinancialSummaryTopMovingFormView.h"

#define CVPORTLET_TOP_MOVING_PORTRAIT_WIDTH   343
#define CVPORTLET_TOP_MOVING_PORTRAIT_HEIGHT  200
#define CVPORTLET_TOP_MOVING_LANDSCAPE_WIDTH  429
#define CVPORTLET_TOP_MOVING_LANDSCAPE_HEIGHT 215

@interface CVFinancialSummaryTopMovingSecurityViewController : UIViewController <CVScrollPageViewDeleage, CVFormViewDelegate> {
	CVFinancialSummaryType topMovingType;
	CVFinancialSummaryTopMovingFormView *formView;
	UIInterfaceOrientation portalInterfaceOrientation;
@private
	CVScrollPageViewController *scrollPageController;
	NSDictionary *securityData;
	BOOL _isEmptyData;
	BOOL _ifLoaded;
	BOOL _valuedData;
	
	UIActivityIndicatorView *_indicator;
}

@property (nonatomic) CVFinancialSummaryType topMovingType;
@property (nonatomic, retain) CVFinancialSummaryTopMovingFormView *formView;
@property (nonatomic, assign) UIInterfaceOrientation portalInterfaceOrientation;
@property (nonatomic, assign) BOOL valuedData;

/*
 * It adjusts the width of columns in accordance with the device orientation
 * 
 * @param:	orientation - the device orientation
 * @return:	none
 */
- (void)adjustFormView:(UIInterfaceOrientation)orientation;

- (void)reloadData;

@end
