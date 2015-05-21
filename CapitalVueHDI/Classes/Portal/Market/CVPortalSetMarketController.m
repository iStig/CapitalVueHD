    //
//  CVPortalSetMarket.m
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalSetMarketController.h"
#import "CVMarketViewCoordinates.h"
#import "CVSetting.h"

@interface CVPortalSetMarketController()

@property (nonatomic, retain) CVCompositeIndexPortletViewController *compositeIndexController;
@property (nonatomic, retain) CVMostActivePortletViewController *mostActiveController;
@property (nonatomic, retain) CVStockPortletViewController *stockController;

/*
 * It returns the rectangle size and origin of portlet of Composite Index cover flow
 * in accordance with the device orientation
 *
 * @param: orientation - the orientation of device
 * @return: CGRect typed structure
 */
- (CGRect)compositeIndexFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the rectangle size and origin of portlet of Composite Index's
 * Most Active cover in accordance with the device orientation
 *
 * @param: orientation - the orientation of device
 * @return: CGRect typed structure
 */
- (CGRect)mostActiveFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the rectangle size and origin of portlet of Stock
 * in accordance with the device orientation
 *
 * @param: orientation - the orientation of device
 * @return: CGRect typed structure
 */
- (CGRect)stockFrame:(UIInterfaceOrientation)orientation;

@end

@implementation CVPortalSetMarketController

@synthesize compositeIndexController;
@synthesize mostActiveController;
@synthesize stockController;

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
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [super viewDidLoad];
		
	CVCompositeIndexPortletViewController *indexCtrl;
	indexCtrl = [[CVCompositeIndexPortletViewController alloc] init];
	indexCtrl.view.frame = [self compositeIndexFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	self.compositeIndexController = indexCtrl;
	[self.view addSubview:compositeIndexController.view];
	[indexCtrl release];
	
	CVMostActivePortletViewController *activeCtrl;
	activeCtrl = [[CVMostActivePortletViewController alloc] init];
	activeCtrl.frame = [self mostActiveFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	activeCtrl.portalInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	self.mostActiveController = activeCtrl;
	self.compositeIndexController.delegate = self.mostActiveController;
	[self.view addSubview:mostActiveController.view];
	[activeCtrl release];
	
	CVStockPortletViewController *stockCtrl;
	stockCtrl = [[CVStockPortletViewController alloc] init];
	stockCtrl.frame = [self stockFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	stockCtrl.portalInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	self.stockController = stockCtrl;
	[self.view addSubview:stockController.view];
	[stockCtrl release];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
	[compositeIndexController release];
	[mostActiveController release];
	[stockController release];
    [super dealloc];
}

#pragma mark -
#pragma mark private method
/*
 * It returns the rectangle size and origin of portlet of Composite Index cover flow
 * in accordance with the device orientation
 *
 * @param: orientation - the orientation of device
 * @return: CGRect typed structure
 */
- (CGRect)compositeIndexFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVPORTALET_MARKET_COMPOSITE_INDEX_PORTRAIT_X, 
						  CVPORTALET_MARKET_COMPOSITE_INDEX_PORTRAIT_Y, 
						  CVPORTALET_MARKET_COMPOSITE_INDEX_PORTRAIT_WIDTH, 
						  CVPORTALET_MARKET_COMPOSITE_INDEX_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVPORTALET_MARKET_COMPOSITE_INDEX_LANDSCAPE_X, 
						  CVPORTALET_MARKET_COMPOSITE_INDEX_LANDSCAPE_Y, 
						  CVPORTALET_MARKET_COMPOSITE_INDEX_LANDSCAPE_WIDTH, 
						  CVPORTALET_MARKET_COMPOSITE_INDEX_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

/*
 * It returns the rectangle size and origin of portlet of Composite Index's
 * Most Active cover in accordance with the device orientation
 *
 * @param: orientation - the orientation of device
 * @return: CGRect typed structure
 */
- (CGRect)mostActiveFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVPORTALET_MARKET_MOST_ACTIVE_PORTRAIT_X, 
						  CVPORTALET_MARKET_MOST_ACTIVE_PORTRAIT_Y, 
						  CVPORTALET_MARKET_MOST_ACTIVE_PORTRAIT_WIDTH, 
						  CVPORTALET_MARKET_MOST_ACTIVE_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVPORTALET_MARKET_MOST_ACTIVE_LANDSCAPE_X, 
						  CVPORTALET_MARKET_MOST_ACTIVE_LANDSCAPE_Y, 
						  CVPORTALET_MARKET_MOST_ACTIVE_LANDSCAPE_WIDTH, 
						  CVPORTALET_MARKET_MOST_ACTIVE_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

/*
 * It returns the rectangle size and origin of portlet of Stock
 * in accordance with the device orientation
 *
 * @param: orientation - the orientation of device
 * @return: CGRect typed structure
 */
- (CGRect)stockFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVPORTALET_MARKET_STOCK_PORTRAIT_X, 
						  CVPORTALET_MARKET_STOCK_PORTRAIT_Y, 
						  CVPORTALET_MARKET_STOCK_PORTRAIT_WIDTH, 
						  CVPORTALET_MARKET_STOCK_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVPORTALET_MARKET_STOCK_LANDSCAPE_X, 
						  CVPORTALET_MARKET_STOCK_LANDSCAPE_Y, 
						  CVPORTALET_MARKET_STOCK_LANDSCAPE_WIDTH, 
						  CVPORTALET_MARKET_STOCK_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

#pragma mark -
#pragma mark overidden
- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	compositeIndexController.view.frame = [self compositeIndexFrame:orientation];
	[compositeIndexController adjustSubviews:orientation];
	
	mostActiveController.view.frame = [self mostActiveFrame:orientation];
	mostActiveController.portalInterfaceOrientation = orientation;
	[mostActiveController adjustSubviews:orientation];
	
	stockController.view.frame = [self stockFrame:orientation];
	stockController.portalInterfaceOrientation = orientation;
	[stockController adjustSubviews:orientation];
}

- (void)reloadData {
	[compositeIndexController reloadData];
}

@end
