    //
//  CVPortalSetHomeController.m
//  CapitalVueHD
//
//  Created by jishen on 8/30/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalSetHomeController.h"

#import "CVMenuItem.h"
#import "CVHomeViewCoordinates.h"

@interface CVPortalSetHomeController()

@property (nonatomic, retain) CVTodayNewsPortletViewController *todayNewsPortlet;
@property (nonatomic, retain) CVStockInTheNewsPortletViewController *stockInNewsPortlet;
@property (nonatomic, retain) CVFinancialSummaryPortletViewController *financeSummaryPortlet;

/*
 * It returns the frame of portlet of today's news in accrodance with
 * the device orientation.
 *
 * @param: orientation - the orientation of device
 * @return: coordinates and size of portlet
 */
- (CGRect)todayNewsPortletFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the frame of portlet of stock in the news in accrodance with
 * the device orientation.
 *
 * @param: orientation - the orientation of device
 * @return: coordinates and size of portlet
 */
- (CGRect)stockInTheNewsPortletFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the frame of portlet of financial summary in accrodance with
 * the device orientation.
 *
 * @param: orientation - the orientation of device
 * @return: coordinates and size of portlet
 */
- (CGRect)financialSummaryPortletFrame:(UIInterfaceOrientation)orientation;

@end

@implementation CVPortalSetHomeController

@synthesize todayNewsPortlet;
@synthesize stockInNewsPortlet;
@synthesize financeSummaryPortlet;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	CVTodayNewsPortletViewController *todaynews;
	todaynews = [[CVTodayNewsPortletViewController alloc] init];
	todaynews.portalInterfaceOrientation = self.portalInterfaceOrientation;
	todaynews.frame =  [self todayNewsPortletFrame:self.portalInterfaceOrientation];
	self.todayNewsPortlet = todaynews;
	[todaynews release];
	[self.view addSubview:todayNewsPortlet.view];
	
	CVStockInTheNewsPortletViewController *stockinnews;
	stockinnews = [[CVStockInTheNewsPortletViewController alloc] init];
	stockinnews.portalInterfaceOrientation = self.portalInterfaceOrientation;
	stockinnews.frame = [self stockInTheNewsPortletFrame:self.portalInterfaceOrientation];
	self.stockInNewsPortlet = stockinnews;
	[stockinnews release];
	[self.view addSubview:stockInNewsPortlet.view];
	
	
	CVFinancialSummaryPortletViewController *financeSummary;
	financeSummary = [[CVFinancialSummaryPortletViewController alloc] init];
	financeSummary.portalInterfaceOrientation = self.portalInterfaceOrientation;
	financeSummary.frame = [self financialSummaryPortletFrame:self.portalInterfaceOrientation];
	self.financeSummaryPortlet = financeSummary;
	[financeSummary release];
	[self.view addSubview:financeSummaryPortlet.view];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[NSObject cancelPreviousPerformRequestsWithTarget:todayNewsPortlet];
	[NSObject cancelPreviousPerformRequestsWithTarget:stockInNewsPortlet];
	[NSObject cancelPreviousPerformRequestsWithTarget:financeSummaryPortlet];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[todayNewsPortlet release];
	[stockInNewsPortlet release];
	[financeSummaryPortlet release];
    [super dealloc];
}

#pragma mark private methods
/*
 * It returns the frame of portlet of today's news in accrodance with
 * the device orientation.
 *
 * @param: orientation - the orientation of device
 * @return: coordinates and size of portlet
 */
- (CGRect)todayNewsPortletFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVPORTLET_TODAY_NEWS_PORTRAIT_X, 
						  CVPORTLET_TODAY_NEWS_PORTRAIT_Y, 
						  CVPORTLET_TODAY_NEWS_PORTRAIT_WIDTH, 
						  CVPORTLET_TODAY_NEWS_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVPORTLET_TODAY_NEWS_LANDSCAPE_X, 
						  CVPORTLET_TODAY_NEWS_LANDSCAPE_Y,
						  CVPORTLET_TODAY_NEWS_LANDSCAPE_WIDTH, 
						  CVPORTLET_TODAY_NEWS_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

/*
 * It returns the frame of portlet of stock in the news in accrodance with
 * the device orientation.
 *
 * @param: orientation - the orientation of device
 * @return: coordinates and size of portlet
 */
- (CGRect)stockInTheNewsPortletFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_X, 
						  CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_Y, 
						  CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_WIDTH,
						  CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_X,
						  CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_Y,
						  CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_WIDTH,
						  CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

/*
 * It returns the frame of portlet of financial summary in accrodance with
 * the device orientation.
 *
 * @param: orientation - the orientation of device
 * @return: coordinates and size of portlet
 */
- (CGRect)financialSummaryPortletFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVPORTLET_FINANCIAL_SUMMARY_PORTRAIT_X,
						  CVPORTLET_FINANCIAL_SUMMARY_PORTRAIT_Y, 
						  CVPORTLET_FINANCIAL_SUMMARY_PORTRAIT_WIDTH, 
						  CVPORTLET_FINANCIAL_SUMMARY_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVPORTLET_FINANCIAL_SUMMARY_LANDSCAPE_X,
						  CVPORTLET_FINANCIAL_SUMMARY_LANDSCAPE_Y,
						  CVPORTLET_FINANCIAL_SUMMARY_LANDSCAPE_WIDTH,
						  CVPORTLET_FINANCIAL_SUMMARY_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

#pragma mark -
#pragma mark Override
/*
 * It adjust the views postion in accordance to the device orientation.
 *
 * @param: orientation - The orientation of the application’s user interface
 * @return: none
 */
- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	todayNewsPortlet.view.frame = [self todayNewsPortletFrame:orientation];
	todayNewsPortlet.portalInterfaceOrientation = orientation;
	[todayNewsPortlet adjustSubviews:orientation];
	
	stockInNewsPortlet.view.frame = [self stockInTheNewsPortletFrame:orientation];
	stockInNewsPortlet.portalInterfaceOrientation = orientation;
	[stockInNewsPortlet adjustSubviews:orientation];
	
	financeSummaryPortlet.view.frame = [self financialSummaryPortletFrame:orientation];
	financeSummaryPortlet.portalInterfaceOrientation = orientation;
	[financeSummaryPortlet adjustSubviews:orientation];
}

- (void)reloadData {
	[todayNewsPortlet reloadData];
	[stockInNewsPortlet reloadData];
	[financeSummaryPortlet reloadData];
}
@end
