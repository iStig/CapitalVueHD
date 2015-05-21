//
//  CVPortalSetHomeController.h
//  CapitalVueHD
//
//  Created by jishen on 8/30/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPortalSetController.h"

#import "CVTodayNewsPortletViewController.h"
#import "CVStockInTheNewsPortletViewController.h"
#import "CVFinancialSummaryPortletViewController.h"

#import "CVMacroFormView.h"

@interface CVPortalSetHomeController : CVPortalSetController {	
@private
	CVTodayNewsPortletViewController *todayNewsPortlet;
	CVStockInTheNewsPortletViewController *stockInNewsPortlet;
	CVFinancialSummaryPortletViewController *financeSummaryPortlet;
	CVMacroFormView *_macroView;
}

@end
