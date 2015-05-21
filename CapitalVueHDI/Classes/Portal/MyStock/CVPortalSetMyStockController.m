    //
//  CVPortalSetMyStockController.m
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalSetMyStockController.h"
#import "CVMyStockNavigatorViewController.h"
#import "CVMyStockDetailViewController.h"
#import "CVPortalSetMyStockCoordinates.h"
#import "CVSetting.h"

@implementation CVPortalSetMyStockController

@synthesize _navigationDetailController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [super viewDidLoad];
	
	//create navigator_detail frame
	CVNavigatorDetailController *aController;
	aController = [[CVNavigatorDetailController alloc] init];
	aController.frame = [self navigationDetailFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	
	CVMyStockNavigatorViewController *aNavigator;
	aNavigator = [[CVMyStockNavigatorViewController alloc] init];
	aNavigator.frame = CGRectMake(0, 0, CVMYSTOCK_NAVIGATOR_LANDSCAPE_WIDTH, CVMYSTOCK_NAVIGATOR_LANDSCAPE_HEIGHT);
	
	CVMyStockDetailViewController *aDetail;
	aDetail = [[CVMyStockDetailViewController alloc] init];
	aDetail.detailOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	aDetail.view.frame = CGRectMake(0, 0, CVMYSTOCK_NAVIGATOR_LANDSCAPE_WIDTH, CVMYSTOCK_NAVIGATOR_LANDSCAPE_HEIGHT);
	aDetail.myStockNavigatorController = aNavigator;
	//aNavigator.navigatorDelegate = aDetail;
	[aNavigator setDelegate:aDetail];
	
	NSArray *array;
	array = [[NSArray alloc] initWithObjects:aNavigator,aDetail,nil];
	aController.viewControllers = array;
	[array release];
	aNavigator.parent = aController._popOverController;
	aController.orientation = [[UIApplication sharedApplication] statusBarOrientation];
	aController.delegate = aDetail;
	aController.view.frame = [self navigationDetailFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	self._navigationDetailController = aController;
	[aController release];
	
	[self.view addSubview:_navigationDetailController.view];
	[self adjustSubviews:[UIApplication sharedApplication].statusBarOrientation];
}

//when click home's stock,then jamp to this function
- (void)updateStockDetailFromHome:(NSDictionary *)dict{
	CVMyStockDetailViewController *detailController;
	detailController = [self._navigationDetailController.viewControllers objectAtIndex:1];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[detailController loadDataFromHome:dict];
	_isStockFromHome = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

/*
 * It returns the rectangle size of navigation-detail frame in accordance with
 * the device orientation.
 *
 * @param:	orientation - device orientation
 * @return:	origin point and size of frame
 */
- (CGRect)navigationDetailFrame:(UIInterfaceOrientation)orientation{
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVMYSTOCK_NAVIGATOR_DETAIL_PORTRAIT_X, 
						  CVMYSTOCK_NAVIGATOR_DETAIL_PORTRAIT_Y, 
						  CVMYSTOCK_NAVIGATOR_DETAIL_PORTRAIT_WIDTH, 
						  CVMYSTOCK_NAVIGATOR_DETAIL_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVMYSTOCK_NAVIGATOR_DETAIL_LANDSCAPE_X, 
						  CVMYSTOCK_NAVIGATOR_DETAIL_LANDSCAPE_Y, 
						  CVMYSTOCK_NAVIGATOR_DETAIL_LANDSCAPE_WIDTH, 
						  CVMYSTOCK_NAVIGATOR_DETAIL_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}


- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	_navigationDetailController.frame = [self navigationDetailFrame:orientation];
	_navigationDetailController.orientation = orientation;
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
	[_navigationDetailController release];
    [super dealloc];
}

- (void)reloadData{
	if (_isStockFromHome) {
		_isStockFromHome = NO;
		return;
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		return;
	}
	NSArray *controllers = _navigationDetailController.viewControllers;
	for (NSObject *controller in controllers) {
		if ([controller respondsToSelector:@selector(reloadData)]) {
			[controller performSelector:@selector(reloadData)];
		}
	}
}


@end
